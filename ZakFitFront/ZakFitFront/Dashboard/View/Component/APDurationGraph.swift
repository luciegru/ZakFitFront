//
//  APDurationGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import SwiftUI
import Charts

struct APDurationGraph: View {
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(APObjectiveViewModel.self) var APObjectiveVM
    @State private var selectedPeriod: String = "semaine"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Durée d'activité physique")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                CustomDropdownMenu(
                    selectedOption: $selectedPeriod,
                    options: ["semaine", "mois", "année"]
                )
                .frame(width: 150)
            }
            .padding(.horizontal)
            
            // Filtrer et cumuler les durées
            let filteredAPs = filterAPs(period: selectedPeriod)
            let cumulativeData = calculateCumulative(aps: filteredAPs)
            
            Chart {
                // Ligne d'objectif
                if let objective = APObjectiveVM.APObj?.APTime {
                    RuleMark(
                        y: .value("Objectif", objective)
                    )
                    .foregroundStyle(.white.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Objectif : \(objective) minutes")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
                
                // Ligne cumulative
                ForEach(cumulativeData, id: \.0) { point in
                    LineMark(
                        x: .value("Temps", point.0),
                        y: .value("Minutes", point.1)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.customYellow, .customBlue, .customPurple, .customPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white)
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.2))
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white)
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.2))
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    private func filterAPs(period: String) -> [AP] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period.lowercased() {
        case "semaine":
            return userAPVM.APs.filter { $0.date.isInSameWeek(as: now) }
        case "mois":
            return userAPVM.APs.filter { $0.date.isInSameMonth(as: now) }
        case "année":
            return userAPVM.APs.filter {
                calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
            }
        default:
            return userAPVM.APs
        }
    }
    
    private func calculateCumulative(aps: [AP]) -> [(Date, Int)] {
        // Grouper par jour et additionner les durées
        let groupedByDay = Dictionary(grouping: aps) { ap in
            Calendar.current.startOfDay(for: ap.date)
        }
        .mapValues { aps in
            aps.reduce(0) { $0 + $1.duration }
        }
        .sorted { $0.key < $1.key }
        
        // Calculer le cumulatif
        var cumulative = 0
        var result: [(Date, Int)] = []
        
        for (date, duration) in groupedByDay {
            cumulative += duration
            result.append((date, cumulative))
        }
        
        return result
    }
}

#Preview {
    APDurationGraph()
        .environment(UserAPViewModel())
        .environment(APObjectiveViewModel())
        .background(Color.black)
}

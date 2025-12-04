//
//  WeightEvolutionGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import SwiftUI
import Charts

struct WeightEvolutionGraph: View {
    @Environment(UserWeightViewModel.self) var weightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjectiveVM
    @State private var selectedPeriod: String = "semaine"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Évolution du poids")
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
            
            // Filtrer les données selon la période
            let filteredData = filterWeightData(period: selectedPeriod)
            
            // Déterminer la valeur max pour l'échelle Y
            let maxWeight = max(
                filteredData.map { $0.1 }.max() ?? 0,
                weightObjectiveVM.WeightObj?.targetWeight ?? 0
            ) + 2
            
            let minWeight = max(0, (filteredData.map { $0.1 }.min() ?? 0) - 2)

            Chart {
                // Ligne d'objectif
                if let target = weightObjectiveVM.WeightObj?.targetWeight {
                    RuleMark(
                        y: .value("Objectif", target)
                    )
                    .foregroundStyle(.white.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Objectif : \(String(format: "%.1f", target))kg")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }

                // Ligne poids réel
                ForEach(filteredData, id: \.0) { point in
                    LineMark(
                        x: .value("Date", point.0),
                        y: .value("Poids", point.1)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.customPink, Color.customPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartYScale(domain: minWeight...maxWeight)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel(format: dateFormat(for: selectedPeriod))
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
    
    private func filterWeightData(period: String) -> [(Date, Double)] {
        let calendar = Calendar.current
        let now = Date()
        
        let filtered: [UserWeight]
        
        switch period.lowercased() {
        case "semaine":
            filtered = weightVM.weightList.filter { $0.date.isInSameWeek(as: now) }
        case "mois":
            filtered = weightVM.weightList.filter { $0.date.isInSameMonth(as: now) }
        case "année":
            filtered = weightVM.weightList.filter {
                calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
            }
        default:
            filtered = weightVM.weightList
        }
        
        // Grouper par jour et prendre le dernier poids du jour
        let groupedByDay = Dictionary(grouping: filtered) { weight in
            calendar.startOfDay(for: weight.date)
        }
        .compactMapValues { weights in
            weights.sorted { $0.date > $1.date }.first?.weight
        }
        .sorted { $0.key < $1.key }
        
        return groupedByDay.map { ($0.key, $0.value) }
    }
    
    private func dateFormat(for period: String) -> Date.FormatStyle {
        switch period.lowercased() {
        case "semaine":
            return .dateTime.weekday(.abbreviated)
        case "mois":
            return .dateTime.day()
        case "année":
            return .dateTime.month(.abbreviated)
        default:
            return .dateTime.month().day()
        }
    }
}

#Preview {
    WeightEvolutionGraph()
        .environment(UserWeightViewModel())
        .environment(WeightObjectiveViewModel())
        .background(Color.black)
}

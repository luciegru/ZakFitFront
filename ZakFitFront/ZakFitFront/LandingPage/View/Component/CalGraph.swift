//
//  Graph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI
import Charts

struct CalGraph: View {
    @Environment(UserAPViewModel.self) var userAPViewModel
    @Environment(APObjectiveViewModel.self) var APObjectiveVM
    var selectedMonth: Date
    
    var body: some View {
        let APNeeded = userAPViewModel.APs.filter { $0.date.isInSameMonth(as: selectedMonth) }

        VStack(alignment: .leading, spacing: 8) {
            Text("Calories brûlées chaque jour ce mois-ci")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Chart {
                // ⭐ Ligne d'objectif
                RuleMark(
                    y: .value("Objectif", APObjectiveVM.APObj?.burnedCal ?? 2000)
                )
                .foregroundStyle(.white.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1))
                .annotation(position: .top, alignment: .leading) {
                    Text("Objectif")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                
                ForEach(APNeeded) { AP in
                    LineMark(
                        x: .value("Jours", AP.date),
                        y: .value("Calories brûlées", AP.burnedCal)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(.customYellow),
                                Color(.customBlue),
                                Color(.customPurple),
                                Color(.customPink)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom) // ⭐ Seulement sur LineMark
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.day())
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
                        .foregroundStyle(.white.opacity(0.002))
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}



#Preview {
//    CalGraph().environment(UserAPViewModel()).environment(APObjectiveViewModel())
}

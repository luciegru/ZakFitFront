//
//  WeightGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI
import Charts

struct WeightGraph: View {
    @Environment(UserWeightViewModel.self) var weightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjectiveVM

    var body: some View {
        // Normaliser et trier les données par date
        let weightData = weightVM.weightList
            .map { (Calendar.current.startOfDay(for: $0.date), $0.weight) }
            .sorted { $0.0 < $1.0 }

        // Déterminer la valeur max pour l'échelle Y
        let maxWeight = max(
            weightData.map { $0.1 }.max() ?? 0,
            weightObjectiveVM.WeightObj?.targetWeight ?? 0
        ) + 2 // marge
        
        

        VStack(alignment: .leading, spacing: 8) {
            Text("Évolution du poids")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            Chart {
                // Ligne d'objectif
                if let target = weightObjectiveVM.WeightObj?.targetWeight {
                    RuleMark(
                        y: .value("Objectif", target)
                    )
                    .foregroundStyle(.white.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Objectif : \(String(format: "%.1f", target))")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }

                // Ligne poids réel
                ForEach(weightData, id: \.0) { point in
                    LineMark(
                        x: .value("Date", point.0),
                        y: .value("Poids", point.1)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(.customBlue), Color(.customPurple)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartXScale(domain: .automatic) // s'adapte automatiquement
            .chartYScale(domain: 0...maxWeight)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.month().day())
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
}

#Preview {
    WeightGraph()
        .environment(UserWeightViewModel())
        .environment(WeightObjectiveViewModel())
}

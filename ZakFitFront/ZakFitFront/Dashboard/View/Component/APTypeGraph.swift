//
//  APTypeGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import SwiftUI
import Charts

struct APTypeGraph: View {
    @Environment(UserAPViewModel.self) var userAPVM
    
    // Couleurs pour chaque type d'activité
    let activityColors: [String: Color] = [
        "marche": .customPink,
        "musculation": .customPurple,
        "course": .customYellow,
        "yoga": .customBlue,
        "natation": .customGreen,
        "vélo": .customLightBlue,
        "sport collectif": .customLightPink
    ]
    
    var body: some View {
        // 1️⃣ Calculer activityCounts séparément
        let grouped = Dictionary(grouping: userAPVM.APs, by: { $0.type })
        let counts: [ActivityCount] = grouped.map { (type, aps) in
            ActivityCount(type: type, count: aps.count)
        }.sorted { $0.count > $1.count }
        
        // 2️⃣ Maximum pour Y-axis
        let maxCount = counts.map { $0.count }.max() ?? 10
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Types d'activité préférés")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if counts.isEmpty {
                Text("Aucune activité enregistrée")
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
            } else {
                // 3️⃣ Chart simplifié
                Chart {
                    ForEach(counts) { item in
                        BarMark(
                            x: .value("Type", item.type.capitalized),
                            y: .value("Nombre de séances", item.count)
                        )
                        .foregroundStyle(activityColors[item.type] ?? .gray)
                        .cornerRadius(8)
                    }
                }
                .frame(height: 250)
                .chartYScale(domain: 0...maxCount)
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel().foregroundStyle(.white)
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisValueLabel().foregroundStyle(.white)
                        AxisGridLine().foregroundStyle(.white.opacity(0.2))
                    }
                }
                .chartYAxisLabel("Nombre de séances", alignment: .center)
                
                // 4️⃣ Légende simplifiée
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(counts.prefix(5)) { item in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(activityColors[item.type] ?? .gray)
                                .frame(width: 12, height: 12)
                            
                            Text(item.type.capitalized)
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(item.count) séance\(item.count > 1 ? "s" : "")")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    APTypeGraph()
        .environment(UserAPViewModel())
        .background(Color.black)
}

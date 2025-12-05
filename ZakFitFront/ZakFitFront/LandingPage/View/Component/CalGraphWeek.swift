//
//  CalGraphWeek.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI
import Charts

struct CalGraphWeek: View {
    @Environment(UserAPViewModel.self) var userAPViewModel
    @Environment(APObjectiveViewModel.self) var APObjectiveVM
    var selectedDay: Date
    
    var body: some View {
        let APNeeded = userAPViewModel.APs.filter { $0.date.isInSameWeek(as: selectedDay) }


        VStack(alignment: .leading, spacing: 8) {
            

            let calendar = Calendar.current
            
            let groupedByDay = Dictionary(grouping: APNeeded) { ap in
                        Calendar.current.startOfDay(for: ap.date)
                    }
                    .mapValues { aps in
                        aps.reduce(0) { $0 + $1.burnedCal }
                    }
                    .sorted { $0.key < $1.key }
            
            let normalized = groupedByDay.map { ($0.key, $0.value) }



            
            Chart {
                // Ligne d'objectif
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
                
                ForEach(normalized, id: \.0) { point in
                    LineMark(
                        x: .value("Jours", point.0),
                        y: .value("Calories brûlées", point.1)
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
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.day(.defaultDigits))
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.2))
                }
            }
            .chartYScale(domain: 0...(max(
                (normalized.map { $0.1 }.max() ?? 0),
                (APObjectiveVM.APObj?.burnedCal ?? 0)
            ) + 50))
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}

#Preview {
//    CalGraphWeek()
}

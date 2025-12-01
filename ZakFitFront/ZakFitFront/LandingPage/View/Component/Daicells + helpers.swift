//
//  Daicells + helpers.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let activity: DayActivity?
    let isSelected: Bool
    let isToday: Bool
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(activity != nil ? .black : .white)
            .frame(width: 39, height: 39)
            .background(activity?.type.color ?? Color.gray.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isToday ? Color.customYellow : (isSelected ? Color.white : Color.clear), lineWidth: 3)
            )
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

struct WeekDetailView: View {
    let selectedDate: Date
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Détail de la semaine")
                .font(.title)
                .foregroundColor(.white)
        }
        .navigationTitle("Semaine")
        .navigationBarTitleDisplayMode(.inline)
    }
}




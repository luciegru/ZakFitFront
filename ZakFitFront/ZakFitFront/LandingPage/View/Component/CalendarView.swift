//
//  CalendarView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//
import SwiftUI

struct CalendarMonthView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @Binding var selectedDate: Date
    var onDoubleTap: (() -> Void)? = nil
    var onMonthChange: ((Date) -> Void)? = nil

    
    // Tes ViewModels
    @Environment(UserAPViewModel.self) private var userAPVM
    @Environment(MealViewModel.self) private var mealVM
    @Environment(LoginViewModel.self) private var loginVM
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    private let weekDays = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]
    
    var body: some View {
        VStack(spacing: 24) {
            monthSelector
            calendarGrid
            legend
        }
        .padding()
        .task {
            // Charge les données au démarrage
            await loadData()
        }
        .onChange(of: viewModel.currentMonth) { oldValue, newValue in
            Task {
                await loadData()
            }
            
            onMonthChange?(newValue)
        }

    }
    
    private func loadData() async {
        // Charge depuis tes ViewModels
        await mealVM.getMyMeal()
        await userAPVM.getMyAP(userId: loginVM.currentUser?.id ?? UUID())
        viewModel.loadActivities(meals: mealVM.mealList, userAPs: userAPVM.APs)
    }
    
    private var monthSelector: some View {
        HStack {
            Button(action: { viewModel.changeMonth(by: -1) }) {
                
                
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(viewModel.currentMonth.formatted(.dateTime.year()))
                    .bold()
                    .foregroundStyle(Color.white)
                Text(viewModel.currentMonth.formatted(.dateTime.month(.wide)))
                    .bold()
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
            
            Button(action: { viewModel.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 15) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            activity: viewModel.getActivity(for: date),
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date)
                        )
                        .onTapGesture {
                            selectedDate = date
                            viewModel.handleDayTap(date) {
                                onDoubleTap?()
                            }
                        }
                    } else {
                        Color.clear
                    }
                }
            }
        }
    }
    
    private var legend: some View {
        HStack(spacing: 16) {
            LegendItem(color: .customLightYellow, text: "Repas")
            LegendItem(color: .customLightPurple, text: "Activité physique")
            LegendItem(color: .customLightBlue, text: "Repas et activité")
        }
        .font(.caption)
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: viewModel.currentMonth)
        
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let adjustedWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        
        var days: [Date?] = Array(repeating: nil, count: adjustedWeekday - 1)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
}


// MARK: - Preview
#Preview {
//    CalendarMonthView()
}


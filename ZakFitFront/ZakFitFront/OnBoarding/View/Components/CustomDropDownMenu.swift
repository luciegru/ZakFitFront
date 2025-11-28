//
//  CustomDropDownMenu.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct CustomDropdownMenu: View {
    @State private var isExpanded = false
    @Binding var selectedOption: String
    @State private var searchText = ""
    var options: [String]
    
    var filteredOptions: [String] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(selectedOption)
                    .foregroundStyle(Color.white)
                    .bold()
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(Color.white)
            }
            .padding()
            .background(Color.middleGrey)
            .cornerRadius(5)
        }
        .frame(height: 50)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: DropdownPreferenceKey.self,
                    value: isExpanded ? geo.frame(in: .global) : nil
                )
            }
        )
        .sheet(isPresented: $isExpanded) {
            dropdownSheet
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.hidden)
        }
    }
    
    private var dropdownSheet: some View {
        VStack(spacing: 0) {
            TextField("Rechercher...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredOptions, id: \.self) { option in
                        optionRow(option)
                    }
                }
            }
        }
        .background(Color.customLightPurple)
    }
    
    private func optionRow(_ option: String) -> some View {
        Text(option)
            .font(.body.bold())
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(selectedOption == option ? Color.white.opacity(0.2) : Color.clear)
            .onTapGesture {
                selectedOption = option
                isExpanded = false
                searchText = ""
            }
    }
}

struct DropdownPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?
    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue()
    }
}

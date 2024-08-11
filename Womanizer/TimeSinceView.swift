//
//  TimeSinceView.swift
//  Womanizer
//
//  Created by Sabrina Bea on 5/28/24.
//

import SwiftUI

struct TimeSinceView: View {
    @State var elapsedDays = 0
    @State var elapsedMonths = 0
    @State var elapsedYears = 0
    let startDate: Date
    let message: String
    let suffix: String?
    let mode: TimeSinceMode
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            Text(message)
                .bold()
                .foregroundStyle(Color.accentColor)
            HStack {
                if elapsedYears > 0 {
                    Text("\(elapsedYears) year\(s(elapsedYears)),")
                }
                if elapsedMonths > 0 {
                    Text("\(elapsedMonths) month\(s(elapsedMonths)),")
                }
                Text("\(elapsedDays) day\(s(elapsedDays))")
                
                if let suffix = suffix {
                    Text(suffix)
                }
            }
            Text(startDate.formattedAsDate)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .onAppear() {
            update()
        }
        .padding()
    }
    
    private func update() {
        var offset = 0
        switch mode {
        case .exclusive:
            offset = -1
        case .includeEnd:
            offset = 0
        case .includeStartAndEnd:
            offset = 1
        }
        
        let endDate = Date().startOfDayUsingFiveAmCutoff
        
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day], from: startDate, to: endDate)

        elapsedYears = components.year!
        elapsedMonths = components.month!
        elapsedDays = components.day! + offset
    }
    
    private func s(_ num: Int) -> String {
        return num == 1 ? "" : "s"
    }
}

#Preview {
    TimeSinceView(startDate: Date().addDays(-100), message: "You got here:", suffix: "ago", mode: .includeEnd)
}

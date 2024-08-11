//
//  ContentView.swift
//  Womanizer
//
//  Created by Sabrina Bea on 5/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var hrtStartDate = Date.fromComponents(year: 2024, month: 5, day: 28, hour: 5)!.startOfDayUsingFiveAmCutoff
    @State var secondEggDate = Date.fromComponents(year: 2023, month: 12, day: 4, hour: 5)!.startOfDayUsingFiveAmCutoff
    @State var firstEggDate = Date.fromComponents(year: 2015, month: 10, day: 14, hour: 5)!.startOfDayUsingFiveAmCutoff
    @State var elapsedTotalDays = 0.0
    @State var completionPercentage = 0.0

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Text("Womanizing...")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.accentColor)
                        .padding(.bottom)
                    ProgressView(value: completionPercentage, total: 100)
                    HStack {
                        Text("Elapsed Time: \(Int(elapsedTotalDays)) days")
                        Spacer()
                        Text("Time Remaining: Calculating...")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    TransitionView()
                    // .frame(width: 300.0, height: 300.0)
                    TimeSinceView(startDate: hrtStartDate, message: "You've been on this journey for", suffix: nil, mode: .includeStartAndEnd)
                    TimeSinceView(startDate: secondEggDate, message: "You started packing", suffix: "ago", mode: .includeEnd)
                    TimeSinceView(startDate: firstEggDate, message: "You felt the call of adventure", suffix: "ago", mode: .includeEnd)
                }
                .onAppear {
                    updateTime()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    updateTime()
                }
                .padding()
                .frame(width: proxy.size.width, height: proxy.size.height)
            }.refreshable() {
                updateTime()
            }
        }
    }
    
    private func updateTime() {
        elapsedTotalDays = (Date().timeIntervalSince(hrtStartDate) / 86400) + 1
        switch elapsedTotalDays {
        case 0..<480:
            completionPercentage = 0.00023409272 * elapsedTotalDays * elapsedTotalDays
        case 480..<1825:
            completionPercentage = logarithm(elapsedTotalDays, base: 1.03) - 155
        default:
            completionPercentage = 99 + (elapsedTotalDays - 1825)/25550
        }
    }
    
    private func logarithm(_ argument: Double, base: Double) -> Double {
        return log2(argument) / log2(base)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

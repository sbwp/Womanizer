//
//  TransitionView.swift
//  Womanizer
//
//  Created by Sabrina Bea on 5/31/24.
//

import SwiftUI

struct TransitionView: View {
    @State var trimStart: CGFloat = 0
    @State var trimEnd: CGFloat = 0
    @State var state: TransitionState = .growing
    @State var lastLoopTime: Date = Date().addDays(-1)
    @State var animationTrigger = false
    
    var body: some View {
        ZStack {
            Text("🚶‍♂️")
                .scaleEffect(CGSize(width: -1.0, height: 1.0))
            Text("💃")
                .background(Color.black)
                .mask {
                    Circle()
                        .trim(from: trimStart, to: trimEnd)
                        .stroke(style: StrokeStyle(lineWidth: 300))
                        .rotationEffect(.degrees(95))
                }
        }
        .onChange(of: animationTrigger) {
            flip()
        }
        .onAppear {
            let secondsSinceLoop = Calendar.current.dateComponents([.second], from: lastLoopTime, to: Date()).second ?? 15
            if secondsSinceLoop > 10 {
                flip()
            }
        }
        .font(.system(size: 275))
    }
    
    func flip() {
        lastLoopTime = Date()
        if state == .growing && trimEnd > 0.9999 {
            trimEnd = 1
            trimStart = 0
            state = .shrinking
        } else if state == .shrinking && trimStart > 0.9999 {
            trimEnd =  0
            trimStart = 0
            state = .growing
        }
        
        withAnimation(.linear(duration: 5)) {
            if state == .growing {
                trimEnd = 1
            } else {
                trimStart = 1
            }
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                animationTrigger = !animationTrigger
            }
        }
    }
}

enum TransitionState {
    case growing
    case shrinking
}

#Preview {
    TransitionView()
}

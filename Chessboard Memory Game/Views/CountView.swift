//
//  CountView.swift
//  Chessboard Memory Game
//
//  Created by Berke Turanlıoğlu on 24.01.2023.
//

import SwiftUI

struct CountView: View {
    
    @State var progress: CGFloat = 1.0
    @State var isFinished: Bool = false
    
    @Binding var timer: Timer.TimerPublisher
    @Binding var startTime: CGFloat
    @State var countStart: CGFloat
    @Binding var score: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 70)
                .overlay {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin:.round
                        ))
                        .foregroundColor(Color("darkGreen"))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: progress)
                        .shadow(color: Color(red:225/255,green:225/255,blue:225/255),radius: 10)
                }
            
            Text("\(Int(startTime))")
                .font(.title)
                .onReceive(timer) { time in
                    startTime -= 1
                    progress -= 1/countStart
                    if startTime <= 0 {
                        timer.connect().cancel()
                        isFinished.toggle()
                        startTime = countStart
                        progress = 1.0
                    }
                }
        }
        .padding(.top)
        .alert("Time is up!", isPresented: $isFinished, actions: {}) {
            Text("Your score is: \(score)\nGood job!")
        }
    }
}

struct CountView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

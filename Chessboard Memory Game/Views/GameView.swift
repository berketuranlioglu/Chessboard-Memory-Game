//
//  GameView.swift
//  Chessboard Memory Game
//
//  Created by Berke Turanlıoğlu on 24.01.2023.
//

import Combine
import SwiftUI

struct GameView: View {
    
    @State var time: CGFloat = 30.0
    @State var timerSubscription: Cancellable?
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var isStartPressed: Bool = false
    @State var score: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    CountView(timer: $timer, startTime: $time, countStart: time, score: $score)
                        .padding(.all)
                    
                    ChessboardView(geo: geo, score: $score, gameStarted: $isStartPressed)
                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.width*1.1)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                    HStack {
                        Stepper(value: $time, in: 30...180, step: 30) {
                            Text("\(Image(systemName: "clock")): \(Int(time))")
                        }
                        .disabled(isStartPressed)
                        
                        if time <= 0 {
                            Button(action: startTimer) {
                                Text("Start")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color("darkGreen"))
                            .animation(.easeOut, value: isStartPressed)
                            .padding(.all)
                        } else {
                            Button(action: startTimer) {
                                Text(timerSubscription == nil ? "Start" : "Pause")
                                    .foregroundColor(timerSubscription == nil
                                                     ? .white : .red)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(timerSubscription == nil
                                  ? Color("darkGreen")
                                  : Color.gray.opacity(0.2))
                            .animation(.easeOut, value: isStartPressed)
                            .padding(.all)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.all)
                }
            }
        }
    }
    
    func startTimer() {
        isStartPressed.toggle()
        if self.timerSubscription == nil {
            self.timer = Timer.publish(every: 1, on: .main, in: .common)
            self.timerSubscription = self.timer.connect()
        } else {
            self.timerSubscription?.cancel()
            self.timerSubscription = nil
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

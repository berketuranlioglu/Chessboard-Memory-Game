//
//  ChessboardView.swift
//  Chessboard Memory Game
//
//  Created by Berke Turanlıoğlu on 24.01.2023.
//

import SwiftUI

struct ChessboardView: View {
    
    @State var geo: GeometryProxy
    @Binding var score: Int
    @Binding var gameStarted: Bool
    
    @State var coordinate: String = updateCoordinate()
    @State var isTapped: Bool = false
    
    var body: some View {
        VStack {
            Text("\(coordinate)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.all)
                .scaleEffect(isTapped ? 1.3 : 1)
                .animation(.spring(), value: isTapped)
            
            VStack(spacing: 0) {
                ForEach(1...8, id:\.self) { row in
                    HStack(spacing: 0) {
                        ForEach(1...8, id:\.self) { file in
                            ZStack(alignment: .topLeading) {
                                Squares(row: row, file: file, coordinate: $coordinate,
                                        isTapped: $isTapped, score: $score, gameStarted: $gameStarted)
                                
                                if row == 8 {
                                    Coordinates(row: row, file: file,
                                                isLetters: true)
                                        .offset(x: geo.size.width/14, y: geo.size.width/20)
                                }
                                if file == 1 {
                                    Coordinates(row: row, file: file,
                                                isLetters: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct Coordinates: View {
    
    let row: Int
    let file: Int
    let isLetters: Bool
    
    var body: some View {
        Text(isLetters
             ? "\(String(Character(UnicodeScalar(96 + file)!)))"
             : "\(9 - row)")
            .fontWeight(.semibold)
            .foregroundColor((row + file) % 2 == 1
                             ? Color(red:0.95, green:0.95, blue:0.95)
                             : Color("darkGreen"))
            .offset(x: 2, y: 2)
    }
}

struct Squares: View {
    
    let row: Int
    let file: Int
    @Binding var coordinate: String
    @Binding var isTapped: Bool
    @Binding var score: Int
    @Binding var gameStarted: Bool
    
    @State var whiteR = 0.95
    @State var whiteG = 0.95
    @State var whiteB = 0.95
    @State var darkR = 0.0
    @State var darkG = 0.4
    @State var darkB = 0.2
    
    var body: some View {
        Rectangle()
            .foregroundColor((row + file) % 2 == 0
                             ? Color(red: whiteR, green: whiteG, blue: whiteB)
                             : Color(red: darkR, green: darkG, blue: darkB))
            .onTapGesture {
                if gameStarted {
                    isTapped.toggle()
                    
                    // if player gets it correct
                    if String(coordinate.first!) == String(Character(UnicodeScalar(96 + file)!))
                        && String(coordinate.last!) == String(9 - row) {
                        score += 1
                        withAnimation {
                            self.coordinate = updateCoordinate()
                        }
                    }
                    
                    withAnimation {
                        updateColor(true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isTapped.toggle()
                        withAnimation {
                            updateColor(false)
                        }
                    }
                }
            }
    }
    
    func updateColor(_ isTapped: Bool) {
        if isTapped {
            whiteR = 0.7
            whiteG = 0.7
            whiteB = 0.7
            darkR = 0.0
            darkG = 0.3
            darkB = 0.3
        } else {
            whiteR = 0.95
            whiteG = 0.95
            whiteB = 0.95
            darkR = 0.0
            darkG = 0.4
            darkB = 0.2
        }
    }
}

func updateCoordinate() -> String {
    let rows = [1,2,3,4,5,6,7,8]
    let files = ["a","b","c","d","e","f","g","h"]
    
    return files.randomElement()! + String(rows.randomElement()!)
}

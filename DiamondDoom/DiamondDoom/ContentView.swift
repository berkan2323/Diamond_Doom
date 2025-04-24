//
//  ContentView.swift
//  DiamondDoom
//
//  Created by Berkan Aydın on 23.04.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            GridGameView()
        }
    }
}


#Preview {
    ContentView()
}
















struct GridGameView: View {
    @State private var grid: [[GridItem]] = GridGameView.generateGrid()
    @State private var score: Int = 0
    @State private var gameOver: Bool = false
    @State private var showGameOverDialog: Bool = false
    
    struct GridItem {
        var isRevealed: Bool = false
        var content: ItemType
    }
    
    enum ItemType {
        case diamond
        case bomb
        
        var imageName: String {
            switch self {
            case .diamond:
                return "diamond"
            case .bomb:
                return "close"
            }
        }
    }
    
    static func generateGrid() -> [[GridItem]] {
        var grid = (0..<5).map { _ in (0..<5).map { _ in GridItem(isRevealed: false, content: .diamond) } }
        
        let bombRow = Int.random(in: 0..<5)
        let bombCol = Int.random(in: 0..<5)
        grid[bombRow][bombCol].content = .bomb
        
        return grid
    }
    
    func handleTap(row: Int, col: Int) {
        if gameOver || grid[row][col].isRevealed { return }
        grid[row][col].isRevealed = true
        
        if grid[row][col].content == .bomb {
            gameOver = true
            showGameOverDialog = true
        } else {
            score += 10
        }
    }
    
    func resetGame() {
        grid = GridGameView.generateGrid()
        score = 0
        gameOver = false
        showGameOverDialog = false
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Spacer().frame(width: 10)
                Text("Diamond / Doom")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack{
                Spacer().frame(width: 10)
                Text("Score:")
                    .font(.title)
                    .padding(.bottom, 10)
                    .foregroundColor(.white)
                    .opacity(0.3)
                Text("\(score)")
                    .font(.title)
                    .padding(.bottom, 10)
                    .foregroundColor(.white)
                    .opacity(1)
                Spacer()
            }
            
            ForEach(0..<5, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { col in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(grid[row][col].isRevealed ? Color.gray.opacity(0.1) : Color.gray.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            if grid[row][col].isRevealed {
                                Image(grid[row][col].content.imageName)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .scaledToFit()
                            }
                        }
                        .onTapGesture {
                            handleTap(row: row, col: col)
                        }
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showGameOverDialog) {
            Alert(
                title: Text("Game Over!"),
                message: Text("You hit a bomb! Your score: \(score)"),
                dismissButton: .default(Text("Play Again")) {
                    resetGame()
                }
            )
        }
    }
}


//
//  GameView.swift
//  Mastermind
//
//  Created by Marco Mustapic on 03/08/2025.
//
import SwiftUI

struct GameEnding {
    let won: Bool
    let answer: String
}

struct GameView: View {
    @State var game = Game()
    @Environment(GameConfiguration.self) private var gameConfiguration
    let didFinish: (GameEnding) -> Void

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Time remaining: \(Int(game.remainingTime))")
            HStack {
                ForEach(0..<4) { index in
                    InputView(characterIndex: index)
                        .accessibilityIdentifier("inputView\(index)")
                }
            }
        }
        .environment(game)
        .padding()
        .onAppear() {
            game.start(word: gameConfiguration.initialWord, gameTime: gameConfiguration.gameTime)
        }
        .onReceive(timer) { _ in
            game.update(delta: 1.0)
        }
        .onChange(of: game.gameState) { oldState, newState in
            if newState != .playing {
                let won = newState == .won
                didFinish(GameEnding(won: won, answer: game.answer))
            }
        }
    }
}

struct InputView: View {
    let characterIndex: Int
    @State var text: String = ""
    @Environment(Game.self) private var game

    var body: some View {
        VStack {
            TextField("?", text: $text)
                .padding()
                .multilineTextAlignment(.center)
                .background(backgroundColor)
                .cornerRadius(8)
                .onChange(of: text) { oldText, newText in
                    if newText.count >= 1 {
                        text = String(newText.prefix(1))
                    }
                    game.guess(index: characterIndex, value: text.first)
                }
        }
        .onAppear() {
            text = ""   // this is needed to reset the textfields when the game is re-started
        }
    }

    var backgroundColor: Color {
        switch game.guessStates[characterIndex] {
        case .correct: Color.green
        case .unknown: Color.init(white: 0.95)
        case .wrongPlace: Color.orange
        case .notInWord: Color.red
        }
    }
}

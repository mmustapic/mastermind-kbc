//
//  ContentView.swift
//  Mastermind
//
//  Created by Marco Mustapic on 02/08/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    @State var game = Game()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Time remaining: \(Int(game.remainingTime))")
            HStack {
                InputView(characterIndex: 0)
                InputView(characterIndex: 1)
                InputView(characterIndex: 2)
                InputView(characterIndex: 3)
            }
        }
        .environment(game)
        .padding()
        .onReceive(timer) { _ in
            game.update(delta: 1.0)
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
#Preview {
    ContentView()
}

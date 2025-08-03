//
//  ContentView.swift
//  Mastermind
//
//  Created by Marco Mustapic on 02/08/2025.
//

import SwiftUI

enum ViewPath: Hashable {
    case ending(won: Bool, answer: String)
}

struct ContentView: View {
    @State private var path: [ViewPath] = []
    @State private var launchConfiguration = GameConfiguration()

    var body: some View {
        NavigationStack(path: $path) {
            GameView() { gameEnding in
                path.append(ViewPath.ending(won: gameEnding.won, answer: gameEnding.answer))
            }
            .navigationDestination(for: ViewPath.self) { viewPath in
                switch viewPath {
                case .ending(let won, let answer):
                    EndingView(answer: answer, won: won) {
                        path = []
                    }
                    .navigationBarBackButtonHidden()
                    .toolbar(.hidden)
                }
            }
        }
        .environment(launchConfiguration)
    }
}

@Observable class GameConfiguration {
    var initialWord: String? = nil
    var gameTime: TimeInterval = 60.0   // 60 seconds

    init() {
        if CommandLine.arguments.contains("--uitesting") {
            initialWord = "ABCD"
            gameTime = 12.0  // 12 seconds for testing
        }
    }
}

#Preview {
    ContentView()
}

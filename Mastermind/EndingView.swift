//
//  EndingView.swift
//  Mastermind
//
//  Created by Marco Mustapic on 03/08/2025.
//

import SwiftUI

struct EndingView: View {
    let answer: String
    let won: Bool
    let didTapPlay: () -> Void

    var body: some View {
        VStack {
            Text("Answer was \(answer)")
                .accessibilityIdentifier("answerText")
            Text("You \(won ? "Won" : "Lost")!")
                .accessibilityIdentifier("statusText")
            Button {
                didTapPlay()
            } label: {
                Text("Play again")
                    .padding()
            }
            .accessibilityIdentifier("playAgainButton")
            .foregroundStyle(Color.white)
            .background(Color.green)
            .cornerRadius(8)
        }
    }
}

#Preview {
    EndingView(answer: "WXYZ", won: true) {

    }
}

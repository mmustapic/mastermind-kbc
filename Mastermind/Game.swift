//
//  Game.swift
//  Mastermind
//
//  Created by Marco Mustapic on 02/08/2025.
//
import SwiftUI

@Observable class Game {
    private let allowedCharacters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let wordSize = 4

    enum GuessState {
        case correct
        case wrongPlace
        case notInWord
        case unknown
    }

    var guessStates: [GuessState] = []
    private var guesses: [Character?] = []
    private var answers: [Character] = []

    var answer: String {
        return String(answers)
    }

    func guess(index: Int, value: Character?) {
        // only allow guesses in allowed characters
        guard index >= 0,
              index < wordSize else { fatalError("Index should be < \(wordSize)") }

        // if value is nil or not allowed, we consider it a non guess, so state is unknown
        guard let value,
              allowedCharacters.contains(value) else {
            guesses[index] = nil
            guessStates[index] = .unknown
            return
        }

        guesses[index] = value

        // check if the guess is in the answers
        if let answerIndex = answers.firstIndex(of: value) {
            // if in answer, check if it is in the same position
            guessStates[index] = answerIndex == index ? .correct : .wrongPlace
        } else {
            guessStates[index] = .notInWord
        }
    }

    func randomize() {
        let word = [0..<wordSize].reduce("") { partialResult, _ -> String in
            partialResult + String(allowedCharacters.randomElement()!)
        }
        setWord(word: word)
    }

    func setWord(word: String) {
        guard word.count == wordSize else { fatalError("Words should have \(wordSize) characters") }
        answers = word.map { $0 }
        guesses = answers.map { _ -> Character? in
            nil
        }
        guessStates = answers.map { _ -> GuessState in
            .unknown
        }
    }
}

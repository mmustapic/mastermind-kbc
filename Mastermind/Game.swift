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
    private let gameTime = TimeInterval(floatLiteral: 60.0) // 60 seconds

    // state for character guesses
    enum GuessState {
        case correct
        case wrongPlace
        case notInWord
        case unknown
    }

    enum GameState {
        case playing
        case won
        case lost
    }

    var guessStates: [GuessState] = []
    var answer: String {
        return String(answers)
    }
    private(set) var remainingTime: TimeInterval
    var gameState: GameState


    private var guesses: [Character?] = []
    private var answers: [Character] = []

    init(word: String? = nil) {
        remainingTime = gameTime
        gameState = .playing
        if let word {
            setWord(word: word)
        } else {
            randomize()
        }
    }

    func update(delta: TimeInterval) {
        remainingTime = max(0.0, remainingTime-delta)
        if remainingTime == 0.0 {
            let finalGuesses = guesses.compactMap { $0 }
            gameState = finalGuesses == answers ? .won : .lost
        }
    }

    // used to guess a character and update the guess states
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
        updateGuessStates()
    }

    private func updateGuessStates() {
        guessStates = guesses.enumerated().map { index, guess -> GuessState in
            guard let guess else { return .unknown }
            // first check if it is the correct character, because
            // we might find the same character BEFORE and thing it is in the wrong place
            if guess == answers[index] {
                return .correct
            } else if let answerIndex = answers.firstIndex(of: guess),
                      answerIndex != index {    // answerIndex will always be != index, since whe checked that before, but it is here for clarity
                return .wrongPlace
            } else {
                return .notInWord
            }
        }
    }

    private func randomize() {
        let word = Array(0..<wordSize).reduce("") { partialResult, i -> String in
            return partialResult + String(allowedCharacters.randomElement()!)
        }
        setWord(word: word)
    }

    private func setWord(word: String) {
        guard word.count == wordSize else { fatalError("Words should have \(wordSize) characters") }
        answers = word.map { $0 }
        guesses = answers.map { _ -> Character? in
            nil
        }
        guessStates = answers.map { _ -> GuessState in
            .unknown
        }
        print("Word is \(answer)")
    }
}

//
//  Game.swift
//  Mastermind
//
//  Created by Marco Mustapic on 02/08/2025.
//
import SwiftUI

@Observable class Game {
    private static let allowedCharacters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private static let wordSize = 4

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

    init() {
        remainingTime = 1.0
        gameState = .playing
        setWord(word: "AAAA")
    }

    func start(word: String? = nil, gameTime: TimeInterval) {
        remainingTime = gameTime
        gameState = .playing
        if let word {
            setWord(word: word)
        } else {
            randomize()
        }
        print("Word is \(answer)")
    }

    func update(delta: TimeInterval) {
        remainingTime = max(0.0, remainingTime-delta)
        let correctlyGuessed = guesses.compactMap { $0 } == answers
        if correctlyGuessed || remainingTime == 0.0 {
            gameState = correctlyGuessed ? .won : .lost
        }
    }

    // used to guess a character and update the guess states
    func guess(index: Int, value: Character?) {
        // only allow guesses in allowed characters
        guard index >= 0,
              index < Game.wordSize else { fatalError("Index should be < \(Game.wordSize)") }

        // if value is nil or not allowed, we consider it a non guess, so state is unknown
        guard let value,
              Game.allowedCharacters.contains(value) else {
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
        let word = Array(0..<Game.wordSize).reduce("") { partialResult, i -> String in
            return partialResult + String(Game.allowedCharacters.randomElement()!)
        }
        setWord(word: word)
    }

    private func setWord(word: String) {
        guard word.count == Game.wordSize else { fatalError("Words should have \(Game.wordSize) characters") }
        answers = word.map { $0 }
        guesses = answers.map { _ -> Character? in
            nil
        }
        guessStates = answers.map { _ -> GuessState in
            .unknown
        }
    }
}

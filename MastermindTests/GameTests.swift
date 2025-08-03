//
//  MastermindTests.swift
//  MastermindTests
//
//  Created by Marco Mustapic on 02/08/2025.
//

import Testing
@testable import Mastermind

struct GameTests {
    @Test
    func testInit() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        #expect(game.answer == "XYFG")
    }

    @Test
    func testInitRandom() {
        let game = Game()
        #expect(game.answer.count == 4)
    }

    @Test
    func testGuessesAllCorrect() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "X")
        game.guess(index: 1, value: "Y")
        game.guess(index: 2, value: "F")
        game.guess(index: 3, value: "G")
        #expect(game.guessStates[0] == .correct)
        #expect(game.guessStates[1] == .correct)
        #expect(game.guessStates[2] == .correct)
        #expect(game.guessStates[3] == .correct)
    }

    @Test
    func testGuessesAllNotInWord() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "A")
        game.guess(index: 1, value: "B")
        game.guess(index: 2, value: "C")
        game.guess(index: 3, value: "D")
        #expect(game.guessStates[0] == .notInWord)
        #expect(game.guessStates[1] == .notInWord)
        #expect(game.guessStates[2] == .notInWord)
        #expect(game.guessStates[3] == .notInWord)
    }

    @Test
    func testGuessesAllUnknown() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        #expect(game.guessStates[0] == .unknown)
        #expect(game.guessStates[1] == .unknown)
        #expect(game.guessStates[2] == .unknown)
        #expect(game.guessStates[3] == .unknown)
    }

    @Test
    func testGuessesAllWrongPlace() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "Y")
        game.guess(index: 1, value: "F")
        game.guess(index: 2, value: "G")
        game.guess(index: 3, value: "X")
        #expect(game.guessStates[0] == .wrongPlace)
        #expect(game.guessStates[1] == .wrongPlace)
        #expect(game.guessStates[2] == .wrongPlace)
        #expect(game.guessStates[3] == .wrongPlace)
    }

    @Test
    func testGuessesMixed() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "X")
        game.guess(index: 1, value: "C")
        game.guess(index: 3, value: "Y")
        #expect(game.guessStates[0] == .correct)
        #expect(game.guessStates[1] == .notInWord)
        #expect(game.guessStates[2] == .unknown)
        #expect(game.guessStates[3] == .wrongPlace)
    }

    @Test
    func testGuessesDuplicate() {
        let game = Game()
        game.start(word: "XYXG", gameTime: 60.0)
        game.guess(index: 0, value: "X")
        game.guess(index: 1, value: "Y")
        game.guess(index: 2, value: "X")
        game.guess(index: 3, value: "G")
        #expect(game.guessStates[0] == .correct)
        #expect(game.guessStates[1] == .correct)
        #expect(game.guessStates[2] == .correct)
        #expect(game.guessStates[3] == .correct)
    }

    @Test
    func testGameStateStarted() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        #expect(game.remainingTime == 60.0)
        #expect(game.gameState == .playing)
    }

    @Test
    func testGameStatePlaying() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.update(delta: 1.5)
        #expect(game.remainingTime == 58.5)
        #expect(game.gameState == .playing)
    }

    @Test
    func testGameStateUpdateToZero() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.update(delta: 60.0)
        #expect(game.remainingTime == 0.0)
    }

    @Test
    func testGameStateUpdatePastMaxTime() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.update(delta: 70.0)
        #expect(game.remainingTime == 0.0)
    }

    @Test
    func testGameStateWon() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "X")
        game.guess(index: 1, value: "Y")
        game.guess(index: 2, value: "F")
        game.guess(index: 3, value: "G")
        game.update(delta: 60.0)
        #expect(game.gameState == .won)
    }

    @Test
    func testGameStateLostNotPlayed() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.update(delta: 60.0)
        #expect(game.gameState == .lost)
    }

    @Test
    func testGameStateLost() {
        let game = Game()
        game.start(word: "XYFG", gameTime: 60.0)
        game.guess(index: 0, value: "X")
        game.guess(index: 1, value: "C")
        game.guess(index: 3, value: "Y")
        game.update(delta: 60.0)
        #expect(game.gameState == .lost)
    }
}

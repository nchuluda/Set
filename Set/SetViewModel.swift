//
//  SetGameVM.swift
//  Set - VIEW MODEL
//
//  Created by Nathan on 9/18/23.
//

import SwiftUI

class Set: ObservableObject {
    @Published var model: SetGame
    
    private static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    init() {
        model = SetGame()
    }
    
    var cards: Array<SetGame.Card> { model.cards }
    var cardsInPlay: Array<SetGame.Card> { model.cardsInPlay }
    var completedSets: Array<SetGame.CardSet> { model.completedSets }
    var deckEmpty: Bool { model.deckEmpty }
    var winGame: Bool { model.winGame }
    
    func choose(_ card: SetGame.Card) { model.choose(card) }
    
    func dealThreeCards() {
        model.dealThreeCards()
    }
    
    func newGame() {
        model = SetGame()
    }
    
    func setExistsIn(cardsInPlay: Array<SetGame.Card>) {
        model.setExistsIn(cardsInPlay: cardsInPlay)
    }
}

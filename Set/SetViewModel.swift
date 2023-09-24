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
    var deckEmpty: Bool { model.deckEmpty }
    
    func choose(_ card: SetGame.Card) { model.choose(card) }
    
    func dealThreeCards() {
        model.dealThreeCards()
    }
}

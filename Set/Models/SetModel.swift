//
//  SetGame.swift
//  Set - MODEL
//
//  Created by Nathan on 9/18/23.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var cards: Array<Card>
    private(set) var cardsInPlay: Array<Card>
    private(set) var deckEmpty = false
    private(set) var winGame = false
    private(set) var showHint = false
    private(set) var existingSet: Array<CardSet>
    private(set) var completedSets: Array<CardSet>
    private(set) var setId = 1
    
    
//    let colors = [Color.red, Color.purple, Color.green]
//    let counts = [1, 2, 3]
//    let fills = ["empty", "stripe", "solid"]
//    let shapes = ["triangle", "rectangle", "capsule"]
    
    init() {
        cards = []
        cardsInPlay = []
        completedSets = []
        existingSet = []
        var cardId = 1
        for color in Colors.allCases {
            for count in Counts.allCases {
                for fill in Fills.allCases {
                    for shape in Shapes.allCases {
                        cards.append(Card(id: cardId, color: color.rawValue, count: count.rawValue, fill: fill.rawValue, shape: shape.rawValue, isSelected: false, isSet: false))
                        cardId += 1
                    }
                }
            }
        }
        cards = cards.shuffled()
        // Move 12 cards from cards to cardsInPlay
        for index in 0...11 {
            cardsInPlay.append(cards[index])
            cards.remove(at: index)
        }
//        print("cards.count = \(cards.count)")
//        print("cardsInPlay.count = \(cardsInPlay.count)")
    }
    
    var indexOfFirstSelectedCard: Int? {
        get { return cardsInPlay.indices.filter { index in cardsInPlay[index].isSelected }.first2 }
        set { cardsInPlay.indices.forEach { cardsInPlay[$0].isSelected = (newValue == $0) } }
    }
    
    var indexOfSecondSelectedCard: Int? {
        get { return cardsInPlay.indices.filter { index in cardsInPlay[index].isSelected }.last2 }
        set { cardsInPlay.indices.forEach { cardsInPlay[$0].isSelected = (newValue == $0) } }
    }
    
    var indexOfThirdSelectedCard: Int? {
        get { return cardsInPlay.indices.filter { index in cardsInPlay[index].isSelected }.middle }
        set { cardsInPlay.indices.forEach { cardsInPlay[$0].isSelected = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        
        if let chosenIndex = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            
            if !cardsInPlay[chosenIndex].isSelected && !cardsInPlay[chosenIndex].isSet {
                cardsInPlay[chosenIndex].isSelected.toggle()
                
                if let potentialMatchIndex1 = indexOfFirstSelectedCard {
//                    print("index of first selected card: \(potentialMatchIndex1)")
                    print("card 1: \(cardsInPlay[potentialMatchIndex1])")
                    
                    if let potentialMatchIndex2 = indexOfSecondSelectedCard {
//                        print("index of second selected card: \(potentialMatchIndex2)")
                        print("card 2: \(cardsInPlay[potentialMatchIndex2])")
                        
                        if let potentialMatchIndex3 = indexOfThirdSelectedCard {
                            print("card 3: \(cardsInPlay[potentialMatchIndex3])")
                            
                            var card1 = cardsInPlay[potentialMatchIndex1]
                            var card2 = cardsInPlay[potentialMatchIndex2]
                            var card3 = cardsInPlay[potentialMatchIndex3]
                                                        
                            if isSet(card1: card1, card2: card2, card3: card3) {
                                card1.isSelected = false
                                card2.isSelected = false
                                card3.isSelected = false
                                completedSets.append(CardSet(cards: [card1, card2, card3]))
                                setId += 1
                                
                                cardsInPlay.remove(atOffsets: [potentialMatchIndex1, potentialMatchIndex2, potentialMatchIndex3])
                                
                                if cardsInPlay.count < 12 {
                                    if cards.count >= 3 {
                                        dealThreeCards()
                                    } else {
                                        if cardsInPlay.count == 0 { winGame = true }
                                    }
                                }
                                
                            } else { notSetReset(pmi1: potentialMatchIndex1, pmi2: potentialMatchIndex2, pmi3: potentialMatchIndex3) }
                        }
                    }
                }
            // Clicking selected card deselects it
            } else if cardsInPlay[chosenIndex].isSelected {
                cardsInPlay[chosenIndex].isSelected.toggle()
            }
        }
    }
    
    func isSet(card1: Card, card2: Card, card3: Card) -> Bool {
        if (card1.color == card2.color && card2.color == card3.color) ||
            (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color) {
            if (card1.fill == card2.fill && card2.fill == card3.fill) ||
                (card1.fill != card2.fill && card2.fill != card3.fill && card1.fill != card3.fill) {
                if (card1.count == card2.count && card2.count == card3.count) ||
                    (card1.count != card2.count && card2.count != card3.count && card1.count != card3.count) {
                    if (card1.shape == card2.shape && card2.shape == card3.shape) ||
                        (card1.shape != card2.shape && card2.shape != card3.shape && card1.shape != card3.shape) {
                        return true
                    } else { return false }
                } else { return false }
            } else { return false }
        } else { return false }
    }
    
    mutating func setExistsIn(cardsInPlay: Array<Card>) -> Array<CardSet> {
        existingSet = []
        
        // Skip checking sets if there are not at least 3 cards
        if cardsInPlay.count >= 3 {

            // Skip checking sets if three cards are not all different
            for card1 in cardsInPlay {
                for card2 in cardsInPlay {
                    if card1 != card2 {
                        for card3 in cardsInPlay {
                            if (card1 != card3 && card2 != card3) {
                                
                                // Check if is set
                                if isSet(card1: card1, card2: card2, card3: card3) {

                                    // Add found set to array existingSet
                                    existingSet.append(CardSet(cards: [card1, card2, card3]))
                                    
                                    // Stop looping as soon as first set is found
                                    return existingSet
                                }
                            }
                        }
                    }
                }
            }
        }
        // No sets found, existingSet is returned empty
        return existingSet
    }
    
    mutating func dealThreeCards() {
        if !deckEmpty {
            for index in 0...2 {
                cardsInPlay.append(cards[index])
            }
            cards.removeSubrange(0...2)
            if cards.count == 0 { deckEmpty = true }
        }
    }
    
    mutating func shuffle() {
        cardsInPlay.shuffle()
    }
    
    mutating func notSetReset(pmi1: Int, pmi2: Int, pmi3: Int) {
        print("Oops! Not a set.")
        cardsInPlay[pmi1].isSelected.toggle()
        cardsInPlay[pmi2].isSelected.toggle()
        cardsInPlay[pmi3].isSelected.toggle()
    }
    
    struct Card: Equatable, Identifiable, Hashable {
        var id: Int
        var color: Color
        var count: Int
        var fill: String
        var shape: String
        var isSelected = false
        var isSet = false
    }
    
    struct CardSet {
//        var id: Int
        var cards: Array<Card>
    }
}

extension Array {
    var first2: Element? {
        count == 2 || count == 3 ? first : nil
    }
}

extension Array {
    var last2: Element? {
        count == 2 || count == 3 ? last : nil
    }
}

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        if count == 3 {
            let middleIndex = (count > 1 ? count - 1 : count) / 2
            return self[middleIndex]
        } else { return nil }
    }
}

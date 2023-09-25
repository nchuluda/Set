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
    
    enum Shapes1: CaseIterable {
        case triangle
        case rectangle
        case capsule
    }
    
    let colors = [Color.red, Color.purple, Color.green]
    let counts = [1, 2, 3]
    let fills = ["empty", "stripe", "solid"]
    let shapes = ["triangle", "rectangle", "capsule"]
    
    init() {
        cards = []
        cardsInPlay = []
        var cardId = 1
        for color in colors {
            for count in counts {
                for fill in fills {
                    for shape in shapes {
                        cards.append(Card(id: cardId, color: color, count: count, fill: fill, shape: shape, isSelected: false, isSet: false))
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
                            
                            let card1 = cardsInPlay[potentialMatchIndex1]
                            let card2 = cardsInPlay[potentialMatchIndex2]
                            let card3 = cardsInPlay[potentialMatchIndex3]
                            
                            if (card1.color == card2.color && card2.color == card3.color) ||
                                (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color) {
                                
                                if (card1.fill == card2.fill && card2.fill == card3.fill) ||
                                    (card1.fill != card2.fill && card2.fill != card3.fill && card1.fill != card3.fill) {
                                    
                                    if (card1.count == card2.count && card2.count == card3.count) ||
                                        (card1.count != card2.count && card2.count != card3.count && card1.count != card3.count) {
                                        
                                        if (card1.shape == card2.shape && card2.shape == card3.shape) ||
                                            (card1.shape != card2.shape && card2.shape != card3.shape && card1.shape != card3.shape) {
                                            
                                            print("Congratulations! This is a set.")
//                                            cardsInPlay[potentialMatchIndex1].isSet = true
//                                            cardsInPlay[potentialMatchIndex2].isSet = true
//                                            cardsInPlay[potentialMatchIndex3].isSet = true
                                            
                                            cardsInPlay.remove(atOffsets: [potentialMatchIndex1, potentialMatchIndex2, potentialMatchIndex3])
                                            if cardsInPlay.count < 12 {
                                                dealThreeCards()
                                            }
                                        // Not a set, clear selection
                                        } else { notSetReset(pmi1: potentialMatchIndex1, pmi2: potentialMatchIndex2, pmi3: potentialMatchIndex3) }
                                    } else { notSetReset(pmi1: potentialMatchIndex1, pmi2: potentialMatchIndex2, pmi3: potentialMatchIndex3) }
                                } else { notSetReset(pmi1: potentialMatchIndex1, pmi2: potentialMatchIndex2, pmi3: potentialMatchIndex3) }
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
    
    struct Card: Equatable, Identifiable {
        var id: Int
        var color: Color
        var count: Int
        var fill: String
        var shape: String
        var isSelected = false
        var isSet = false
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

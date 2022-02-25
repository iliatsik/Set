//
//  SetViewModel.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 17.02.22.
//

import Foundation

class SetViewModel {
    
    var set = SetModel()
    var score = 0
    
    
    func newGame() {
        score = 0
        set.availableCards.removeAll()
        set.currentCards.removeAll()
        set.selectedCards.removeAll()
        
        generateAllCardCombinations()
        addCards(numberOfCardsToSelect: 24)
    }
    
    private func generateAllCardCombinations() {
        for color in Card.Color.allCases {
            for symbol in Card.Symbol.allCases {
                for number in Card.Number.allCases {
                    for shading in Card.Shading.allCases {
                        let card = Card(cardSymbol: symbol, cardColor: color, cardNumber: number, cardShading: shading)
                        set.availableCards.append(card)
                    }
                }
            }
        }
    }
    
    private func addCard() {
        let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
        set.currentCards.append(selectedCard)
    }
    
    func addCards(numberOfCardsToSelect numberOfCards: Int) {
        for _ in 0..<numberOfCards {
            addCard()
        }
    }
    
    func cardIsSelected(card: Card) -> Bool {
        return set.selectedCards.firstIndex(of: card) != nil
    }
    
    func isSet() -> Bool {
        if set.selectedCards.count != 3 {
            return false
        }
        
        if set.selectedCards[0].cardColor == set.selectedCards[1].cardColor {
            if set.selectedCards[0].cardColor != set.selectedCards[2].cardColor {
                return false
            }
        } else if set.selectedCards[1].cardColor == set.selectedCards[2].cardColor {
            return false
        } else if (set.selectedCards[0].cardColor == set.selectedCards[2].cardColor) {
            return false
        }
        
        if set.selectedCards[0].cardNumber == set.selectedCards[1].cardNumber {
            if set.selectedCards[0].cardNumber != set.selectedCards[2].cardNumber {
                return false
            }
        } else if set.selectedCards[1].cardNumber == set.selectedCards[2].cardNumber {
            return false
        } else if (set.selectedCards[0].cardNumber == set.selectedCards[2].cardNumber) {
            return false
        }
        
        if set.selectedCards[0].cardShading == set.selectedCards[1].cardShading {
            if set.selectedCards[0].cardShading != set.selectedCards[2].cardShading {
                return false
            }
        } else if set.selectedCards[1].cardShading == set.selectedCards[2].cardShading {
            return false
        } else if (set.selectedCards[0].cardShading == set.selectedCards[2].cardShading) {
            return false
        }
        
        if set.selectedCards[0].cardSymbol == set.selectedCards[1].cardSymbol {
            if set.selectedCards[0].cardSymbol != set.selectedCards[2].cardSymbol {
                return false
            }
        } else if set.selectedCards[1].cardSymbol == set.selectedCards[2].cardSymbol {
            return false
        } else if (set.selectedCards[0].cardSymbol == set.selectedCards[2].cardSymbol) {
            return false
        }
        return true
    }
    
    func select(card: Card) {
        if set.selectedCards.count == 3 && isSet() {
            set.selectedCards.forEach {
                if let selectedCardInGameIndex = set.currentCards.firstIndex(of: $0) {
                    set.currentCards.remove(at: selectedCardInGameIndex)
                    if set.availableCards.count > 0 {
                        let selectedCard = set.availableCards.remove(at: Int.random(in: 0..<set.availableCards.count))
                        set.currentCards.insert(selectedCard, at: selectedCardInGameIndex)
                    }
                }
            }
            set.selectedCards.removeAll()
            score += 3
        } else if set.selectedCards.count == 3 && !isSet() {
            set.selectedCards.removeAll()
            score -= 1
        }
        
        if let cardToSelect = set.selectedCards.firstIndex(of: card) {
            // Card is already selected, so we are removing it from the selection
            set.selectedCards.remove(at: cardToSelect)
        } else {
            set.selectedCards.append(card)
        }
    }
}


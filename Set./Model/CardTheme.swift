//
//  CardTheme.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

class CardTheme {
    
    private static func setSymbol(withCard: Card) -> String {
        switch withCard.cardSymbol {
        case .circle:
            return "●"
        case .square:
            return "◼︎"
        case .triangle:
            return "▲"
        }
    }
    
    private static func setColor(withCard: Card) -> UIColor {
        switch withCard.cardColor {
        case .red:
            return UIColor(named: "red") ?? .red
        case .green:
            return UIColor(named: "green") ?? .green
        case .purple:
            return UIColor(named: "purple") ?? .purple
        }
    }
    
    private static func setNumber(withCard: Card, withSymbol: String) -> String {
        switch withCard.cardNumber {
        case .one:
            return "\(withSymbol)"
        case .two:
            return "\(withSymbol) \(withSymbol)"
        case .three:
            return "\(withSymbol) \(withSymbol) \(withSymbol)"
        }
    }
    
    private static func setShading(withCard: Card, withColor: UIColor, withNumber: String) -> NSAttributedString {
        var attributedString: [NSAttributedString.Key : Any] = [:]
        switch withCard.cardShading {
        case .filled:
            attributedString[.strokeWidth] = 1
            attributedString[.foregroundColor] = withColor
        case .outlined:
            attributedString[.strokeWidth] = -1
            attributedString[.foregroundColor] = withColor
        case .striped:
            attributedString[.strokeWidth] = -1
            attributedString[.foregroundColor] = withColor.withAlphaComponent(3/20)
        }
        
        return NSAttributedString(string: withNumber, attributes: attributedString)
    }
    
    static func setCard(card: Card) -> NSAttributedString {
        let color = setColor(withCard: card)
        let symbol = setSymbol(withCard: card)
        let number = setNumber(withCard: card, withSymbol: symbol)
        let shading = setShading(withCard: card, withColor: color, withNumber: number)
        
        return shading
    }
}

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
    
    static func setCard(card: Card, button: UIButton, isSelected: Bool, isSet: Bool) {
        let color = setColor(withCard: card)
        let symbol = setSymbol(withCard: card)
        let number = setNumber(withCard: card, withSymbol: symbol)
        let shading = setShading(withCard: card, withColor: color, withNumber: number)

        button.setAttributedTitle(shading, for: .normal)

        if isSelected {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.gray.cgColor
            button.backgroundColor = .clear
            
            if isSet {
                UIView.animate(withDuration: 0.8,
                               delay: 0.3,
                               options: [],
                               animations: {
                    button.layer.borderColor = UIColor.green.cgColor
                    button.layer.borderWidth = 3.0
                }, completion: nil)
                
                UIView.animate(withDuration: 1.0,
                               delay: 0.1,
                               options: [],
                               animations: {
                    button.setAttributedTitle(nil, for: .normal)
                    button.backgroundColor = .black
                    button.layer.borderColor = UIColor.clear.cgColor
                    button.layer.borderWidth = 0.0
                }, completion: nil)
                
            } else {
                button.backgroundColor = .clear
            }
        } else {
            button.backgroundColor = .gray
        }
    }
}

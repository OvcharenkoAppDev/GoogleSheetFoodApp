//
//  FUITypography.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 21.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit

enum FUIFontName : String {
    case regular    = "Menlo-Regular"
    case bold       = "Menlo-Bold"
    case semibold   = "Menlo-SemiBold"
}
enum LetterSpacing : Float {
    case spacing1 = 0.2
    case spacing2 = 0.5
    case spacing3 = 1.5
}

enum FUIFontSize : Float {
    case size1  = 28
    case size2  = 20
    case size3  = 18
    case size4  = 16
    case size5  = 14
    case size6  = 13
    case size7  = 12
    case size8  = 32
    case size9  = 24
}
extension String {
    func FUI_Title(color : UIColor) -> NSAttributedString {
    return attributedString(size: FUIFontSize.size9,
                            color: color,
                            letterSpacing: LetterSpacing.spacing1,
                            fontName: FUIFontName.bold)
    }
    
    private func attributedString(size: FUIFontSize,
                                  color: UIColor,
                                  letterSpacing: LetterSpacing?,
                                  fontName: FUIFontName) -> NSAttributedString {
        
        let fontSize = CGFloat(size.rawValue)
        var attributes : [NSAttributedStringKey : Any] = [:]
        
        switch fontName {
        case .bold :
            attributes[.font] = UIFont(name:"Menlo-Bold", size: fontSize)
            break
        case .semibold:
            attributes[.font] = UIFont(name:"Menlo-SemiBold", size: fontSize)
            break
        case .regular:
            attributes[.font] = UIFont(name:"Menlo-Regular", size: fontSize)
            break
            
        }
        
        attributes[.foregroundColor] = color
        
        if letterSpacing != nil {
            attributes[.kern] = letterSpacing!.rawValue
        }
        
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
}

//
//  StringExtension.swift
//  AuthExample
//
//  Created by Mikhail Lukyanov on 25.09.17.
//  Copyright © 2017 Mikhail Lukyanov. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func attributedString(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSForegroundColorAttributeName : color])
    }
    
    func attributedString(color: UIColor = UIColor.black, font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : color])
    }
    
    func attributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    /// Истино если в строке нет пробелов И если все буквы английсие
    var isValidEngName: Bool {
        let nameCharacters =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-"
        for char in self.characters {
            if !nameCharacters.characters.contains(char) {
                return false
            }
        }
        return true
    }
    
    var urlCheckResults: [NSTextCheckingResult] {
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector!.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.characters.count))
        
        return matches.filter({ !$0.url!.absoluteString.contains("mailto:") })
    }
    
    /// Все ссылки найденые в строке
    var urls: [URL] {
        return urlCheckResults.map { $0.url! }
    }
    
    var urlsRanges: [NSRange] {
        return urlCheckResults.map { $0.range }
    }
    
    var firstUrl: URL? {
        return urls.first
    }
    
    // Date
    
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    // HTML
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return html
    }
    
    // Окончания
    
    /// Окончание для описания числа
    ///
    /// - Parameters:
    ///   - forNumber: число
    ///   - endings: склонение для 1, 4, 5
    static func word(forNumber number: Int, endings: [String]) -> String {
        var ending = ""
        if number >= 11 && number <= 19 {
            ending = endings[2]
        } else {
            let mod = number % 10
            switch mod {
            case 1:
                ending = endings[0]
                break
            case 2, 3, 4:
                ending = endings[1]
                break
            default:
                ending = endings[2]
            }
        }
        return ending
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    var containsOnlyEmoji: Bool {
        
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}

extension Float {
    var priceString: String {
        let hasMinor = (self - floorf(self)) > 0
        if hasMinor {
            return String(format: "%.2f", self)
        }
        return String(format: "%.0f ₽", self)
    }
}

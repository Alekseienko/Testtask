//
//  AppFont.swift
//  Testtask
//
//  Created by Alekseienko on 30.08.2024.
//

import Foundation
import UIKit

/// An extension of `UIFont` to provide custom fonts used in the app.
extension UIFont {
    
    /// Returns a `UIFont` object for the Nunito Sans font with the specified style and size.
    ///
    /// - Parameters:
    ///   - style: The specific style of the Nunito Sans font (e.g., "Regular", "SemiBold").
    ///   - size: The size of the font.
    /// - Returns: A `UIFont` object configured with the specified style and size.
    /// - Note: If the specified font does not exist, the method will trigger a runtime error.
    static func nunitoSans(_ style: NunitoSansStyle, size: CGFloat) -> UIFont {
        let fullFontName = style.fullFontName
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    
    /// An enumeration that defines the available styles for the Nunito Sans font.
    enum NunitoSansStyle: String {
        case regular = "Regular"
        case semiBold = "SemiBold"
        
        /// A computed property that returns the full font name.
        fileprivate var fullFontName: String {
            return "NunitoSans10pt" + (rawValue.isEmpty ? "" : "-\(rawValue)")
        }
    }
}

// Usage Example:
// let font = UIFont.nunitoSans(.regular, size: 16)


//
//  AppFont.swift
//  Testtask
//
//  Created by Alekseienko on 30.08.2024.
//

import Foundation
import UIKit

/// An enumeration that defines the available font styles within the app.
///
/// The `AppFont` enum provides different font styles that correspond to
/// the different weights of the "NunitoSans10pt" font family.
enum AppFont: String {
    /// The regular font style.
    case regular = "Regular"
    
    /// The semi-bold font style.
    case semiBold = "SemiBold"

    /// Returns a `UIFont` object for the given size.
    ///
    /// - Parameter size: The size of the font.
    /// - Returns: A `UIFont` object configured with the specified size.
    /// - Note: If the specified font does not exist, the method will trigger a runtime error.
    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }

    /// A computed property that returns the full font name.
    ///
    /// This property constructs the full font name by combining the base
    /// family name with the specific font style (e.g., "Regular", "SemiBold").
    /// - Returns: A `String` representing the full font name.
    fileprivate var fullFontName: String {
        return rawValue.isEmpty ? AppConstant.Fonts.nunitoSans : AppConstant.Fonts.nunitoSans + "-" + rawValue
    }
}

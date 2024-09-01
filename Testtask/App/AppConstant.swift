//
//  AppConstant.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import Foundation

/// A structure to hold constant values used throughout the app.
/// These constants help to maintain consistency and avoid hardcoding values in multiple places.
struct AppConstant {
    
    /// A nested structure to hold font-related constants.
    /// This ensures that all font names are managed centrally, making it easier to update or change them if needed.
    struct Fonts {
        /// The font name for the Nunito Sans font with a size of 10 points.
        static let nunitoSans = "NunitoSans10pt"
    }
}

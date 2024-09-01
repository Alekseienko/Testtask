//
//  String+PhoneNumberFormatting.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import Foundation

extension String {
    
    /// Formats a string into a phone number format.
    ///
    /// This method removes any non-numeric characters from the string and then formats it into a phone number.
    /// The expected input is a string with exactly 12 digits (including the country code UA).
    ///
    /// - Returns: A formatted phone number string in the format `+XX (XXX) XXX XX XX`.
    ///            If the string does not contain exactly 12 digits, it returns the original string.
    func formattedPhoneNumber() -> String {
        // Remove any non-numeric characters from the string
        let digits = self.filter { $0.isNumber }
        
        // Check if the phone number has the correct number of digits (12 digits expected)
        guard digits.count == 12 else { return self }
        
        // Format the phone number using the pattern +XX (XXX) XXX XX XX
        let formattedNumber = "+\(digits.prefix(2)) (\(digits.dropFirst(2).prefix(3))) \(digits.dropFirst(5).prefix(3)) \(digits.dropFirst(8).prefix(2)) \(digits.dropFirst(10))"
        
        return formattedNumber
    }
}

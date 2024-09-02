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
        
        // Use indices to format the phone number
        let countryCode = digits.prefix(2)
        let areaCode = digits[digits.index(digits.startIndex, offsetBy: 2)..<digits.index(digits.startIndex, offsetBy: 5)]
        let firstPart = digits[digits.index(digits.startIndex, offsetBy: 5)..<digits.index(digits.startIndex, offsetBy: 8)]
        let secondPart = digits[digits.index(digits.startIndex, offsetBy: 8)..<digits.index(digits.startIndex, offsetBy: 10)]
        let thirdPart = digits.suffix(2)
        
        let formattedNumber = "+\(countryCode) (\(areaCode)) \(firstPart) \(secondPart) \(thirdPart)"
        
        return formattedNumber
    }
}

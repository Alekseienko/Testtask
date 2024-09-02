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
    /// It dynamically adjusts the formatting based on the number of digits entered.
    ///
    /// - Returns: A formatted phone number string in the format `+XX (XXX) XXX XX XX`.
    ///            If the string does not contain enough digits, it returns the partially formatted string.
    func formattedPhoneNumber() -> String {
        // Remove any non-numeric characters from the string
        let digits = self.filter { $0.isNumber }
        
        // Initialize the formatted number
        var formattedNumber = ""
        
        // Handle the country code (first 2 digits)
        if digits.count > 0 {
            let countryCode = digits.prefix(2)
            formattedNumber += "+\(countryCode)"
        }
        
        // Handle the area code (next 3 digits)
        if digits.count > 2 {
            let start = digits.index(digits.startIndex, offsetBy: 2)
            let end = digits.index(start, offsetBy: min(3, digits.count - 2))
            let areaCode = digits[start..<end]
            formattedNumber += " (\(areaCode))"
        }
        
        // Handle the first part (next 3 digits)
        if digits.count > 5 {
            let start = digits.index(digits.startIndex, offsetBy: 5)
            let end = digits.index(start, offsetBy: min(3, digits.count - 5))
            let firstPart = digits[start..<end]
            formattedNumber += " \(firstPart)"
        }
        
        // Handle the second part (next 2 digits)
        if digits.count > 8 {
            let start = digits.index(digits.startIndex, offsetBy: 8)
            let end = digits.index(start, offsetBy: min(2, digits.count - 8))
            let secondPart = digits[start..<end]
            formattedNumber += " \(secondPart)"
        }
        
        // Handle the third part (last 2 digits)
        if digits.count > 10 {
            let start = digits.index(digits.startIndex, offsetBy: 10)
            let thirdPart = digits[start...]
            formattedNumber += " \(thirdPart)"
        }
        
        return formattedNumber
    }
}

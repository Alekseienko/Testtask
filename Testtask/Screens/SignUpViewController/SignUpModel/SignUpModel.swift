//
//  SignUpModel.swift
//  Testtask
//
//  Created by Alekseienko on 30.08.2024.
//

import Foundation

/// Represents different sections or categories in the sign-up model.
enum SignUpModel: Int, CaseIterable {
    /// Text fields section.
    case textFields
    /// Position section.
    case position
    
    enum TextFieldsType: Int, CaseIterable {
        /// Text field for the user's name.
        case name
        
        /// Text field for the user's email address.
        case email
        
        /// Text field for the user's phone number.
        case phone
        
        /// The placeholder text to display in the text field.
        var placeholder: String {
            switch self {
            case .name: "Your name"
            case .email: "Email"
            case .phone: "Phone"
            }
        }
        /// The supporting text or hint to provide additional information or validation message.
        var supporting: String {
            switch self {
            case .name: "Required field"
            case .email: "Invalid email format"
            case .phone: "Required field"
            }
        }
    }
}

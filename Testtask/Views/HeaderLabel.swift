//
//  HeaderLabel.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

/// An enumeration representing the type of HTTP request (GET or POST) associated with the header label.
enum HeaderLabelType {
    case get
    case post
    
    /// A computed property that returns a description based on the header label type.
    ///
    /// - Returns: A `String` describing the type of request.
    var description: String {
        switch self {
        case .get:
            return "Working with GET request"
        case .post:
            return "Working with POST request"
        }
    }
}

/// A custom `UILabel` subclass for displaying a header label with a specific type.
///
/// The `HeaderLabel` class provides a label that automatically adjusts its
/// text and appearance based on the provided `HeaderLabelType`.
final class HeaderLabel: UILabel {
    
    /// The fixed height of the header label.
    static let height: CGFloat = 56
    
    /// Initializes the header label with a specified frame and type.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the label, measured in points. Default is `.zero`.
    ///   - type: The type of request associated with the label, which determines the text content.
    init(frame: CGRect = .zero, type: HeaderLabelType) {
        super.init(frame: frame)
        
        // Set the label's height and adjust its size based on the type.
        self.frame.size = CGSize(width: frame.size.width, height: HeaderLabel.height)
        self.text = type.description
        
        // Set label appearance.
        self.textAlignment = .center
        self.backgroundColor = .primaryTheme
        self.font = AppFont.regular.size(20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

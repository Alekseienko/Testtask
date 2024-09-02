//
//  MainButton.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

/// A custom `UIButton` subclass designed for a primary action button in the application.
final class MainButton: UIButton {
    
    /// Initializes the button with an optional title.
    ///
    /// - Parameter title: The title to be displayed on the button. Defaults to `nil`.
    init(title: String? = nil) {
        super.init(frame: .zero)
        configureButton(title: title)
    }
    
    /// Required initializer that is unavailable for use.
    ///
    /// This initializer triggers a runtime error if called, as it is not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the button's appearance and behavior.
    ///
    /// This method sets up the button's visual style, including its background color,
    /// corner style, content insets, and title text attributes. It also handles
    /// the button's state changes and appearance updates.
    ///
    /// - Parameter title: The title to be displayed on the button.
    private func configureButton(title: String?) {
        var config = UIButton.Configuration.filled()  // Create a filled button configuration
        config.cornerStyle = .capsule  // Set rounded corners (capsule style)
        config.baseBackgroundColor = .primaryTheme  // Set the base background color
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30)  // Set content insets
        
        // Set the font for the button's title text
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.nunitoSans(.semiBold, size: 18)
            return outgoing
        }
        
        // Apply the configuration to the button
        self.configuration = config
        self.setTitleColor(.black87, for: .normal)  // Set the title color for normal state
        self.setTitleColor(.black48, for: .disabled)  // Set the title color for disabled state
        self.translatesAutoresizingMaskIntoConstraints = false  // Disable autoresizing mask translation
        
        // Set the title if provided
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        
        // Add target to handle appearance changes based on button state
        self.addTarget(self, action: #selector(updateButtonAppearance), for: [.touchUpInside, .touchDown])
    }
    
    /// Updates the button's background color based on its state.
    ///
    /// This method changes the background color depending on whether the button is enabled or disabled.
    @objc private func updateButtonAppearance() {
        if !self.isEnabled {
            self.configuration?.baseBackgroundColor = .black60  // Set background color for disabled state
        } else {
            self.configuration?.baseBackgroundColor = .primaryTheme  // Set background color for enabled state
        }
    }
    
    /// Overrides the `isEnabled` property to update the button's appearance when its state changes.
    override var isEnabled: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
}

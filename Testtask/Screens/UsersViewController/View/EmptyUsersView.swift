//
//  EmptyUsersView.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import UIKit

// A custom UIView subclass to display a message and image when there are no users
final class EmptyUsersView: UIView {
    
    // MARK: - Properties
    
    // Label that displays the message when there are no users
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "There are no users yet" // Placeholder text
        view.font = UIFont.nunitoSans(.regular, size: 20) // Font size for the message
        view.textColor = .black87 // Text color
        view.textAlignment = .center // Center the text
        view.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        return view
    }()
    
    // Image view to show an image indicating no users
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit // Scale image to fit within bounds
        view.image = .emptyUsersList // Placeholder image
        view.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        return view
    }()
    
    // Stack view to arrange the image view and label vertically
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical // Arrange arranged views vertically
        view.spacing = 24 // Space between arranged views
        view.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // Setup the view layout
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Not supported for storyboard/XIB
    }
}

// MARK: - Setup View

private extension EmptyUsersView {
    // Function to configure and layout the subviews
    func setupView() {
        backgroundColor = .clear // Set background color to clear

        addSubview(stackView) // Add stack view to the main view
        stackView.addArrangedSubview(imageView) // Add image view to the stack view
        stackView.addArrangedSubview(titleLabel) // Add label to the stack view
        
        // Activate constraints to center the stack view in the main view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

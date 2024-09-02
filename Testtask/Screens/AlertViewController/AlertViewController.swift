//
//  AlertViewController.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import UIKit

/// A view controller that presents an alert with an image, a title, and action buttons.
final class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    /// An image view to display an icon or image related to the alert.
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label to display the title or description of the alert.
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.nunitoSans(.regular, size: 20)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A main button for the primary action of the alert.
    private let mainButton: MainButton = MainButton()
    
    /// A close button to dismiss the alert.
    private let closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A stack view to arrange the image view, title label, and main button vertically.
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A closure to handle the main button's action.
    var actionMainButton: (() -> Void)?
    
    // MARK: - Initializers
    
    /// Initializes the view controller with default settings for presentation and transition style.
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    /// Required initializer for loading from a storyboard or XIB, not implemented here.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    /// Called after the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup View
    
    /// Sets up the view hierarchy and constraints.
    private func setupView() {
        view.backgroundColor = .white
        
        // Add subviews to the main view
        view.addSubview(stackView)
        view.addSubview(closeButton)

        // Add arranged subviews to the stack view
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        // Container view for the main button
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.addSubview(mainButton)
        
        stackView.addArrangedSubview(buttonContainerView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Main button constraints
            mainButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            buttonContainerView.heightAnchor.constraint(equalTo: mainButton.heightAnchor),
            
            // Stack view constraints
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Close button constraints
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        // Main button action
        mainButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
            actionMainButton?()
        }, for: .primaryActionTriggered)
        
        // Close button action
        closeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }, for: .primaryActionTriggered)
    }
    
    // MARK: - Configuration
    
    /// Configures the view controller with the specified alert style.
    /// - Parameter state: The style of the alert to configure.
    func configure(with state: AlertViewControllerStyle) {
        titleLabel.text = state.description
        mainButton.setTitle(state.buttonTitle, for: .normal)
        closeButton.isHidden = !state.isDismissible
        imageView.image = state.image
    }
}

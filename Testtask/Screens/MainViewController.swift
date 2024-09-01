//
//  MainViewController.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

final class MainViewController: UITabBarController {
    
    // MARK: - Property
    
    private let stackBarView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .bottomBar
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usersButton: UIButton = createButton(title: "Users", image: .tabUsers)
    private lazy var signUpButton: UIButton = createButton(title: "Sign up", image: .tabSignUp)
    
    private var buttons: [UIButton] {
        return [usersButton, signUpButton]
    }
    
    override var selectedIndex: Int {
        didSet {
            self.updateButtonSelectionState()
        }
    }
}

// MARK: - Life Cycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTabBar()
    }
}

// MARK: - Setup Controller

extension MainViewController {
    /// Sets up the view controllers and alert configuration.
    private func setupController() {
        let networkManager = NetworkManager()

        let usersViewModel = UsersViewModel(networkService: networkManager)
        let usersViewController = UsersViewController(viewModel: usersViewModel)
        
        let signUpViewModel = SignUpViewModel(networkService: networkManager)
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        
        // Configure the sign up view controller to notify the users view controller of new user additions
        signUpViewController.newUserAdded = { id in
            usersViewController.loadNewUserBy(id: id)
        }
        
        // Set up view controllers for the tab bar
        viewControllers = [usersViewController, signUpViewController]
    }
    
    /// Configures the appearance of the tab bar and adds buttons to the stack view.
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .bottomBar
        appearance.shadowColor = .bottomBar
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
        
        selectedIndex = 0
        
        view.addSubview(stackBarView)
        stackBarView.addArrangedSubview(usersButton)
        stackBarView.addArrangedSubview(signUpButton)
        
        // Layout constraints for the stack view
        stackBarView.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        stackBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        updateButtonSelectionState()
    }
    
    /// Creates a button with the given title and image.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - image: The image for the button.
    /// - Returns: A configured `UIButton`.
    private func createButton(title: String, image: UIImage) -> UIButton {
        var configuration = UIButton.Configuration.borderless()
        configuration.image = image.withRenderingMode(.alwaysTemplate)
        configuration.title = title
        configuration.imagePadding = 8
        
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = AppFont.semiBold.size(16)
            return outgoing
        }
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .gray
        button.imageView?.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.handleButtonTap(button: button)
        }, for: .primaryActionTriggered)
        return button
    }
    
    /// Handles the button tap events.
    /// - Parameter button: The button that was tapped.
    private func handleButtonTap(button: UIButton) {
        if button == usersButton {
            selectedIndex = 0
        } else if button == signUpButton {
            selectedIndex = 1
        }
        updateButtonSelectionState()
    }
    
    /// Updates the button selection state based on the currently selected tab.
    private func updateButtonSelectionState() {
        buttons.forEach { button in
            button.tintColor = (button == buttons[selectedIndex]) ? .secondaryTheme : .black60
            button.imageView?.tintColor = (button == buttons[selectedIndex]) ? .secondaryTheme : .black60
        }
    }
}

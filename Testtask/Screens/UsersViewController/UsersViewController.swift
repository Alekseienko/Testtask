//
//  UsersViewController.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

/// A view controller that displays a list of users in a table view.
///
/// This view controller manages user data by interacting with a `UsersViewModel`.
/// It handles loading users, displaying them in a table view, and managing UI elements such as activity indicators and error handling.
final class UsersViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The main table view used to display user data.
    private let mainView = BaseTableView()
    
    /// The activity indicator view shown during data loading.
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.frame.size = CGSize(width: view.frame.size.width, height: 80)
        view.hidesWhenStopped = true
        return view
    }()
    
    /// The view model responsible for managing user data and business logic.
    private var viewModel: UsersViewModel
    
    // MARK: - Initializers
    
    /// Initializes the view controller with a specified view model.
    ///
    /// - Parameter viewModel: The `UsersViewModel` instance used to manage user data.
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupBindings()
    }
    
    /// Initializes the view controller using a coder.
    ///
    /// - Note: This initializer is not implemented and will trigger a fatal error if called.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Public method to load a new user by ID.
    ///
    /// - Parameter id: The ID of the user to load.
    public func loadNewUserBy(id: Int?) {
        viewModel.loadNewUserBy(id: id)
    }
    
    // MARK: - Lifecycle
    
    /// Sets up the view hierarchy for the view controller.
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    /// Performs additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dataSource = self
        mainView.delegate = self
        mainView.registerCell(with: UserTableViewCell.self, identifier: UserTableViewCell.id)
        mainView.setupFooterView(activityIndicatorView)
        mainView.setupHeaderView(HeaderLabel(type: .get))
        mainView.setupBackgroundView(EmptyUsersView())
        mainView.setupSeparatorInset(UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 16))
        loadUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await addNewUser()
        }
    }
    
    // MARK: - Private Methods
    
    private func stopActivityIndicator() {
        Task { @MainActor in
            activityIndicatorView.stopAnimating()
        }
    }
    
    /// Sets up bindings between the view model and the view controller.
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }
            mainView.reloadTableView()
            stopActivityIndicator()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            stopActivityIndicator()
        }
        
        viewModel.onNewUserAdded = { [weak self] in
            guard let self else { return }
            mainView.scrollToTop()
        }
    }
    private func addNewUser() async {
        let isUserAdded = await viewModel.appendNewUser()
        
        if isUserAdded {
            mainView.setupInsertRows([IndexPath(item: 0, section: 0)])
        }
    }
    
    /// Loads users from the view model and handles errors.
    private func loadUsers() {
        Task { @MainActor in
            do {
                try await viewModel.loadUsers()
                // Handle successful loading, e.g., update the UI
            } catch {
                if let networkError = error as? NetworkError {
                    if networkError == .noInternetConnection {
                        let alertVC = AlertViewController()
                        alertVC.configure(with: .internetConnection)
                        alertVC.actionMainButton = {
                            self.loadUsers()
                        }
                        self.present(alertVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (viewModel.numberOfItems != 0)
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let item = viewModel.item(at: indexPath.row)
        cell.config(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems - 1 && viewModel.hasMoreData {
            activityIndicatorView.startAnimating()
            loadUsers()
        }
    }
}

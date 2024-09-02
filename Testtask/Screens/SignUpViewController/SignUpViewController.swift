//
//  SignUpViewController.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let footerView = SignUpFooterView()
    private let mainView = BaseTableView()
    private var viewModel: SignUpViewModel
    private var lastIndex: IndexPath = IndexPath(item: 0, section: SignUpModel.position.rawValue)
    
    // Closure to notify when a new user is added
    var newUserAdded: ((Int?) -> Void)?
    
    // Initializer to set up the view model
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViewModelObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the main view as the root view
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dataSource = self
        mainView.delegate = self
        mainView.registerCell(with: TextFieldTableViewCell.self, identifier: TextFieldTableViewCell.id)
        mainView.registerCell(with: PositionTableViewCell.self, identifier: PositionTableViewCell.id)
        mainView.setupSeparatorStyle(.none)
        mainView.setupHeaderView(HeaderLabel(type: .post))
        mainView.setupFooterView(footerView)
        footerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupController()
    }
    
    // Set up observers for view model changes
    private func setupViewModelObservers() {
        viewModel.notifyUpdateTextFields = { [weak self] fieldType in
            guard let self = self else { return }
            updateSignUpButtonState()
            let indexPath: IndexPath
            switch fieldType {
            case .name:
                indexPath = IndexPath(row: SignUpModel.TextFieldsType.name.rawValue, section: SignUpModel.textFields.rawValue)
            case .email:
                indexPath = IndexPath(row: SignUpModel.TextFieldsType.email.rawValue, section: SignUpModel.textFields.rawValue)
            case .phone:
                indexPath = IndexPath(row: SignUpModel.TextFieldsType.phone.rawValue, section: SignUpModel.textFields.rawValue)
            }
            // Reload the changed text field
            mainView.setupReloadRows([indexPath])
            // Select the last selected row
            mainView.setupSelectRow(lastIndex)
        }
        
        viewModel.notifyUpdateImageUpload = { [weak self] in
            guard let self = self else { return }
            footerView.config(isValid: viewModel.isValidImage)
        }
    }
    
    // MARK: - Private Methods
    
    // Set up the controller state based on the view model
    private func setupController() {
        mainView.setupSelectRow(lastIndex)
        viewModel.selectedPosition = viewModel.item(at: lastIndex.row)
        footerView.config(isValid: true)
        footerView.configUploadButton(isImageNil: (viewModel.image == nil))
        updateSignUpButtonState()
    }
    
    // Update the state of the sign-up button based on the view model
    private func updateSignUpButtonState() {
        footerView.mainButtonState(isEnabled: viewModel.isSignUpButtonEnabled)
    }
    
    // Present the image picker for choosing a photo
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Register a new user with the view model data
    private func registerUser() {
        footerView.mainButtonState(isEnabled: false)
        Task { @MainActor in
            do {
                let response = try await viewModel.signUp()
                footerView.mainButtonState(isEnabled: true)
                if response.success {
                    self.newUserAdded?(response.user_id)
                    let alertVC = AlertViewController()
                    alertVC.configure(with: .successfullyRegistered)
                    alertVC.actionMainButton = {
                        self.tabBarController?.selectedIndex = 0
                        alertVC.dismiss(animated: true)
                    }
                    self.present(alertVC, animated: true)
                } else {
                    let alertVC = AlertViewController()
                    alertVC.configure(with: .alreadyRegistered)
                    alertVC.actionMainButton = {
                        self.viewModel.isValidEmail = false
                        self.viewModel.isValidPhone = false
                        alertVC.dismiss(animated: true)
                    }
                    self.present(alertVC, animated: true)
                }
            } catch {
                if let networkError = error as? NetworkError {
                    if networkError == .noInternetConnection {
                        let alertVC = AlertViewController()
                        alertVC.configure(with: .internetConnection)
                        alertVC.actionMainButton = {
                            self.registerUser()
                        }
                        self.present(alertVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SignUpViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SignUpModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = SignUpModel(rawValue: section) {
            switch section {
            case .textFields: return SignUpModel.TextFieldsType.allCases.count
            case .position: return viewModel.numberOfPositions
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SignUpModel(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .textFields:
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.id, for: indexPath) as? TextFieldTableViewCell else { return UITableViewCell() }
            textFieldCell.delegate = self
            guard let row = SignUpModel.TextFieldsType(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .name:
                textFieldCell.config(with: row, text: viewModel.name, isValid: viewModel.isValidName)
            case .email:
                textFieldCell.config(with: row, text: viewModel.email, isValid: viewModel.isValidEmail)
            case .phone:
                textFieldCell.config(with: row, text: viewModel.phone, isValid: viewModel.isValidPhone)
            }
            return textFieldCell
        case .position:
            guard let positionCell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.id, for: indexPath) as? PositionTableViewCell else { return UITableViewCell() }
            let item = viewModel.item(at: indexPath.row)
            positionCell.config(with: item)
            return positionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SignUpModel(rawValue: indexPath.section) else { return }
        switch section {
        case .textFields:
            // Re-select the previously selected row
            self.mainView.setupSelectRow(self.lastIndex)
        case .position:
            lastIndex = indexPath
            let item = viewModel.item(at: indexPath.row)
            viewModel.selectedPosition = item
            view.endEditing(true)
        }
    }
}

// MARK: - UITableViewDelegate

extension SignUpViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SignUpModel.position.rawValue {
            let label = UILabel()
            label.text = "Select your position"
            label.font = UIFont.nunitoSans(.regular, size: 18)
            let stack = UIStackView(arrangedSubviews: [label])
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            stack.backgroundColor = .white
            return stack
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == SignUpModel.position.rawValue ? 40 : 0
    }
}

// MARK: - TextFieldTableViewCellDelegate

extension SignUpViewController: TextFieldTableViewCellDelegate {
    
    func didSendText(type: SignUpModel.TextFieldsType?, value: String) {
        switch type {
        case .name:
            viewModel.name = value
        case .email:
            viewModel.email = value
        case .phone:
            viewModel.phone = value
        case nil: break
        }
    }
}

// MARK: - SignUpFooterViewDelegate

extension SignUpViewController: SignUpFooterViewDelegate {
    
    func didSelectUpload() {
        let alertController = UIAlertController(title: "Choose how you want to add a photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectSignUp() {
        registerUser()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            print("Edited image selected")
            viewModel.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            print("Original image selected")
            viewModel.image = originalImage
        }
        self.footerView.configUploadButton(isImageNil: (self.viewModel.image == nil))
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.footerView.configUploadButton(isImageNil: (self.viewModel.image == nil))
            self.mainView.setupSelectRow(self.lastIndex)
        }
        print("Image picker canceled")
    }
}

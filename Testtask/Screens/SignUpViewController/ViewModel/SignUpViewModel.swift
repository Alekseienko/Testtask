//
//  SignUpViewModel.swift
//  Testtask
//
//  Created by Alekseienko on 30.08.2024.
//

import UIKit
/// ViewModel for handling the logic of the Sign-Up process.

final class SignUpViewModel {
    // MARK: - Properties
    
    /// Service responsible for network requests.
    private let networkService: NetworkService
    /// Boolean indicating if the name is valid.
    var isValidName: Bool = true {
        didSet {
            notifyUpdateTextFields?(.name)
        }
    }
    /// Boolean indicating if the email is valid.
    var isValidEmail: Bool = true {
        didSet {
            notifyUpdateTextFields?(.email)
        }
    }
    /// Boolean indicating if the phone number is valid.
    var isValidPhone: Bool = true {
        didSet {
            notifyUpdateTextFields?(.phone)
        }
    }
    /// Boolean indicating if the image is valid (i.e., not nil).
    var isValidImage: Bool = false {
        didSet {
            notifyUpdateImageUpload?()
        }
    }
    /// The name input by the user.
    var name: String = "" {
        didSet {
            validateName(name.count)
        }
    }
    /// The email input by the user.
    var email: String = "" {
        didSet {
            validateEmail(from: email)
        }
    }
    /// The phone number input by the user.
    var phone: String = "" {
        didSet {
            validatePhone(phoneNumber: phone)
        }
    }
    /// The position selected by the user.
    var selectedPosition: Position?
    /// Array of available positions fetched from the server.
    private var positions: [Position] = []
    /// The number of available positions.
    var numberOfPositions: Int = 0
    /// Return Position by index: Int
    func item(at index: Int) -> Position {
        return positions[index]
    }
    /// The image selected by the user.
    var image: UIImage? {
        didSet {
            validateImage(image)
        }
    }
    /// Closure to notify when text fields need to be updated.
    var notifyUpdateTextFields: ((SignUpModel.TextFieldsType) -> Void)?
    var notifyUpdateImageUpload: (() -> Void)?
    
    /// Boolean indicating if the Sign-Up button should be enabled.
    var isSignUpButtonEnabled: Bool {
        return !name.isEmpty || !phone.isEmpty || !email.isEmpty
    }
    // MARK: - Initializers
    
    /// Initializes the view model with a network service.
    ///
    /// - Parameter networkService: The service used for network requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
        Task { @MainActor in
            await self.loadPositions()
        }
    }
    // MARK: - Methods
    
    /// Loads available positions from the network service.
    ///
    /// This method asynchronously fetches positions and updates the view model's positions array.
    func loadPositions() async {
        do {
            let positionsResponse = try await networkService.fetchPositions()
            self.positions = positionsResponse.positions
            self.numberOfPositions = self.positions.count
        } catch {
            print("❌", error.localizedDescription)
        }
    }
    /// Signs up the user with the provided details.
    ///
    /// - Throws: `SignUpError` if any validation fails or if network request fails.
    /// - Returns: The response from the user registration request.
    func signUp() async throws -> UserRegistrationResponse {
        guard isValidName && isValidPhone && isValidEmail && isValidImage else {
            print("Sign Up failed: One or more fields are invalid or empty.")
            validateName(name.count)
            validateEmail(from: email)
            validatePhone(phoneNumber: phone)
            validateImage(image)
            throw SignUpError.invalidFields
        }
        
        guard let image = image else {
            throw SignUpError.missingImage
        }
        
        guard let imageData = compressImageData(image: image) else {
            throw SignUpError.imageCompressionFailed
        }
        
        guard let selectedPositionId = selectedPosition?.id else {
            throw SignUpError.missingPosition
        }
        
        let userRequest = UserRegistrationRequest(name: name,
                                                  email: email,
                                                  phone: phone,
                                                  position_id: selectedPositionId,
                                                  photo: imageData)
        do {
            let response = try await networkService.registerUser(request: userRequest)
            print("Registration successful:", response)
            return response
        } catch {
            print("Registration failed:", error.localizedDescription)
            throw error
        }
    }
    /// Validates the length of the name.
    ///
    /// - Parameter count: The length of the name.
    private func validateName(_ count: Int) {
        switch count {
        case 2...60: isValidName = true
        default: isValidName = false
        }
    }
    /// Validates the email using a regular expression.
    ///
    /// - Parameter email: The email address to validate.
    private func validateEmail(from email: String) {
        let emailRegex = #"""
        (?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)])
        """#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isValidEmail = emailPredicate.evaluate(with: email)
    }
    /// Validates the phone number using a regular expression.
    ///
    /// - Parameter phoneNumber: The phone number to validate.
    private func validatePhone(phoneNumber: String) {
        let pattern = "^\\+380\\d{9}$"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return isValidPhone = false
        }
        let range = NSRange(location: 0, length: phoneNumber.utf16.count)
        return isValidPhone = regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }
    /// Validates if the image is not nil.
    ///
    /// - Parameter image: The image to validate.
    private func validateImage(_ image: UIImage?) {
        isValidImage = image != nil
    }
    /// Compresses image data to meet a maximum file size requirement.
    ///
    /// - Parameters:
    ///   - image: The image to compress.
    ///   - maxFileSizeMB: The maximum file size in megabytes.
    /// - Returns: The compressed image data, or nil if compression failed.
    private func compressImageData(image: UIImage, maxFileSizeMB: CGFloat = 5.0) -> Data? {
        let maxFileSizeBytes = maxFileSizeMB * 1024 * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        while let data = imageData, CGFloat(data.count) > maxFileSizeBytes, compression > 0 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        return imageData
    }
}

//
//  SignUpFooterView.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

/// Delegate protocol for handling actions from `SignUpFooterView`.
///
/// This protocol is used to notify the conforming class when the user performs
/// actions in the `SignUpFooterView`. The conforming class should implement
/// these methods to respond to user interactions, such as uploading a photo
/// or submitting the sign-up form.

protocol SignUpFooterViewDelegate: AnyObject {
    
    /// Called when the user taps the upload button.
    ///
    /// Implement this method to handle the upload action, such as presenting
    /// a photo picker or handling file uploads.
    func didSelectUpload()
    
    /// Called when the user taps the sign-up button.
    ///
    /// Implement this method to handle the sign-up action, such as validating
    /// form inputs and submitting the sign-up data to a server.
    func didSelectSignUp()
}

final class SignUpFooterView: UIView {
    
    // MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    weak var delegate: SignUpFooterViewDelegate?
    
     let bodyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainButton: MainButton = MainButton(title: "Sign up")
    
    private let uploadStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 24)
        view.distribution = .fill
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let uploadLabel: UILabel = {
        let view = UILabel()
        view.text = "Upload your photo"
        view.textAlignment = .left
        view.font = AppFont.regular.size(16)
        view.textColor = .black48
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let uploadButton: UIButton = {
        let view = UIButton()
        view.setTitle("Upload", for: .normal)
        view.setTitleColor(.secondaryDark, for: .normal)
        view.titleLabel?.font = AppFont.semiBold.size(16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoLabel: UILabel = {
        let view = UILabel()
        view.text = "Photo is required"
        view.textAlignment = .left
        view.textColor = .error
        view.font = AppFont.regular.size(12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public func config(isValid: Bool) {
        infoLabel.alpha = isValid ? 0 : 1
        uploadStackView.layer.borderColor = isValid ? UIColor.black12.cgColor : UIColor.error.cgColor
        uploadLabel.textColor = isValid ? .black48 : .error
    }
    
    public func mainButtonState(isEnabled: Bool) {
        mainButton.isEnabled = isEnabled
    }
    
    public func configUploadButton(isImageNil: Bool) {
        uploadButton.setTitle(isImageNil ? "Upload" : "Change", for: .normal)
    }
}

// MARK: - Setup View

private extension SignUpFooterView {
    func setupView() {
        frame.size.height = 200
        addSubview(bodyStackView)
        
        uploadStackView.addArrangedSubview(uploadLabel)
        let flexView = UIView()
        flexView.translatesAutoresizingMaskIntoConstraints = false
        uploadStackView.addArrangedSubview(flexView)

        uploadStackView.addArrangedSubview(uploadButton)
        bodyStackView.addArrangedSubview(uploadStackView)
        bodyStackView.setCustomSpacing(4, after: uploadStackView)
        
        let infoLabelStack = UIStackView(arrangedSubviews: [infoLabel])
        infoLabelStack.isLayoutMarginsRelativeArrangement = true
        infoLabelStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bodyStackView.addArrangedSubview(infoLabelStack)
        bodyStackView.setCustomSpacing(16, after: infoLabelStack)
        
        let left = UIView()
        left.translatesAutoresizingMaskIntoConstraints = false
        let right = UIView()
        right.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [left, mainButton, right])
        bodyStackView.addArrangedSubview(buttonStack)
        
        let bodyStackViewWidthAnchor = bodyStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        bodyStackViewWidthAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            left.widthAnchor.constraint(equalTo: right.widthAnchor),
            bodyStackView.topAnchor.constraint(equalTo: topAnchor),
            bodyStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyStackViewWidthAnchor
        ])

        mainButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.didSelectSignUp()
        }, for: .primaryActionTriggered)
    
        uploadButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.didSelectUpload()
        }, for: .primaryActionTriggered)
    }
}

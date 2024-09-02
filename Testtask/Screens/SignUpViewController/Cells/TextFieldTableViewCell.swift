//
//  TextFieldTableViewCell.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    /// Notifies the delegate that text has been entered or changed in the cell.
    /// - Parameters:
    ///   - type: The type of text field that sent the text. This helps the delegate understand the context of the text input.
    ///   - value: The text value that was entered or changed in the text field.
    func didSendText(type: SignUpModel.TextFieldsType?, value: String)
}


import UIKit

/// A custom table view cell that includes a text field and handles user input with validation.
final class TextFieldTableViewCell: UITableViewCell {
    
    // MARK: - Initializers
    
    /// Initializes the cell with the specified style and reuse identifier.
    /// - Parameters:
    ///   - style: The style of the cell.
    ///   - reuseIdentifier: A string identifying the cell type.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    /// Required initializer for loading from a storyboard or XIB, not implemented here.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// The reuse identifier for the cell.
    static let id = String(describing: TextFieldTableViewCell.self)
    
    /// Delegate to handle text input events.
    weak var delegate: TextFieldTableViewCellDelegate?
    
    /// The type of text field for configuration purposes.
    private var type: SignUpModel.TextFieldsType?
    
    /// A vertical stack view to layout the text field and related views.
    let bodyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A vertical stack view containing the text field and placeholder label.
    private let textFieldStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 3
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 24)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that serves as a placeholder for the text field.
    private let placeholderLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 16)
        view.textColor = .black48
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A supporting label for additional information or validation feedback.
    private let supportingLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = .black60
        view.font = UIFont.nunitoSans(.regular, size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The text field for user input.
    private let textField: UITextField = {
        let view = UITextField()
        view.font = UIFont.nunitoSans(.regular, size: 16)
        view.textColor = .black87
        view.layer.masksToBounds = false
        view.returnKeyType = .done
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configuration
    
    /// Configures the cell with the given text field type, text, and validity status.
    /// - Parameters:
    ///   - type: The type of text field (e.g., name, email, phone).
    ///   - text: The text to display in the text field.
    ///   - isValid: A Boolean indicating whether the input is valid.
    public func config(with type: SignUpModel.TextFieldsType, text: String, isValid: Bool) {
        // Configure text field properties based on the type
        textField.text = text
        switch type {
        case .name:
            textField.keyboardType = .default
        case .email:
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case .phone:
            textField.keyboardType = .phonePad
            textField.text = isValid ? text.formattedPhoneNumber() : text
        }
        
        // Set the text and visibility of the text field and placeholder
        if text.isEmpty {
            textField.isHidden = true
            placeholderLabel.font = UIFont.nunitoSans(.regular, size: 16)
        } else {
            textField.isHidden = false
            placeholderLabel.font = UIFont.nunitoSans(.regular, size: 12)
        }
        
        // Configure labels and border color based on validity
        self.type = type
        placeholderLabel.text = type.placeholder
        supportingLabel.text = isValid ? (type == .phone ? "+38 (XXX) XXX - XX - XX" : " ") : type.supporting
        textFieldStackView.layer.borderColor = isValid ? UIColor.black12.cgColor : UIColor.error.cgColor
        placeholderLabel.textColor = isValid ? .black48 : .error
        supportingLabel.textColor = isValid ? .black48 : .error
    }
    
    // MARK: - Private Methods
    
    /// Sets up the cell by adding subviews and setting constraints.
    private func setupCell() {
        selectionStyle = .none
        contentView.addSubview(bodyStackView)
        
        textFieldStackView.addArrangedSubview(placeholderLabel)
        textFieldStackView.addArrangedSubview(textField)
        bodyStackView.addArrangedSubview(textFieldStackView)
        bodyStackView.setCustomSpacing(4, after: textFieldStackView)
        
        let infoLabelStack = UIStackView(arrangedSubviews: [supportingLabel])
        infoLabelStack.isLayoutMarginsRelativeArrangement = true
        infoLabelStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bodyStackView.addArrangedSubview(infoLabelStack)
        bodyStackView.setCustomSpacing(16, after: infoLabelStack)
        
        textField.isHidden = true
        textField.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        ]
        textField.inputAccessoryView = toolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(placeholderLabelTapped))
        placeholderLabel.addGestureRecognizer(tapGesture)
        
        // Set up constraints
        let textFieldViewHeightAnchor = textField.heightAnchor.constraint(equalToConstant: 24)
        textFieldViewHeightAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            textFieldStackView.heightAnchor.constraint(equalToConstant: 56),
            textFieldViewHeightAnchor,
            bodyStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    // MARK: - Actions
    
    /// Called when the Done button on the input accessory view is tapped.
    @objc private func doneButtonTapped() {
        textField.resignFirstResponder()
    }
    
    /// Called when the placeholder label is tapped to show the text field.
    @objc private func placeholderLabelTapped() {
        if textField.text != nil {
            UIView.animate(withDuration: 0.3) {
                self.textField.isHidden = false
                self.placeholderLabel.font = UIFont.nunitoSans(.regular, size: 12)
            }
            textField.becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate

/// Extension to handle UITextFieldDelegate methods for the text field.
extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if type == .phone && textField.text == "" {
            textField.text = "+"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            UIView.animate(withDuration: 0.3) {
                self.textField.isHidden = true
                self.placeholderLabel.font = UIFont.nunitoSans(.regular, size: 16)
            }
        }
        if let text = textField.text {
            if type == .phone {
                delegate?.didSendText(type: self.type, value: text == "" ? text : "+" + text.filter { $0.isNumber })
            } else {
                delegate?.didSendText(type: self.type, value: text)
            }
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if type == .phone {
            let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
            return allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return true
    }
}

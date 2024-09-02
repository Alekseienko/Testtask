//
//  UserTableViewCell.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

final class UserTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    // Initializes the cell with a specific style and reuse identifier
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    // Required initializer for loading from storyboard or XIB, but not used here
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    // Static identifier for cell reuse
    static let id = String(describing: UserTableViewCell.self)
    
    // UIImageView for displaying user photo
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.image = .photoCover
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UILabel for displaying user's name
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 18)
        view.textColor = .black87
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UILabel for displaying user's position
    private let positionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 14)
        view.textColor = .black60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UILabel for displaying user's email
    private let emailLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 14)
        view.textColor = .black87
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UILabel for displaying user's phone number
    private let phoneLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 14)
        view.textColor = .black87
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Stack view to layout the photo and labels horizontally
    private let bodyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .top
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Stack view to layout the labels vertically
    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Configures the cell with user data
    public func config(with user: UserModel) {
        photoImageView.image = user.photo
        nameLabel.text = user.name
        positionLabel.text = user.position
        emailLabel.text = user.email
        phoneLabel.text = user.phone
    }
    
    // Sets up the cell layout and constraints
    private func setupCell() {
        selectionStyle = .none // Disable selection style
        
        // Add bodyStackView to contentView
        contentView.addSubview(bodyStackView)
        
        // Container view for the photo image view
        let contentPhotoImageView = UIView()
        contentPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentPhotoImageView.addSubview(photoImageView)
        bodyStackView.addArrangedSubview(contentPhotoImageView)
        bodyStackView.addArrangedSubview(labelsStackView)
        
        // Add labels to the labels stack view
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.setCustomSpacing(4, after: nameLabel)
        labelsStackView.addArrangedSubview(positionLabel)
        labelsStackView.setCustomSpacing(8, after: positionLabel)
        labelsStackView.addArrangedSubview(emailLabel)
        labelsStackView.setCustomSpacing(4, after: emailLabel)
        labelsStackView.addArrangedSubview(phoneLabel)
        
        // Define constraints for photoImageView
        let photoImageViewHeightAnchor = photoImageView.heightAnchor.constraint(equalToConstant: 50)
        photoImageViewHeightAnchor.priority = .defaultHigh
        let photoImageViewWidthAnchorAnchor = photoImageView.widthAnchor.constraint(equalToConstant: 50)
        photoImageViewWidthAnchorAnchor.priority = .defaultHigh
        
        // Activate layout constraints
        NSLayoutConstraint.activate([
            contentPhotoImageView.widthAnchor.constraint(equalToConstant: 50),
            photoImageViewHeightAnchor,
            photoImageViewWidthAnchorAnchor,
            bodyStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

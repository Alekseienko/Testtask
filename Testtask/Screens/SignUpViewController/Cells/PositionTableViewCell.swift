//
//  PositionTableViewCell.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import UIKit

/// A custom table view cell for displaying a position with an icon and a name.
final class PositionTableViewCell: UITableViewCell {
    
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
    static let id = String(describing: PositionTableViewCell.self)
    
    /// An image view to display the icon for the position.
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label to display the name of the position.
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.nunitoSans(.regular, size: 16)
        view.textColor = .black87
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A stack view to arrange the icon and name label horizontally.
    private let bodyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 25
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 12, left: 33, bottom: 12, right: 33)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configuration
    
    /// Configures the cell with the given position data.
    /// - Parameter position: The position data to display in the cell.
    public func config(with position: Position) {
        nameLabel.text = position.name
    }
    
    // MARK: - UITableViewCell
    
    /// Updates the appearance of the cell based on its selection state.
    /// - Parameters:
    ///   - selected: A Boolean indicating whether the cell is selected.
    ///   - animated: A Boolean indicating whether the change should be animated.
    override func setSelected(_ selected: Bool, animated: Bool) {
        iconImageView.image = selected ? .selectedItem : .unselectedItem
    }
    
    // MARK: - Private Methods
    
    /// Sets up the cell by adding subviews and setting constraints.
    private func setupCell() {
        selectionStyle = .none
        contentView.addSubview(bodyStackView)
        bodyStackView.addArrangedSubview(iconImageView)
        bodyStackView.addArrangedSubview(nameLabel)
        
        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            bodyStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

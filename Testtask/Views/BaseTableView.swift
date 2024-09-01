//
//  BaseTableView.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//
import UIKit

/// A custom view that contains and manages a `UITableView`.
///
/// The `BaseTableView` class provides a customizable table view
/// with convenience methods for setup and configuration.
final class BaseTableView: UIView {
    // MARK: - Properties

    /// The `UITableView` instance managed by this view.
    private let tableView: UITableView

    /// The data source for the table view.
    ///
    /// This property is used to provide the data for the table view's cells.
    public var dataSource: UITableViewDataSource? {
        get { tableView.dataSource }
        set { tableView.dataSource = newValue }
    }

    /// Initializes the `BaseTableView` with a specified frame and style.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - style: The style of the table view (e.g., `.plain`, `.grouped`).
    init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        tableView = UITableView(frame: frame, style: style)
        super.init(frame: frame)
        setupView()
    }

    /// Required initializer that is unavailable for use.
    ///
    /// This initializer triggers a runtime error if called, as it is not implemented.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// The delegate for the table view.
    ///
    /// This property is used to manage interactions with the table view.
    public var delegate: UITableViewDelegate? {
        get { tableView.delegate }
        set { tableView.delegate = newValue }
    }

    /// Reloads the data in the table view.
    ///
    /// This method triggers a reload of the table view's data on the main thread.
    public func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    /// Registers a cell class for reuse in the table view.
    ///
    /// - Parameters:
    ///   - cellType: The class of the cell to be registered.
    ///   - identifier: The reuse identifier for the cell.
    public func registerCell(with cellType: (some UITableViewCell).Type, identifier: String) {
        tableView.register(cellType, forCellReuseIdentifier: identifier)
    }

    /// Sets up a header view for the table view.
    ///
    /// - Parameter headerView: The view to use as the table view's header.
    public func setupHeaderView(_ headerView: UIView?) {
        tableView.tableHeaderView = headerView
    }

    /// Sets up a footer view for the table view.
    ///
    /// - Parameter footerView: The view to use as the table view's footer.
    public func setupFooterView(_ footerView: UIView?) {
        tableView.tableFooterView = footerView
    }

    /// Configures the separator inset for the table view cells.
    ///
    /// - Parameter insets: The insets to apply to the cell separators.
    public func setupSeparatorInset(_ insets: UIEdgeInsets) {
        tableView.separatorInset = insets
    }

    /// Sets up a background view for the table view.
    ///
    /// - Parameter view: The view to use as the table view's background.
    public func setupBackgroundView(_ view: UIView) {
        tableView.backgroundView = view
    }

    /// Inserts rows at the specified index paths with an animation.
    ///
    /// - Parameter indexPath: An array of index paths representing the rows to insert.
    public func setupInsertRows(_ indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: indexPath, with: .fade)
        }
    }

    /// Reloads the rows at the specified index paths with no animation.
    ///
    /// - Parameter indexPath: An array of index paths representing the rows to reload.
    public func setupReloadRows(_ indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPath, with: .none)
        }
    }

    /// Selects a row at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the row to select.
    public func setupSelectRow(_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    /// Configures the separator style of the table view.
    ///
    /// - Parameter style: The separator style to apply (e.g., `.none`, `.singleLine`).
    public func setupSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) {
        tableView.separatorStyle = style
    }
}

// MARK: - Setup

private extension BaseTableView {
    /// Sets up the view hierarchy and layout constraints for the table view.
    ///
    /// This method configures the default appearance of the table view,
    /// including background color, separator style, and indicator style.
    /// It also adds the table view to the view hierarchy and applies layout constraints.
    private func setupView() {
        backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black12
        tableView.indicatorStyle = .black
        tableView.allowsMultipleSelection = false

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

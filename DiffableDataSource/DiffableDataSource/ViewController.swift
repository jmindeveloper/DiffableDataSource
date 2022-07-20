//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by J_Min on 2022/07/20.
//

import UIKit

struct Item: Hashable {
    let id = UUID().uuidString
    let content: String
    
    init(content: String) {
        self.content = content
    }
}

class ViewController: UIViewController {
    
    enum TableViewSection: CaseIterable {
        case main
    }

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<TableViewSection, Item>!
    private var tableViewItem = [Item]()
    private let randomItemContent = ["김지민", "김은서", "김현식", "뽀로로"]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiffableDataSource()
    }

    // MARK: - Method
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<TableViewSection, Item>(tableView: tableView) { table, indexPath, item -> UITableViewCell? in
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else { return UITableViewCell() }
            cell.label.text = item.content
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tableViewItem)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Action
    @IBAction func addTableViewItemButton(_ sender: Any) {
        let item = Item(content: randomItemContent.randomElement() ?? "김지민")
        tableViewItem.append(item)
        applySnapshot()
    }
    
    @IBAction func deleteTableViewItemButton(_ sender: Any) {
        tableViewItem.removeLast()
        applySnapshot()
    }
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}


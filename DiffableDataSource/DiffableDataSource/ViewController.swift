//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by J_Min on 2022/07/20.
//

import UIKit

struct Item: Hashable {
    // id로 모든 Item 인스턴스가 같은 값을 가지지 못하도록 해줌
    let id = UUID().uuidString
    let content: String
    
    init(content: String) {
        self.content = content
    }
    
    // 해쉬함수
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ViewController: UIViewController {
    
    enum TableViewSection: CaseIterable {
        case main
        case second
    }

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<TableViewSection, Item>?
    private let randomItemContent = ["김지민", "김은서", "김현식", "뽀로로"]
    private var tableViewItem = [Item]() {
        didSet {
            applySnapshot()
        }
    }
    
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
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Action
    @IBAction func addTableViewItemButton(_ sender: Any) {
        let item = Item(content: randomItemContent.randomElement() ?? "김지민")
        tableViewItem.append(item)
    }
    
    @IBAction func deleteTableViewItemButton(_ sender: Any) {
        if !tableViewItem.isEmpty {
            tableViewItem.removeLast()
        }
    }
    
    @IBAction func shuffleTableViewItemButton(_ sender: Any) {
        tableViewItem.shuffle()
    }
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}


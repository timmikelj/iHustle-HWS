//
//  ViewController.swift
//  iHustle
//
//  Created by Paul Hudson on 23/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

enum Section {
    case main
}

class ViewController: UITableViewController {
    var dataSource: UITableViewDiffableDataSource<Section, Group>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: DataController.didUpdateNotifaction, object: nil)
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, group in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath)
            let group = DataController.shared.groups[indexPath.row]
            
            cell.textLabel?.text = group.name
            
            let outstandingGoals = group.goals.filter { $0.isCompleted == false }
            
            if outstandingGoals.count == 0 {
                cell.detailTextLabel?.text = "No outstanding goals"
            } else {
                let goals = outstandingGoals.map { $0.name }
                cell.detailTextLabel?.text = "Outstanding goals: \(ListFormatter.localizedString(byJoining: goals))"
            }
            
            return cell
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func didUpdate() {
        let snapshot = NSDiffableDataSourceSnapshot<Section, Group>()
        snapshot.appendSections([.main])
        snapshot.appendItems(DataController.shared.groups)
        dataSource?.apply(snapshot)
        tableView.reloadData()
    }

    func edit(_ group: Group) {
        // MARK: New way of instantiating a view controller
        guard let vc = storyboard?.instantiateViewController(identifier: "EditGroup", creator: { coder in
            EditGroupViewController(coder: coder, group: group)
        }) else { return }

        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addGroup(_ sender: Any) {
        let newGroup = Group(name: "New Group", goals: [], created: Date())
        DataController.shared.append(newGroup)
        edit(newGroup)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let group = dataSource?.itemIdentifier(for: indexPath) {
            edit(group)
        }
    }
}

//
//  ScoreViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 07.03.22.
//

import UIKit
import CoreData

class ScoreViewController: UIViewController {

    var scores: [Score]?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Table View
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let scores = scores else { return 0 }
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self),
                                                       for: indexPath) as? TableViewCell else { return UITableViewCell.init() }
        
        guard let currentScore = scores?[indexPath.row] else { return UITableViewCell.init() }
        guard let date = currentScore.date else { return UITableViewCell.init() }
        
        cell.configure(scoreTitle: "Score: \(currentScore.score)",
                       dateTitle: date)
        return cell
    }
}

//
//  ScoreViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 07.03.22.
//

import UIKit
import CoreData

class ScoreViewController: UIViewController {

    private var score: [NSManagedObject] = []
    private var date: [NSManagedObject] = []

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
    return
    }
      let managedContext =
        appDelegate.persistentContainer.viewContext
    //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Score")
    //3
      do {
        score = try managedContext.fetch(fetchRequest)
          date = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    
    func save(currScore: Int16, currdate: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

      let managedContext =
        appDelegate.persistentContainer.viewContext

      let entity =
        NSEntityDescription.entity(forEntityName: "Score",
                                   in: managedContext)!
      let currentScore = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      let currentDate = NSManagedObject(entity: entity,
                                        insertInto: managedContext)

      currentScore.setValue(currScore, forKeyPath: "score")
      currentDate.setValue(currdate, forKey: "date")
        
      do {
        try managedContext.save()
        score.append(currentScore)
        date.append(currentDate)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
}

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return score.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let score = score[indexPath.row]
        let date = date[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self),
                                                       for: indexPath) as? TableViewCell else { return UITableViewCell.init() }
        guard let currentScore = score.value(forKeyPath: "score") else { return UITableViewCell.init() }
        guard let currentDate = date.value(forKeyPath: "date") else { return UITableViewCell.init() }
//        cell.textLabel?.text = "Score: \(currentScore)"
        cell.configure(scoreTitle: "Score: \(currentScore)",
                        dateTitle: "\(currentDate)")
        return cell
    }
    
}

extension Date {
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm T"
        return dateFormatter.string(from: self)
    }
}

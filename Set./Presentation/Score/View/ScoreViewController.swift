//
//  ScoreViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 07.03.22.
//

import UIKit
import CoreData

class ScoreViewController: UIViewController {
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coreDataStack: CoreDataStack
            
    lazy var fetchedResultsController: NSFetchedResultsController<Score> = {

        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: #keyPath(Score.score),
            cacheName: "Score")

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    let dateSort = NSSortDescriptor(key: #keyPath(Score.date), ascending: false)
    lazy var sortDescriptors = [dateSort]
    
    lazy var coreDataFetchedResults = CoreDataFetchedResults(ofType: Score.self,
                                                             entityName: "Score",
                                                             sortDescriptors: sortDescriptors,
                                                             managedContext: coreDataStack.managedContext,
                                                             delegate: self,
                                                             sectionNameKeyPath: #keyPath(Score.score),
                                                             cacheName: "Score")

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
        coreDataFetchedResults.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        coreDataManager.updateScore(at: index, with: score)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Table View
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coreDataFetchedResults.controller.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = coreDataFetchedResults.controller.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self),
                                                       for: indexPath) as? TableViewCell else { return UITableViewCell.init() }
        
        let currentScore = coreDataFetchedResults.controller.object(at: indexPath)
        guard let date = currentScore.date else { return UITableViewCell.init() }

        cell.configure(scoreTitle: "Score: \(currentScore.score)",
                       dateTitle: date,
                       index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            let score = self.coreDataFetchedResults.controller.object(at: indexPath) 
            self.coreDataFetchedResults.managedContext.delete(score)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ScoreViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! TableViewCell
            let score = coreDataFetchedResults.controller.object(at: indexPath!)
            guard let indexPath = indexPath else { return }
            cell.configure(scoreTitle: "\(score.score)", dateTitle: "\(String(describing: score.date))", index: indexPath.row)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}



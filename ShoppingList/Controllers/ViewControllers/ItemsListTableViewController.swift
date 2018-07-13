//
//  ItemsListTableViewController.swift
//  ShoppingList
//
//  Created by Zachary Frew on 7/13/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CoreData

class ItemsListTableViewController: UITableViewController {

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error occured while fetching data: \(error.localizedDescription).")
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddAlertController()
    }
    
    // MARK: - Properties
    let fetchedResultsController: NSFetchedResultsController<Item> = {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let timeStampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [timeStampSortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    // MARK: - Methods
    func presentAddAlertController() {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        var itemTextField: UITextField?
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter an item..."
            itemTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemText = itemTextField?.text else { return }
            ItemController.shared.addItem(with: itemText)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let item = fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.updateCell(item: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            ItemController.shared.delete(item: item)
        }
    }

}

// MARK: - ItemTableViewCell Delegate Conformance
extension ItemsListTableViewController: ItemTableViewCellDelegate {
    
    func cellButtonTapped(_ cell: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = fetchedResultsController.object(at: indexPath)
        ItemController.shared.toggleIsItemInCart(item: item)
        cell.updateCell(item: item)
    }
    
}

extension ItemsListTableViewController: NSFetchedResultsControllerDelegate {
   
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .left)
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}

//
//  PriceListsTableViewController.swift
//  MrScrooge
//
//  Created by Danil Denshin on 04.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreData

class PriceListsTableViewController: CoreDataTableViewController {
	
	var container: NSPersistentContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFetchedResultController()
		
	}
	
	private func setupFetchedResultController() {
		
		let fetchRequest: NSFetchRequest<PriceList> = PriceList.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		
		let resultController = NSFetchedResultsController<PriceList>(
			fetchRequest: fetchRequest,
			managedObjectContext: container.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchedResultController = resultController as? NSFetchedResultsController<NSFetchRequestResult>
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PriceListCell)
		if let priceList = fetchedResultController?.object(at: indexPath) as? PriceList {
			cell?.textLabel?.text = priceList.title
		}
		return cell!
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier, identifier == Storyboard.AddNewPriceList {
			
			if let iltvc = segue.destination as? ItemsListTableViewController {
				let newPrice = PriceList(context: container.viewContext, title: "Price list #\(tableView.numberOfRows(inSection: 0) + 1)", items: [])
				newPrice.date = Date(timeIntervalSinceNow: 0)
				do {
					try container.viewContext.save()
					iltvc.priceList = newPrice
				} catch {
					print("Error adding new price list: \(error)")
				}
			}
			
		} else if let identifier = segue.identifier, identifier == Storyboard.ShowPriceList {
			
			if let iltvc = segue.destination as? ItemsListTableViewController {
				guard let cell = sender as? UITableViewCell else { return }
				guard let indexPath = tableView.indexPath(for: cell) else { return }
				iltvc.priceList = fetchedResultController?.object(at: indexPath) as? PriceList
			}
			
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			if let object = fetchedResultController?.object(at: indexPath) as? PriceList {
				container.viewContext.delete(object)
				do {
					try container.viewContext.save()
				} catch {
					print("Error deleting price list: \(error)")
				}
			}
		case .insert: break
		case .none: break
		}
		
		
	}
	
	private struct Storyboard {
		static let AddNewPriceList = "Add New Price List"
		static let PriceListCell = "Price List Cell"
		static let ShowPriceList = "Show Price List"
	}



}

//
//  ViewController.swift
//  MrScrooge
//
//  Created by Danil Denshin on 03.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreData

class ItemsListTableViewController: CoreDataTableViewController, ItemTableViewCellDelegate {
	
	let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
	
	var priceList: PriceList? {
		didSet {
			updateSum()
		}
	}
	
	var sum: Double = 0.0 { didSet { sumLabel.text = formatter.string(for: sum) } }
	
	var sumLabel: UILabel = {
		let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 30)))
		label.textAlignment = .right
		label.text = "0.0"
		return label
	}()
	
	@IBAction func editPriceListName(_ sender: UIBarButtonItem) {
		
		let alertVC = UIAlertController(title: nil, message: "Enter name of price list", preferredStyle: .alert)
		alertVC.addTextField { (textField) in
			textField.placeholder = "Name of price list"
			textField.text = self.priceList?.title
		}
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
			if let text = alertVC.textFields?.first?.text {
				self.title = text
				self.priceList?.title = text
				do {
					try self.container?.viewContext.save()
				} catch {
					print("Error renaming price list: \(error)")
				}
			}
		}))
		alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
	
	private func updateSum() {
		sum = (priceList?.items)?.reduce(0, {$0 + $1.price}) ?? 0.0
	}
	
	private func setupFetchedResultController() {
		
		if priceList != nil, let context = container?.viewContext {
			let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "priceList = %@", priceList!)
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
			
			let resultController = NSFetchedResultsController<Item>(
				fetchRequest: fetchRequest,
				managedObjectContext: context,
				sectionNameKeyPath: nil,
				cacheName: nil)
			fetchedResultController = resultController as? NSFetchedResultsController<NSFetchRequestResult>
		} else {
			fetchedResultController = nil
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = priceList?.title
		tableView.separatorStyle = .none
		
		setupFetchedResultController()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupBottomToolbar()
	}
	
	private func setupBottomToolbar() {
		navigationController?.isToolbarHidden = false
		
		let sumLableBarItem = UIBarButtonItem(customView: sumLabel)
		let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		let textLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 30)))
		textLabel.text = "Total: "
		textLabel.textAlignment = .right
		let textLabelBarItem = UIBarButtonItem(customView: textLabel)
		
		setToolbarItems([flexibleItem, textLabelBarItem, sumLableBarItem], animated: false)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isToolbarHidden = true
	}
	
	override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		super.controllerDidChangeContent(controller)
		updateSum()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return super.tableView(tableView, numberOfRowsInSection: section) + 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ItemCell) as? ItemTableViewCell
		
		if let sections = fetchedResultController?.sections {
			if indexPath.row >= sections[indexPath.section].numberOfObjects {
				cell?.item = nil
			} else {
				cell?.item = fetchedResultController?.object(at: indexPath) as? Item
			}
		}
		cell?.delegate = self
		return cell!
		
	}
	
	private func isTheLastCell(atIndexPath indexPath: IndexPath) -> Bool {
		return tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return !isTheLastCell(atIndexPath: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			if !isTheLastCell(atIndexPath: indexPath) {
				if let context = container?.viewContext,
					let item = fetchedResultController?.object(at: indexPath) as? Item {
					context.delete(item)
					do {
						try context.save()
					} catch {
						print("Error deleting item: \(error)")
					}
				}
			}
		default: break
		}
	}
	
	func itemTableViewCellDidEndEditing(cell: ItemTableViewCell) {
		if let indexPath = tableView.indexPath(for: cell) {
			if let item = cell.item {
				if isTheLastCell(atIndexPath: indexPath) {
					priceList?.items.insert(item)
				}
			}
		}
		do {
			try container?.viewContext.save()
		} catch {
			print("Error adding new item in price list: \(error)")
		}
	}
	
	struct Storyboard {
		static let ItemCell = "Item Cell"
		static let EditPriceListnameSegue = "Edit Price List Name"
	}
}


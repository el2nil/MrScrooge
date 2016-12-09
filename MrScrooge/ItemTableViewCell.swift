//
//  ItemTableViewCell.swift
//  MrScrooge
//
//  Created by Danil Denshin on 03.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreData

protocol ItemTableViewCellDelegate {
	func itemTableViewCellDidEndEditing(cell: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell, UITextFieldDelegate {
	
	let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
	
	var item: Item? {
		didSet {
			nameTextField.text = item?.name
			priceTextField.text = item?.price == 0 ? "" : formatter.string(for: item?.price)
		}
	}
	
	var delegate: ItemTableViewCellDelegate?
	
	var name: String { return nameTextField.text ?? "" }
	var price: Double { return Double(priceTextField.text ?? "0") ?? 0 }
	
	
	@IBOutlet weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
	@IBOutlet weak var priceTextField: UITextField! {
		didSet {
			priceTextField.delegate = self
			setupKeyboardAccessory()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		switch textField {
		case priceTextField:
			if let text = textField.text,
				string == formatter.decimalSeparator,
				text.characters.contains(Character(string)) {
				return false
			}
		case nameTextField:
			if let text = textField.text, text.isEmpty, string == " " {
				return false
			}
		default:
			return true
		}
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let context = container?.viewContext {
			if name.isEmpty && price.isZero {
				if item != nil {
					do {
						context.delete(item!)
						try context.save()
					} catch {
						print("Error deleting item: \(error)")
					}
				}
			} else {
				if item != nil {
					item?.name = name
					item?.price = price
					item?.priceList?.date = Date(timeIntervalSinceNow: 0)
					do {
						try context.save()
					} catch {
						print("Error updating item: \(error)")
					}
				} else {
					item = Item(context: context, name: name, price: price)
					item?.date = Date(timeIntervalSinceNow: 0)
				}
			}
			delegate?.itemTableViewCellDidEndEditing(cell: self)
		}
	}
	
	private func setupKeyboardAccessory() {
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		toolbar.backgroundColor = UIColor.lightGray
		let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: priceTextField, action: #selector(resignFirstResponder))
		toolbar.items = [flexBarButton, doneBarButton]
		priceTextField.inputAccessoryView = toolbar
	}
	
}

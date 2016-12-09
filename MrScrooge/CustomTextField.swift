//
//  CustomTextField.swift
//  MrScrooge
//
//  Created by Danil Denshin on 04.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
	
	let textOffstet: CGFloat = 10
	
	private func rect(withOffset offset: CGFloat, forRect rect: CGRect, textAligment: NSTextAlignment) -> CGRect {
		switch textAligment {
		case .right:
			return CGRect(x: 0, y: 0, width: rect.size.width - offset, height: rect.size.height)
		case .left:
			return CGRect(x: offset, y: 0, width: rect.size.width - offset, height: rect.size.height)
		case .justified:
			return rect
		case .center:
			return rect
		case .natural:
			return CGRect(x: offset, y: 0, width: rect.size.width - offset, height: rect.size.height)
		}
	}

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return rect(withOffset: 10, forRect: bounds, textAligment: self.textAlignment)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return rect(withOffset: 10, forRect: bounds, textAligment: self.textAlignment)
	}

}

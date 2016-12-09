//
//  Formatter.swift
//  MrScrooge
//
//  Created by Danil Denshin on 07.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation

let formatter: NumberFormatter = {
	let formatter = NumberFormatter()
	formatter.locale = Locale.current
	formatter.maximumFractionDigits = 2
	formatter.minimumFractionDigits = 2
	formatter.groupingSeparator = " "
	formatter.numberStyle = .decimal
	return formatter
}()

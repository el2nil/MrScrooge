//
//  Item+CoreDataProperties.swift
//  MrScrooge
//
//  Created by Danil Denshin on 07.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var priceList: PriceList?
	@NSManaged public var date: Date?
	
	convenience init(context: NSManagedObjectContext, name: String, price: Double) {
		self.init(context: context)
		self.name = name
		self.price = price
	}

}

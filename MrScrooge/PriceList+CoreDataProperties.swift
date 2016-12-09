//
//  PriceList+CoreDataProperties.swift
//  MrScrooge
//
//  Created by Danil Denshin on 07.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData


extension PriceList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceList> {
        return NSFetchRequest<PriceList>(entityName: "PriceList");
    }

    @NSManaged public var title: String?
    @NSManaged public var items: Set<Item>
	@NSManaged public var date: Date?
	
	convenience init(context: NSManagedObjectContext, title: String, items: Set<Item>) {
		self.init(context: context)
		self.title = title
		self.items = items
	}

}

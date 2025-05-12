//
//  CartItemEntity+CoreDataProperties.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//
//

import Foundation
import CoreData

extension CartItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItemEntity> {
        return NSFetchRequest<CartItemEntity>(entityName: "CartItemEntity")
    }

    @NSManaged public var addedDate: Date?
    @NSManaged public var quantity: Int16
    @NSManaged public var book: BookEntity?

}

extension CartItemEntity : Identifiable {

}

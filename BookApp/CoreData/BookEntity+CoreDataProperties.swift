//
//  BookEntity+CoreDataProperties.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//
//

import Foundation
import CoreData

extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var authors: NSArray?
    @NSManaged public var contents: String?
    @NSManaged public var isbn: String?
    @NSManaged public var price: Int32
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var title: String?
    @NSManaged public var cartItems: CartItemEntity?

}

extension BookEntity : Identifiable {

}

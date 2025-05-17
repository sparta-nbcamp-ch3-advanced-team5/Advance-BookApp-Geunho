//
//  RecentBookCoreDataManager.swift
//  BookApp
//
//  Created by 정근호 on 5/16/25.
//

import Foundation
import CoreData
import DomainLayer

public final class RecentBookCoreDataRepository: RecentBookCoreDataRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Read
    /// 최근 본 책 정보들 Book으로 변환하여 불러옴
    public func fetchRecentBook() -> [Book] {
        
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
        
        do {
            let recentBookEntities = try context.fetch(fetchRequest)
            
            return recentBookEntities.map { recentBookEntity -> Book in
                
                return Book(
                    authors: recentBookEntity.authors?.components(separatedBy: ", ") ?? [],
                    contents: recentBookEntity.contents ?? "",
                    price: Int(recentBookEntity.price),
                    title: recentBookEntity.title ?? "",
                    thumbnail: recentBookEntity.thumbnail ?? "",
                    isbn: recentBookEntity.isbn ?? "")
            }
        } catch {
            print("장바구니 아이템 가져오기 실패: \(error)")
            return []
        }
    }
    
    // MARK: - Update
    /// 최근 본 책 설정(추가), 10개 일 시 가장 먼저 추가됐던 책 제거
    public func configureRecentBook(book: Book) {
        
        if recentBookSize() < 10 {
            addRecentBook(book: book)
        } else {
            deleteFirstRecentBook()
            addRecentBook(book: book)
        }
        
    }
    
    // 최근 본 책 개수
    private func recentBookSize() -> Int {
        let recentBookSize = fetchRecentBook().count
        return recentBookSize
    }
    
    // MARK: - Create
    // 최근 본 책 추가
    private func addRecentBook(book: Book) {
        guard let recentBookEntity = NSEntityDescription.entity(forEntityName: "RecentBookEntity", in: context) else {
            return
        }
        
        deleteDuplicatedRecentBook(isbn: book.isbn)
        
        do {
            
            let managedObject = NSManagedObject(entity: recentBookEntity, insertInto: context)
            managedObject.setValue(book.title, forKey: "title")
            managedObject.setValue(book.thumbnail, forKey: "thumbnail")
            managedObject.setValue(book.price, forKey: "price")
            managedObject.setValue(book.authors.joined(separator: ", "), forKey: "authors")
            managedObject.setValue(book.isbn, forKey: "isbn")
            managedObject.setValue(book.contents, forKey: "contents")
            
            try context.save()
        } catch {
            print("최근 책 추가 실패: \(error)")
        }
    }
    
    // MARK: - Delete
    // 가장 먼저 추가됐던 최근 본 책 제거
    private func deleteFirstRecentBook() {
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
        
        do {
            let recentBookEntities = try context.fetch(fetchRequest)
            
            let firstRecentBookEntity = recentBookEntities.first!
            
            context.delete(firstRecentBookEntity)
            
            try context.save()
        } catch {
            print("첫번째 삭제 실패: \(error)")
        }
    }
    
    private func deleteDuplicatedRecentBook(isbn: String) {
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                for objectToDelete in results {
                    context.delete(objectToDelete)
                }
            }
        } catch {
            print("중복 삭제 실패: \(error)")
        }
    }
}

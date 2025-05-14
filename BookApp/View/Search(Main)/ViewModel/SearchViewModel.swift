//
//  BookSearchViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation
import RxSwift

final class SearchViewModel {
    var searchingText: String = ""
    let disposeBag = DisposeBag()
    let searchedBookSubject = BehaviorSubject(value: [Book]())
    let recentBookSubject = BehaviorSubject(value: [Book]())
    let metaData = BehaviorSubject(value: MetaData(isEnd: true, pageableCount: 0, totalCount: 0))
    /// 한 페이지에 보여질 문서 수, 1~50 사이의 값, 기본 값 10
    let size = 10
    
    var isLoading = false
    var page = 1
    var endScroll = false
    var isEnd = false
    
    private let coreDataManager: RecentBookStorageManager = CoreDataManager.shared
    
    init() {
        fetchRecentBooks()
    }
    
    func searchBooks() {
        isLoading = true
        
        print("searchingPage: \(page)")
        guard let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(searchingText)&size=\(size)&page=\(page)")
        else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (bookResponse: BookResponse) in
                self?.metaData.onNext(bookResponse.meta)
                self?.isEnd = bookResponse.meta.isEnd
                print(bookResponse.meta, self?.endScroll)
                if !bookResponse.meta.isEnd && self?.endScroll == true {
                    do {
                        guard let currentBooks = try self?.searchedBookSubject.value() else { return }
                        self?.searchedBookSubject.onNext(currentBooks + bookResponse.documents)
                    } catch {
                        print("현재 searchedBookSubject 가져오기 실패: \(error)")
                        self?.searchedBookSubject.onNext(bookResponse.documents)
                    }
                } else {
                    self?.searchedBookSubject.onNext(bookResponse.documents)
                }
                self?.isLoading = false
            }, onFailure: { [weak self] error in
                self?.searchedBookSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        recentBookSubject.onNext(coreDataManager.fetchRecentBook())
        print(recentBookSubject)
    }
}

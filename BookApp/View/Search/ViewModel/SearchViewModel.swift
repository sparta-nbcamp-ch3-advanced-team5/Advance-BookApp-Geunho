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
    /// 한 페이지에 보여질 문서 수, 1~50 사이의 값, 기본 값 10
    let size = 50
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchRecentBooks()
    }
    
    func searchBooks() {
        guard let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(searchingText)&size=\(size)")
        else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (bookResponse: BookResponse) in
                self?.searchedBookSubject.onNext(bookResponse.documents)
            }, onFailure: { [weak self] error in
                self?.searchedBookSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        recentBookSubject.onNext(coreDataManager.fetchRecentBook())
        print(recentBookSubject)
    }
}

//
//  BookSearchViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation
import RxSwift

final class SearchViewModel {
        
    let disposeBag = DisposeBag()
    let searchedBookSubject = BehaviorSubject(value: [Book]())
    let recentBookSubject = BehaviorSubject(value: [Book]())
    let metaData = BehaviorSubject(value: MetaData(isEnd: true, pageableCount: 0, totalCount: 0))
    
    /// 한 페이지에 보여질 문서 수, 1~50 사이의 값, 기본 값 10
    let size = 10
    /// 현재 데이터를 받아오는 중인지 (searchBooks() 실행 시 true, 종료 전 false)
    var isLoading = false
    /// 현재 페이지
    var page = 1
    /// 검색 값
    var searchingText: String = ""

    
    private let coreDataManager: RecentBookStorageManager = CoreDataManager.shared
    
    init() {
        fetchRecentBooks()
    }
    
    func searchBooks() {
        
        print("searchingPage: \(page)")
        
        // 문자열을 URL-safe하게 변환 후 URL 설정
        guard let encodedQuery = searchingText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(encodedQuery)&size=\(size)&page=\(page)")
        else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (bookResponse: BookResponse) in
                guard let self = self else { return }
                self.metaData.onNext(bookResponse.meta)
                print(bookResponse.meta)
                do {
                    // 새로 검색 값을 추가
                    let currentBooks = try self.searchedBookSubject.value()
                    self.searchedBookSubject.onNext(currentBooks + bookResponse.documents)
                } catch {
                    print("현재 searchedBookSubject 가져오기 실패: \(error)")
                    self.searchedBookSubject.onNext(bookResponse.documents)
                }
                self.isLoading = false
            }, onFailure: { [weak self] error in
                self?.searchedBookSubject.onError(error)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        recentBookSubject.onNext(coreDataManager.fetchRecentBook())
        print(recentBookSubject)
    }
}

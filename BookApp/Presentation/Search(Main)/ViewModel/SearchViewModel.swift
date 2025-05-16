//
//  BookSearchViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation
import RxSwift

final class SearchViewModel {
        
    private let recentBookCoreDataRepository: RecentBookCoreDataRepository
    private let disposeBag = DisposeBag()
    /// 한 페이지에 보여질 문서 수, 1~50 사이의 값, 기본 값 10
    private let size = 10
    
    let searchedBookSubject = BehaviorSubject(value: [Book]())
    let recentBookSubject = BehaviorSubject(value: [Book]())
    let metaData = BehaviorSubject(value: MetaData(isEnd: true, pageableCount: 0, totalCount: 0))
    
    /// 현재 데이터를 받아오는 중인지 (searchBooks() 실행 시 true, 종료 전 false)
    var isLoading = false
    /// 현재 페이지
    var page = 1
    /// 검색 값
    var searchingText: String = ""
    /// 로딩 종료 시 실행
    var onLoadingEndAction: (() -> Void)?
    
    init(recentBookCoreDataRepository: RecentBookCoreDataRepository) {
        self.recentBookCoreDataRepository = recentBookCoreDataRepository
        fetchRecentBooks()
    }
    
    func searchBooks() {
        
        // 중복 검색 방지
        guard !isLoading else { return }
        isLoading = true
        
        print("searchingPage: \(page)")
        
        // 문자열을 URL-safe하게 변환 후 URL 설정
        guard let encodedQuery = searchingText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(encodedQuery)&size=\(size)&page=\(page)")
        else { return }
        
        BookResponseRepository.shared.fetchBookResponse(url: url)
            .subscribe(onSuccess: { [weak self] (bookResponse: BookResponse) in
                guard let self = self else { return }
                
                self.metaData.onNext(MetaDataTranslator.toDomain(from: bookResponse.meta))

                print(bookResponse.meta)
                do {
                    // 새로 검색 값을 추가
                    let currentBooks = try self.searchedBookSubject.value()
                    let newBooks = BookTranslator.toDomainInList(from: bookResponse.documents)
                    self.searchedBookSubject.onNext(currentBooks + newBooks)
                    // 값 추가 후 page 증가
                    self.page += 1
                    // 로딩 완료 후 검색, 초기화 실행, nil로 중복 방지
                    self.onLoadingEndAction?()
                    self.onLoadingEndAction = nil
                } catch {
                    print("현재 searchedBookSubject 가져오기 실패: \(error)")
                    let newBooks = BookTranslator.toDomainInList(from: bookResponse.documents)
                    self.searchedBookSubject.onNext(newBooks)
                }
                self.isLoading = false
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.searchedBookSubject.onError(error)
                self.isLoading = false
            }).disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        recentBookSubject.onNext(recentBookCoreDataRepository.fetchRecentBook())
        print(recentBookSubject)
    }
    
    /// 페이지 초기화, 이전 검색 결과 초기화
    func resetSearchData() {
        self.page = 1
        self.searchedBookSubject.onNext([])
    }
}

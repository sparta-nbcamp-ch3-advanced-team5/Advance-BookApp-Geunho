//
//  SearchViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
import SnapKit
import RxSwift

/// 섹션 종류: 최근 본 책, 검색 결과
enum Section: Int, CaseIterable {
    case recentBook
    case searchResult
    
    var title: String {
        switch self {
        case .recentBook:
            return "최근 본 책"
        case .searchResult:
            return "검색 결과"
        }
    }
}

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    private var searchedBooks = [Book]()
    private var recentBooks = [Book]()
    private var metaData = MetaData(isEnd: true, pageableCount: 0, totalCount: 0)
    private var page = 1
    
    weak var bottomSheetDelegate: BottomSheetDelegate?
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // 최근 본 책 Cell
        collectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.id)
        // 검색 결과 Cell
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.id)
        // 헤더 뷰
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    // MARK: - Init & SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchRecentBooks()
        self.mainCollectionView.reloadData()
    }
    
    private func setUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [searchBar, mainCollectionView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    // MARK: - Private Methods
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection in
            
            let isLandscape = layoutEnvironment.traitCollection.verticalSizeClass == .compact
            
            // sectionIndex에 따라 레이아웃 따로 설정
            switch Section(rawValue: sectionIndex) {
            case .recentBook:
                // 아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: isLandscape ? .fractionalWidth(0.125) : .fractionalWidth(0.25),
                                                       heightDimension: isLandscape ? .fractionalWidth(0.2) : .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = isLandscape ? 8 : 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
                if !self.recentBooks.isEmpty {
                    section.boundarySupplementaryItems = [self.createSectionHeaderLayout()]
                }
                
                return section
                
            case .searchResult:
                // 아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: isLandscape ? .fractionalWidth(0.1) : .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
                if !self.searchedBooks.isEmpty {
                    section.boundarySupplementaryItems = [self.createSectionHeaderLayout()]
                }
                
                return section
            default:
                fatalError("Index \(sectionIndex) does not exists.")
            }
        }
        return layout
    }
    
    /// 헤더 레이아웃 추가
    private func createSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem{
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.searchedBookSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.searchedBooks = books
                print("searchedBooksCount: \(books.count)")
                // 검색 값 변경 시 리로드
                self?.mainCollectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
        
        viewModel.recentBookSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.recentBooks = books
                // 최근 본 책 값 변경 시 리로드
                self?.mainCollectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
        
        viewModel.metaData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.metaData = data
                print("metaData: \(data.totalCount), \(data.pageableCount), \(data.isEnd) ")
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func activateSearchBar() {
        searchBar.becomeFirstResponder()
    }
}

// MARK: - CollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
            
        case .recentBook:
            // 제일 나중에 추가된 요소가 맨 앞으로
            navigateToBookInfoView(selectedBook: recentBooks[recentBooks.count - 1 - indexPath.row])
        case .searchResult:
            navigateToBookInfoView(selectedBook: searchedBooks[indexPath.row])
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 현재 스크롤 위치 + 화면 높이 / 2 > 콘텐츠 전체 높이 - 보이는 높이
        if self.mainCollectionView.contentOffset.y + view.frame.height / 2 > mainCollectionView.contentSize.height - mainCollectionView.bounds.size.height {
            
            // metaData.isEnd값이 false 일 때 페이지 추가 및 추가 로드
            if !metaData.isEnd {
                viewModel.page+=1
                self.viewModel.searchBooks()
            }
        }
    }
}

// MARK: - CollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .recentBook:
            return self.recentBooks.count
        case .searchResult:
            return self.searchedBooks.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 섹션별로 나눠서 처리
        switch Section(rawValue: indexPath.section) {
        case .recentBook:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecentBookCell.id,
                for: indexPath) as? RecentBookCell else {
                return UICollectionViewCell()
            }
            // 제일 나중에 추가된 요소가 맨 앞으로
            cell.configure(with: recentBooks[recentBooks.count - 1 - indexPath.row])
            return cell
        case .searchResult:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookInfoCell.id,
                for: indexPath) as? BookInfoCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: searchedBooks[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let kind = UICollectionView.elementKindSectionHeader
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        let sectionType = Section.allCases[indexPath.section]
        headerView.configure(with: sectionType.title)
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
}

// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        viewModel.searchingText = text
        print("searchingText: \(text)")
        
        // 스크롤 최상단으로 이동
        // 스크롤 이동 중지
        mainCollectionView.setContentOffset(mainCollectionView.contentOffset, animated: false)
        // 페이지 초기화
        self.viewModel.page = 1
        // 이전 검색 결과 초기화
        self.viewModel.searchedBookSubject.onNext([])
        // 새로 검색 요청
        self.viewModel.searchBooks()
    }
}

// MARK: - BookInfoDelegate
extension SearchViewController: BottomSheetDelegate {
    
    func didAddToCart() {
        showAlert()
    }
    
    func bottomSheetDidDismiss() {
        viewModel.fetchRecentBooks()
        self.mainCollectionView.reloadData()
    }
}

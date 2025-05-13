//
//  BookSearchViewController.swift
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

class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()
    private let disposeBag = DisposeBag()
    private var searchedBooks = [Book]()
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private lazy var searchCollectionView: UICollectionView = {
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
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Init & SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [searchBar, searchCollectionView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchCollectionView.snp.makeConstraints {
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
                section.boundarySupplementaryItems = [self.createSectionHeaderLayout()]
                
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
                section.boundarySupplementaryItems = [self.createSectionHeaderLayout()]
                
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
    
    private func bindViewModel() {
        viewModel.searchedBookSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.searchedBooks = books
                print("firstSearchedBook: \(books.first)")
                print("searchedBooksCount: \(books.count)")
                self?.searchCollectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    func activateSearchBar() {
        searchBar.becomeFirstResponder()
    }
}

// MARK: - CollectionViewDelegate
extension BookSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToBookInfoView(selectedBook: searchedBooks[indexPath.row])
    }
}

// MARK: - CollectionViewDataSource
extension BookSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .recentBook:
            return 10
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
extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchingText = text
        print("searchingText: \(text)")
        viewModel.searchBooks()
    }
}

// MARK: - BookInfoDelegate
extension BookSearchViewController: BookInfoViewControllerDelegate {
    
    func showToastAlert() {
        if view.viewWithTag(999) != nil {
            self.view.viewWithTag(999)?.removeFromSuperview()
        }
        
        let toast = UILabel()
        toast.text = "책 담기 완료!"
        toast.tag = 999
        toast.textColor = .systemBackground
        toast.backgroundColor = UIColor.separator.withAlphaComponent(0.7)
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .bold)
        toast.alpha = 0
        toast.clipsToBounds = true
        toast.numberOfLines = 0
        
        let padding: CGFloat = 20
        let maxWidth = (view.frame.width - padding * 2) / 2
        let size = toast.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        toast.frame = CGRect(x: view.frame.width/2 - (maxWidth/2),
                             y: view.frame.maxY - size.height - 130,
                             width: maxWidth,
                             height: size.height + 16)
        
        toast.layer.cornerRadius = toast.frame.height / 2
        
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
        
    }
}

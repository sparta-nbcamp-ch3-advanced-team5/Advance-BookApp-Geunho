//
//  BookSearchViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
import SnapKit

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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private lazy var searchCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.id)
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.id)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
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

    private func createLayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection in

            switch Section(rawValue: sectionIndex) {
            case .recentBook:
                // 아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                       heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)

                // 헤더 추가
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]

                return section

            case .searchResult:
                // 아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)

                // 헤더 추가
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]

                return section
            default:
                fatalError("Index \(sectionIndex) does not exists.")
            }
        }
        return layout
    }
}

extension BookSearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToBookInfoView()
    }
}

extension BookSearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .recentBook:
            return 10
        case .searchResult:
            return 15
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

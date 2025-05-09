//
//  BookCartViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit

class BookCartViewController: UIViewController {

    private lazy var cartCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()

    private func createLayout() -> UICollectionViewCompositionalLayout {

        // 아이템
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // 섹션
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        navigationItem.title = "담은 책"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "전체 삭제", style: .plain, target: self, action: #selector(removeAll)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가", style: .plain, target: self, action: #selector(addToCart)
        )
    }

    private func setUI() {
        view.backgroundColor = .secondarySystemBackground

        view.addSubview(cartCollectionView)

        cartCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc private func addToCart() {

    }

    @objc private func removeAll() {

    }
}

extension BookCartViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToBookInfoView()
    }
}

extension BookCartViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCell.id,
            for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

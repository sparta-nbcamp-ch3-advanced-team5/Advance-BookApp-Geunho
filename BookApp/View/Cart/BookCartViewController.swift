//
//  BookCartViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
import SnapKit

class BookCartViewController: UIViewController {
    
    private let viewModel: BookCartViewModel

    // MARK: - UI Components
    private lazy var cartCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    // MARK: - Init & SetUp
    init(viewModel: BookCartViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK: - Private Methods
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

    // MARK: - Actions
    @objc private func addToCart() {

    }

    @objc private func removeAll() {

    }
}

// MARK: - CollectionViewDelegate
extension BookCartViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        navigateToBookInfoView(selectedBook: )
    }
}

// MARK: - CollectionViewDataSource
extension BookCartViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookInfoCell.id,
            for: indexPath) as? BookInfoCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

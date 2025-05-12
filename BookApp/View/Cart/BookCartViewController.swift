//
//  BookCartViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
import SnapKit
import RxSwift

class BookCartViewController: UIViewController {
    
    private let viewModel: BookCartViewModel
    private let disposeBag = DisposeBag()
    
    private var cartItems: [CartItem] = []
    
    // MARK: - UI Components
    private lazy var cartCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "장바구니가 비었습니다."
        label.textColor = .label
        return label
    }()
    
    // 네비게이션 바 버튼들
    private lazy var removeAllBarButton = UIBarButtonItem(title: "전체 삭제", style: .plain, target: self, action: #selector(removeAllButtonTapped))
    private lazy var addToCartBarButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addToCartButtonTapped))
    
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
        
        setupNavigation()
        setUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 카트뷰 새로고침
        viewModel.refreshCartItems()
    }
    
    private func setupNavigation() {
        navigationItem.title = "담은 책"
        navigationItem.leftBarButtonItem = removeAllBarButton
         navigationItem.rightBarButtonItem = addToCartBarButton
    }
    
    private func setUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(cartCollectionView)
        view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        cartCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        // viewModel.cartItems 스트림 구독
        viewModel.cartItems
            .observe(on: MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .subscribe(onNext: { [weak self] items in
                self?.cartItems = items // 로컬 프로퍼티 업데이트
                self?.cartCollectionView.reloadData() // 컬렉션 뷰 새로고침
            })
            .disposed(by: disposeBag)
        
        // viewModel.isCartEmpty 스트림 구독
        viewModel.isCartEmpty
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty in
                self?.cartCollectionView.isHidden = isEmpty
                self?.emptyLabel.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }
    
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
    @objc private func addToCartButtonTapped() {
    
    }
    
    @objc private func removeAllButtonTapped() {
    }
}

// MARK: - CollectionViewDelegate
extension BookCartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCartItem = cartItems[indexPath.row]
        print("선택된 아이템: \(selectedCartItem.title)")
    }
}

// MARK: - CollectionViewDataSource
extension BookCartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookInfoCell.id,
            for: indexPath) as? BookInfoCell else {
            return UICollectionViewCell()
        }
        let cartItem = cartItems[indexPath.row]
        cell.configureInCartView(with: cartItem)
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

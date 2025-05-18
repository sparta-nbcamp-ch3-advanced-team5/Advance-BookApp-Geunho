//
//  CartViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
internal import SnapKit
internal import RxSwift
import DomainLayer

public final class CartViewController: UIViewController {
    
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()
    
    private var cartItems: [CartItem] = []
    
    weak var delegate: ViewControllerDelegate?
    
    // MARK: - UI Components
    private lazy var cartCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.id)
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
    public init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setUI()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 카트뷰 새로고침
        viewModel.refreshCartItems()
    }
    
    private func setupNavigation() {
        navigationItem.title = "담은 책"
        navigationItem.leftBarButtonItem = removeAllBarButton
        navigationItem.rightBarButtonItem = addToCartBarButton
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.tintColor = .secondaryLabel
        
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
            heightDimension: .fractionalWidth(0.3)
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
        // 현재 뷰컨트롤러가 UITabBarController에 포함되어 있다면, 그 UITabBarController의 인스턴스를 가져옴
        if let tabBarController = self.tabBarController {
            // 탭바의 첫 번째 탭으로 이동
            tabBarController.selectedIndex = 0
            
            // 탭바 컨트롤러의 첫번째 UINavigationController의 루트 ViewController -> SearchViewController
            if let searchNav = tabBarController.viewControllers?[0] as? UINavigationController,
               let searchVC = searchNav.viewControllers.first as? SearchViewController {
                searchVC.activateSearchBar()
            }
        }
    }
    
    @objc private func removeAllButtonTapped() {
        if !cartItems.isEmpty {
            showDeletingAlert(title: "전체 삭제", message: "전체를 삭제하시겠습니까?", deleteAction: { [weak self] _ in
                self?.viewModel.removeAllCartItems()
            })
        }
    }
}

// MARK: - CollectionViewDelegate
extension CartViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCartItem = cartItems[cartItems.count - 1 - indexPath.row]
        print("선택된 아이템: \(selectedCartItem.title)")
        let selectedBook = viewModel.findCartItem(isbn: selectedCartItem.isbn)
        delegate?.didSelectBook(selectedBook)
    }
}

// MARK: - CollectionViewDataSource
extension CartViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CartItemCell.id,
            for: indexPath) as? CartItemCell else {
            return UICollectionViewCell()
        }
        let cartItem = cartItems[cartItems.count - 1 - indexPath.row]
        cell.configure(with: cartItem)
        // CartItemCellDelegate BookCartViewController로 설정
        cell.delegate = self
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    
    func cartItemCellDidTapPlusButton(_ cell: CartItemCell) {
        guard let indexPath = cartCollectionView.indexPath(for: cell) else { return }
        
        // ViewModel의 cartItems 스트림에서 현재 값을 가져옵니다.
        // BehaviorSubject의 현재 값에 접근해야 합니다.
        do {
            let cartItem = try viewModel.cartItems.value()[cartItems.count - 1 - indexPath.row]
            
            print("Plus tapped for item: \(cartItem.title)")

            viewModel.plusQuantity(cartItem: cartItem)
        } catch {
            print("Error accessing cart item from BehaviorSubject: \(error)")
        }
    }
    
    func cartItemCellDidTapMinusButton(_ cell: CartItemCell) {
        guard let indexPath = cartCollectionView.indexPath(for: cell) else { return }
        
        do {
            let cartItem = try viewModel.cartItems.value()[cartItems.count - 1 - indexPath.row]
            
            print("Minus tapped for item: \(cartItem.title)")

            if cartItem.quantity <= 1 { // 수량이 1이거나 그 이하면 아이템 삭제
                showDeletingAlert(title: "삭제", message: "장바구니에서 삭제하시겠습니까?", deleteAction: { [weak self] _ in
                    self?.viewModel.removeItem(cartItem: cartItem)
                })
            } else {
                viewModel.minusQuantity(cartItem: cartItem) 
            }
        } catch {
            print("Error accessing cart item from BehaviorSubject: \(error)")
        }
    }
}

extension CartViewController: BottomSheetDelegate {
    func didAddToCart() {
        showAlert()
    }
    
    func bottomSheetDidDismiss() {
        self.viewModel.refreshCartItems()
        self.cartCollectionView.reloadData()
    }
}

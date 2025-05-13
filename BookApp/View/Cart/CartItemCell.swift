//
//  CartItemCell.swift
//  BookApp
//
//  Created by 정근호 on 5/13/25.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func cartItemCellDidTapPlusButton(_ cell: CartItemCell)
    func cartItemCellDidTapMinusButton(_ cell: CartItemCell)
}

class CartItemCell: UICollectionViewCell {
    static let id = String(describing: CartItemCell.self)
    
    weak var delegate: CartItemCellDelegate?

    private var cartItem: CartItem?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var bookInfoHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private lazy var bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bookPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private lazy var quantityHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemBackground
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.label, for: .normal) // titleLabel.textColor 대신 사용
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init & SetUp
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        contentView.addSubview(containerView)
            
        containerView.addSubview(bookInfoHStack)
        containerView.addSubview(quantityHStack)

        [bookTitleLabel, bookAuthorLabel, bookPriceLabel].forEach {
            bookInfoHStack.addArrangedSubview($0)
        }
        
        [minusButton, quantityLabel, plusButton].forEach {
            quantityHStack.addArrangedSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bookInfoHStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5) // 너비를 부모 뷰 너비의 절반으로 설정
        }
        
        bookAuthorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
        
        bookPriceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
        
        quantityHStack.snp.makeConstraints {
            $0.top.equalTo(bookInfoHStack.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(containerView).multipliedBy(0.3)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        minusButton.snp.makeConstraints {
            $0.width.equalTo(30) // 버튼 너비 고정
        }
        
        plusButton.snp.makeConstraints {
            $0.width.equalTo(30) // 버튼 너비 고정
        }
    }
    
    // MARK: - Actions
    @objc func plusButtonClicked() {
        delegate?.cartItemCellDidTapPlusButton(self)
    }
    
    @objc func minusButtonClicked() {
        delegate?.cartItemCellDidTapMinusButton(self)
    }
    
    // MARK: - Internal Methods
    func configure(with cartItem: CartItem) {
        self.cartItem = cartItem
        self.bookTitleLabel.text = cartItem.title
        self.bookAuthorLabel.text = cartItem.authors.joined(separator: ", ")
        self.bookPriceLabel.text = String(cartItem.price).formatToWon()
        self.quantityLabel.text = String(cartItem.quantity)
    }
}

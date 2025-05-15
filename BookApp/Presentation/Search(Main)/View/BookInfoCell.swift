//
//  SearchResultCell.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit

final class BookInfoCell: UICollectionViewCell {
    static let id = String(describing: BookInfoCell.self)

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

        [bookTitleLabel, bookAuthorLabel, bookPriceLabel].forEach {
            bookInfoHStack.addArrangedSubview($0)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bookInfoHStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
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
    }

    // MARK: - Internal Methods
    func configure(with book: Book) {
        self.bookTitleLabel.text = book.title
        self.bookAuthorLabel.text = book.authors.joined(separator: ", ")
        self.bookPriceLabel.text = String(book.price).formatToWon()
    }
}

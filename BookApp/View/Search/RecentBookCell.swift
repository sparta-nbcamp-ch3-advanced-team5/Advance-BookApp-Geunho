//
//  RecentBookCell.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit

class RecentBookCell: UICollectionViewCell {
    static let id = String(describing: RecentBookCell.self)

    // MARK: - UI Components
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    // MARK: - Init & SetUp
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        contentView.addSubview(bookImageView)

        bookImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Internal Methods
    func configure() {

    }
}

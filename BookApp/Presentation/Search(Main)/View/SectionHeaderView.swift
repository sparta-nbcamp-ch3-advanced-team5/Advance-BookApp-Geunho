//
//  SectionHeaderView.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {

    static let id = String(describing: SectionHeaderView.self)

    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
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
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }

    // MARK: - Internal Methods
    func configure(with title: String) {
        titleLabel.text = title
    }
}

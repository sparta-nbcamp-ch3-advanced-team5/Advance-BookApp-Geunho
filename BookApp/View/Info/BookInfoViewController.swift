//
//  BookInfoViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/9/25.
//

import UIKit
import SnapKit

class BookInfoViewController: UIViewController {

    // MARK: - UI Components
    private let bookInfoContentView = UIView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "세이노의 가르침"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "세이노"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "14,000원"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "2000년부터 발표된 그의 주옥같은 글들. 독자들이 자발적으로 만든 제본서는 물론, 전자책과 앱까지 나왔던 『세이노의 가르침』이 드디어 전국 서점에서 독자들을 마주한다. 여러 판본을 모으고 저자의 확인을 거쳐 최근 생각을 추가로 수록하였다. 정식 출간본에만 추가로 수록된 글들은 목차와 본문에 별도 표시하였다. 더 많은 사람이 이 책을 보고 힘을 얻길 바라기에 인세도 안 받는 저자의 마음을 담아, 700쪽이 넘는 분량에도 7천 원 안팎에 책을 구매할 수 있도록 했다. 정식 출간 전자책 또한 무료로 선보인다.\n2000년부터 발표된 그의 주옥같은 글들. 독자들이 자발적으로 만든 제본서는 물론, 전자책과 앱까지 나왔던 『세이노의 가르침』이 드디어 전국 서점에서 독자들을 마주한다. 여러 판본을 모으고 저자의 확인을 거쳐 최근 생각을 추가로 수록하였다. 정식 출간본에만 추가로 수록된 글들은 목차와 본문에 별도 표시하였다. 더 많은 사람이 이 책을 보고 힘을 얻길 바라기에 인세도 안 받는 저자의 마음을 담아, 700쪽이 넘는 분량에도 7천 원 안팎에 책을 구매할 수 있도록 했다. 정식 출간 전자책 또한 무료로 선보인다."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("담기", for: .normal)
        button.titleLabel?.textColor = .systemBackground
        button.backgroundColor = .label
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.textColor = .systemBackground
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()

    // MARK: - Init & SetUp
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    private func setUI() {
        view.backgroundColor = .secondarySystemBackground

        [scrollView, buttonStackView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(bookInfoContentView)

        [titleLabel, authorLabel, imageView, priceLabel, descriptionLabel].forEach {
            bookInfoContentView.addSubview($0)
        }

        [closeButton, addButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-20)
        }

        bookInfoContentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.width.equalTo(bookInfoContentView.snp.width).multipliedBy(1.0 / 2.0)
            $0.height.equalTo(imageView.snp.width).multipliedBy(3.0/2.0)
            // width:height = 2:3
        }

        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(60)
        }

        // spacing 만큼의 값을 각 버튼의 multipliedBy(비율)만큼 곱하여 offset으로 뺌
        let stackViewSpacing = buttonStackView.spacing

        addButton.snp.makeConstraints { make in
            make.width.equalTo(buttonStackView.snp.width).multipliedBy(3.0/4.0)
                .offset(-stackViewSpacing * (3.0/4.0))
        }

        closeButton.snp.makeConstraints { make in
            make.width.equalTo(buttonStackView.snp.width).multipliedBy(1.0/4.0)
                .offset(-stackViewSpacing * (1.0/4.0))
        }
    }
}

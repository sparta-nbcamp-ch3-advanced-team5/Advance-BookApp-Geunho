//
//  InfoViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/9/25.
//

import UIKit
internal import SnapKit
internal import Kingfisher

public final class InfoViewController: UIViewController {
    
    private var viewModel: InfoViewModel
    public weak var bottomSheetDelegate: BottomSheetDelegate?
    
    // MARK: - UI Components
    private let bookInfoContentView = UIView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private lazy var contentsLabel: UILabel = {
        let label = UILabel()
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
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(closeSelf), for: .touchUpInside)
        return button
    }()

    // MARK: - Init & SetUp
    public init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.manageRecentBook()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 창 닫힐 시 뷰 데이터 리로드
        self.bottomSheetDelegate?.bottomSheetDidDismiss()
    }

    private func setUI() {
        view.backgroundColor = .secondarySystemBackground

        [scrollView, buttonStackView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(bookInfoContentView)

        [titleLabel, authorLabel, thumbnailView, priceLabel, contentsLabel].forEach {
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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        authorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        thumbnailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.width.equalTo(bookInfoContentView.snp.width).multipliedBy(1.0 / 2.0)
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(3.0/2.0)
            // width:height = 2:3
        }

        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(thumbnailView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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
    
    // MARK: - Actions
    @objc private func addToCart() {
        viewModel.addBookToCart()
        self.dismiss(animated: true) {
            self.bottomSheetDelegate?.didAddToCart()
        }
    }
    
    @objc private func closeSelf() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func configure() {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        priceLabel.text = viewModel.price
        contentsLabel.text = (viewModel.contents ?? "") + "..."
        guard let imageURL = viewModel.thumbnailURL else { return }
        thumbnailView.kf.setImage(with: URL(string: imageURL))
    }
}

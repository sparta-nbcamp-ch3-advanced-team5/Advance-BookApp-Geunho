//
//  BookSearchViewController.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [searchBar].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

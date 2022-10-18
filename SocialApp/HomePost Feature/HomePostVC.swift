//
//  HomePostVC.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

class HomePostVC: BaseVC {
    lazy var searchBar: SearchComponent = SearchComponent()
    let viewModel: HomePostVMProtocol
    init(viewModel: HomePostVMProtocol = HomePostVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        //self.view.addSubview(searchBar)
        setupConstraints()
    }

    private func setupConstraints() {
    }
}

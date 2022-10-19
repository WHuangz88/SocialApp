//
//  HomePostDetailVC.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import RxSwift

class HomePostDetailVC: BaseVC {

    private lazy var postContent = PostContentCard() ~!~ {
        $0.openInAppBrowser = { [unowned self] url in
            self.present(SFSafariVC(url: url), animated: true)
        }
    }
    private lazy var contentImage = UIImageView()
    private lazy var usersCollectionDS = BaseCollectionItemViewModel(
        data: self.viewModel.usersName.value) { cv, data, idx in
            let cell: TextCollectionCell = cv.dequeueReusableCell(forIndexPath: idx)
            cell.setTitle(text: data)
            return cell
        }
    private lazy var separator = LineSeparator()
    private lazy var dynamicStack = VStack {
        contentImage
        collectionView
    }

    let viewModel: HomePostDetailVM
    init(viewModel: HomePostDetailVM) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    private func setupUI() {
        setupCollection()
        createScrollView()
        contentWrapperScrollView
            .addSubviews(postContent, dynamicStack)
        dynamicStack.addSubview(separator)
        setupConstraints()
        setupEvents()
    }

    private func setupCollection() {
        collectionView.registerCells(TextCollectionCell.self)
        collectionView.dataSource = usersCollectionDS
    }

    private func setupConstraints() {
        postContent.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        contentImage.snp.makeConstraints {
            $0.height.equalTo(300)
        }

        dynamicStack.snp.makeConstraints {
            $0.top.equalTo(postContent.snp.bottom)
            $0.leading.trailing.equalTo(postContent)
            $0.bottom.lessThanOrEqualToSuperview()
                .offset(-8)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(dynamicStack.snp.bottom)
            $0.leading.trailing.equalTo(postContent)
        }
    }

    private func setupEvents() {
        self.viewModel.postDetail.asDriver()
            .drive(onNext: { [unowned self] detail in
                postContent.configure(config: .init(contentLines: 0,
                                                    ownerName: detail.name,
                                                    date: detail.date,
                                                    profilePic: detail.profilePic,
                                                    content: detail.textContent))
                contentImage.sd_setImage(with: URL(string: detail.mediaContentPath)) { [contentImage] _,_,_,_ in
                    contentImage.backgroundColor = .clear
                }
            }).disposed(by: self.disposeBag)

        self.viewModel.usersName.asDriver()
            .drive(onNext: { [weak self] users in
                self?.toggleCollectionView(!users.isEmpty)
                self?.collectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    private func toggleCollectionView(_ toggle: Bool) {
        collectionView.snp.makeConstraints {
            $0.height.equalTo(toggle ? 30 : 0)
        }
        self.separator.isHidden = !toggle
    }

}

//
//  BaseVC.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import RxSwift

class BaseVC: UIViewController, UIScrollViewDelegate {

    lazy var disposeBag = DisposeBag()

    private(set) lazy var contentWrapperScrollView: UIView = {
        let contentWrapper: UIView = UIView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.backgroundColor = .white
        return contentWrapper
    }()

    private(set) lazy var addScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsVerticalScrollIndicator = true
        scrollView.canCancelContentTouches = true
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private(set) lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout.init()
    ) ~!~ {
        if let flowLayout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 4
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }

    func createScrollView() {
        view.addSubview(addScrollView)
        addScrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets.zero)
        }

        addScrollView.addSubview(contentWrapperScrollView)
        contentWrapperScrollView.snp.makeConstraints {
            $0.edges.equalTo(addScrollView.snp.edges).inset(UIEdgeInsets.zero)
            $0.height.equalTo(addScrollView.snp.height).priority(.low)
            $0.width.equalTo(addScrollView.snp.width)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
}

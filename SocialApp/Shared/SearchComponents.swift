//
//  SearchComponents.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

class SearchComponent: UIView {
    private lazy var container = UIView()
    private lazy var searchBtn = UIButton() ~!~ {
        $0.backgroundColor = .purple
        $0.setTitle("SEARCH", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        $0.layer.cornerRadius = 6
        $0.contentEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        $0.addTarget(self, action: #selector(didSearch), for: .touchUpInside)
    }
    private lazy var textField = UITextField() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.attributedPlaceholder = NSAttributedString(
            string: "Write sth...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        $0.borderStyle = .none
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowRadius = 0.0
    }

    var searchResult: ((String) -> Void)?

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    private func setupUI() {
        addSubviews(container)
        container.addSubviews(textField, searchBtn)
        textField.snp.makeConstraints {
            $0.centerY.equalTo(searchBtn)
            $0.leading.equalToSuperview()
        }
        searchBtn.snp.makeConstraints {
            $0.bottom.top.equalToSuperview()
            $0.leading.equalTo(textField.snp.trailing)
                .offset(8)
            $0.trailing.equalToSuperview()
        }

        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
                .inset(16)
            $0.leading.trailing.equalToSuperview()
                .inset(8)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didSearch() {
        if let searchResult = searchResult, let result = self.textField.text {
            searchResult(result)
        }
    }

}

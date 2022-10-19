//
//  TextCollectionCell.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit

class TextCollectionCell: UICollectionViewCell {

    lazy var titleLbl: UILabel = UILabel() ~!~ {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.sizeToFit()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.contentView.addSubview(titleLbl)
    }

    private func setupConstraint() {
        titleLbl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setTitle(text: String?,
                         font: UIFont = .systemFont(ofSize: 12)) {
        self.titleLbl.text = text
        self.titleLbl.font = font
    }
}

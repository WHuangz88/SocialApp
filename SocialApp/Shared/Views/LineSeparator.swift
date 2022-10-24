//
//  LineSeparator.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import SnapKit

class LineSeparator: UIView {
    init(frame: CGRect = .zero, forHeight: Int = 2, forColor: UIColor = .gray) {
        super.init(frame: frame)
        setupUI(height: forHeight, color: forColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(height: Int, color: UIColor) {
        backgroundColor = color
        snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }

    func attachView(_ view: UIView) {
        view.addSubview(self)
    }

    func makeBottomConstraintWithPadding(horizontalMargin: Int = 0) {
        snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalMargin).priority(.high)
            $0.trailing.equalToSuperview().offset(-horizontalMargin).priority(.high)
            $0.bottom.equalToSuperview().priority(.high)
        }
    }

    func makeTopConstraintWithPadding(horizontalMargin: Int = 0) {
        snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalMargin).priority(.high)
            $0.trailing.equalToSuperview().offset(-horizontalMargin).priority(.high)
            $0.top.equalToSuperview().priority(.high)
        }
    }

}

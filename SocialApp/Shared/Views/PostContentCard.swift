//
//  PostContentCard.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import SnapKit
import UIKit
import SDWebImage

struct PostHeaderConfig {
    let contentLines: Int
    let ownerName: String
    let date: String
    let profilePic: String
    let content: String
}

class PostContentCard: UIView {
    private lazy var iconView = UIImageView() ~!~ {
        $0.backgroundColor = .red
        $0.snp.makeConstraints {
            $0.size.equalTo(32)
        }
    }
    private lazy var ownerLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private lazy var dateLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.gray
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private lazy var contentLbl = UILabel() ~!~ {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }

    private lazy var stackView = VStack {
        HStack {
            iconView
            VStack {
                ownerLbl
                dateLbl
            }
            .setSpacing(2)
            .setDistribution(.fill)
        }
        .setSpacing(4)
        .setAlignment(.center)
        .setDistribution(.fill)
        contentLbl
    }
    .setSpacing(8)
    .setDistribution(.fill)

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
                .inset(8)
        }
    }

    func configure(config: PostHeaderConfig) {
        self.ownerLbl.text = config.ownerName
        self.dateLbl.text = config.date.convertDate(toFormat: .normal)
        self.contentLbl.text = config.content
        self.contentLbl.numberOfLines = config.contentLines
        self.iconView.sd_setImage(with: URL(string: config.profilePic)) { [iconView] _,_,_,_ in
            iconView.backgroundColor = .clear
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

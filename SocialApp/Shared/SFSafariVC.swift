//
//  SFSafariVC.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit
import SafariServices
import WebKit

/// Reuse SafariViewController
class SFSafariVC: SFSafariViewController {

    override init(url: URL,
         configuration: SFSafariViewController.Configuration = .init()) {
        super.init(url: url, configuration: configuration)
    }
}

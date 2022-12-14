//
//  HomePostVC.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import RxSwift

class HomePostVC: BaseVC {
    lazy var searchBar: SearchComponent = SearchComponent() ~!~ {
        $0.searchResult = { [unowned self] result in
            self.viewModel.filter(result)
        }
    }

    private lazy var refreshControl = UIRefreshControl() ~!~ {
        $0.tintColor = .black
    }

    private lazy var tableView = UITableView(frame: .zero, style: .grouped) ~!~ {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.refreshControl = refreshControl
        $0.registerCells(PostCell.self)
    }

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
        self.viewModel.initialLoad()
    }

    private func setupUI() {
        view.addSubviews(searchBar, tableView)
        setupConstraints()
        setupEvents()
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing
                .equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom
                .equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupEvents() {
        self.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe({ [weak self] _ in
                self?.viewModel.reload()
            })
            .disposed(by: disposeBag)

        self.viewModel.viewState.subscribe(onNext: { [weak self] state in
            guard state != .none else { return }
            self?.refreshControl.endRefreshing()
            switch state {
            case.errorMessage(let msg):
                // TODO: Handle Toast Message
                print(msg ?? "")
            default:
                break
            }
        }).disposed(by: self.disposeBag)

        let section = self.viewModel.postCellVMs.asObservable().map { (data) -> TableSectionViewModelProtocol in
            return TableSectionViewModel(entries: data) { [weak self] (_, vm, cell: PostCell) in
                cell.bindData(vm: vm)
                cell.openInAppBrowser = { [weak self] url in
                    self?.present(SFSafariVC(url: url), animated: true)
                }
            } onSelect: { [weak self] _, data in
                guard let self = self else { return }
                let vc = HomePostDetailVC(viewModel: .init(postDetail: data, users: self.viewModel.users))
                self.navigationController?.pushViewController(vc, animated: true)
            }.asProtocol
        }

        tableView.rx.items(section: section)
            .disposed(by: disposeBag)

        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] in
                self?.viewModel.canLoadMore(index: $0.indexPath.row)
            })
            .disposed(by: self.disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension HomePostVC: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}

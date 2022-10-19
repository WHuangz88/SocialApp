//
//  BaseCollectionViewModel.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

/// CollectionView DS Wrappers
class BaseCollectionItemViewModel<Data>: NSObject,
                                         UICollectionViewDelegate,
                                         UICollectionViewDataSource {

    typealias CellConfigurator = (UICollectionView,
                                  Data,
                                  IndexPath) -> UICollectionViewCell
    typealias SupplementaryConfigurator = (UICollectionView,
                                           IndexPath) -> UICollectionReusableView
    typealias DidSelectConfigurator = (IndexPath,
                                       Data?) -> Void

    private let supplementaryConfigurator: SupplementaryConfigurator?
    private let cellConfigurator: CellConfigurator
    private var data: [Data] = []
    private let onSelect: DidSelectConfigurator?

    init(data: [Data],
         cellConfigurator: @escaping CellConfigurator,
         supplementaryConfigurator: SupplementaryConfigurator? = nil,
         onSelect: DidSelectConfigurator? = nil) {
        self.data = data
        self.cellConfigurator = cellConfigurator
        self.supplementaryConfigurator = supplementaryConfigurator
        self.onSelect = onSelect
    }

    /// Update data when have changes in the original data, and make sure to reload the collectionview 
    func updateData(_ data: [Data]) {
        self.data = data
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < data.count
        else { return UICollectionViewCell() }
        let model = data[indexPath.row]
        return cellConfigurator(collectionView, model, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < data.count {
            let data = data[indexPath.row]
            self.onSelect?(indexPath, data)
        } else {
            self.onSelect?(indexPath, nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return supplementaryConfigurator?(collectionView, indexPath)
        ?? UICollectionReusableView(frame: .zero)
    }
}


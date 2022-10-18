//
//  TableSectionViewModel.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// wraps content of a signle table section
public protocol TableSectionViewModelProtocol: AnyObject {
    func configureCell(indexPath: IndexPath, value: Any, tableView: UITableView) -> UITableViewCell
    func onSelect(index: Int)
    var items: [Any] { get }
}

/// implements above protocol for specific object and cell classes
public class TableSectionViewModel<ObjectClass, CellClass: UITableViewCell>: TableSectionViewModelProtocol {
    private var configureCell: ((_ index: Int, _ value: ObjectClass, _ cell: CellClass) -> Void)
    private var onSelect: ((_ index: Int, _ value: ObjectClass) -> Void)?
    private var entries: [ObjectClass]

    public init(entries: [ObjectClass],
                configureCell: @escaping ((_ index: Int, _ value: ObjectClass, _ cell: CellClass) -> Void),
                onSelect: ((_ index: Int, _ value: ObjectClass) -> Void)? = nil) {
        self.entries = entries
        self.configureCell = configureCell
        self.onSelect = onSelect
    }

    public func configureCell(indexPath: IndexPath, value: Any, tableView: UITableView) -> UITableViewCell {
        let cell: CellClass = tableView.dequeueReusableCell(forIndexPath: indexPath)
        guard let valueObject = value as? ObjectClass else { return cell }
        configureCell(indexPath.row, valueObject, cell)
        return cell
    }

    public func onSelect(index: Int) {
        guard entries.count > index else { return }
        onSelect?(index, entries[index])
    }

    public var items: [Any] {
        entries
    }

    /// shortcut for abstraction
    public var asProtocol: TableSectionViewModelProtocol {
        self as TableSectionViewModelProtocol
    }

}
public extension TableSectionViewModel where ObjectClass == Int {
    /// shortcut to generate a section with a static amount of cells and ignore the data type
    /// - Parameters:
    ///   - cellCount: cell count
    ///   - configureCell: cell configuration
    /// - Returns: section converted to procol for convenience
    static func cells(cellCount: Int = 1,
                      configureCell: @escaping ((_ cell: CellClass) -> Void)) -> TableSectionViewModelProtocol {
        TableSectionViewModel(entries: Array(0..<cellCount), configureCell: { _, _, cell in
            configureCell(cell)
        }).asProtocol
    }

    static func empty() -> TableSectionViewModelProtocol {
        return TableSectionViewModel.cells(cellCount: 0, configureCell: {_ in })
    }
}

/// section model without data type supporting different types of cells
public class TableSectionCellViewModel: TableSectionViewModelProtocol {
    private let configureCell: [(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell]
    private let onSelect: [(() -> Void)?]?

    public init(configureCell: [(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell],
                onSelect: [(() -> Void)?]? = nil) {
        self.configureCell = configureCell
        self.onSelect = onSelect
    }

    public func configureCell(indexPath: IndexPath,
                              value: Any,
                              tableView: UITableView) -> UITableViewCell {
        guard configureCell.count > indexPath.row else { return UITableViewCell() }
        return configureCell[indexPath.row](tableView, indexPath)
    }

    public func onSelect(index: Int) {
        guard (onSelect?.count ?? 0) > index else { return }
        onSelect?[index]?()
    }

    public lazy var items: [Any] = Array(0..<configureCell.count)

    /// shortcut for abstraction
    public var asProtocol: TableSectionViewModelProtocol {
        self as TableSectionViewModelProtocol
    }
}

public extension Reactive where Base: UITableView {
    typealias RxDT = RxTableViewSectionedReloadDataSource
    func items<Source: ObservableType>(sections: Source, canEditRow: Bool = false)
    -> Disposable
    where Source.Element == [TableSectionViewModelProtocol] {
        let relay = BehaviorRelay<Source.Element>(value: [])

        let d1 = sections.bind(to: relay)

        let dataSource: RxDT<SectionModel<Int, Any>> = RxDT(configureCell: { _, tableView, indexPath, item in
            relay.value[indexPath.section].configureCell(indexPath: indexPath, value: item, tableView: tableView)
        })

        // Enable swipe cell
        dataSource.canEditRowAtIndexPath = { (dataSource, index) -> Bool in
            return canEditRow
        }

        let d2 = relay
            .map { $0.enumerated().map { SectionModel(model: $0.offset, items: $0.element.items) } }
            .bind(to: self.items(dataSource: dataSource))

        let d3 = self.itemSelected
            .subscribe(onNext: { indexPath in
                guard relay.value.count > indexPath.section else { return }
                relay.value[indexPath.section].onSelect(index: indexPath.row)
            })

        return CompositeDisposable(d1, d2, d3)
    }

    func items<Source: ObservableType>(section: Source) -> Disposable
    where Source.Element == TableSectionViewModelProtocol {
        return items(sections: section.map { [$0] })
    }

}

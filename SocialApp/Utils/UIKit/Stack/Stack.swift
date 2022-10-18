//
//  VStack.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

@resultBuilder
public struct StackBuilder {
    public static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }
}

public protocol StackModifier {
    associatedtype Stack: UIStackView
    func setAlignment(_ alignment: UIStackView.Alignment) -> Stack
    func setDistribution(_ distribution: UIStackView.Distribution) -> Stack
    func setSpacing(_ spacing: CGFloat) -> Stack
}

public final class VStack: UIStackView {

    public init(@StackBuilder views: () -> [UIView]) {
        super.init(frame: .zero)
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false
        views().forEach { addArrangedSubview($0) }

    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension VStack: StackModifier {
    public func setAlignment(_ alignment: UIStackView.Alignment) -> VStack {
        self.alignment = alignment
        return self
    }

    public func setDistribution(_ distribution: UIStackView.Distribution) -> VStack {
        self.distribution = distribution
        return self
    }

    public func setSpacing(_ spacing: CGFloat) -> VStack {
        self.spacing = spacing
        return self
    }
}


public final class HStack: UIStackView {

    public init(@StackBuilder views: () -> [UIView]) {
        super.init(frame: .zero)
        axis = .horizontal
        translatesAutoresizingMaskIntoConstraints = false
        views().forEach { addArrangedSubview($0) }

    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HStack: StackModifier {
    public func setAlignment(_ alignment: UIStackView.Alignment) -> HStack {
        self.alignment = alignment
        return self
    }

    public func setDistribution(_ distribution: UIStackView.Distribution) -> HStack {
        self.distribution = distribution
        return self
    }

    public func setSpacing(_ spacing: CGFloat) -> HStack {
        self.spacing = spacing
        return self
    }
}

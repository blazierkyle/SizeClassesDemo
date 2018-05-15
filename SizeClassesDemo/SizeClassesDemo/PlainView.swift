//
//  PlainView.swift
//  SizeClassesDemo
//
//  Created by Kyle Blazier on 5/14/18.
//  Copyright © 2018 WillowTree, Inc. All rights reserved.
//

import UIKit

final class PlainView: UIView, Nibbable {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateBackgroundColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Add an little delay so we can prove we hit unspecified first 💥
        UIView.animate(withDuration: 2.0) {
            self.updateBackgroundColor()
        }
    }
    
    private func updateBackgroundColor() {
        // If we weren't given a trait collection, use the viewController's
        switch traitCollection.horizontalSizeClass {
        case .regular:
            backgroundColor = UIColor.blue
        case .compact:
            backgroundColor = UIColor.magenta
        case .unspecified:
            backgroundColor = UIColor.red
        }
        
        print("PlainView's trait collection is: \(traitCollection.horizontalSizeClassString)")
    }
}

// MARK: - Make working with xib's easier 💰
protocol Nibbable {
    static var nib: UINib { get }
    static var fromNib: Self? { get }
}

extension Nibbable where Self: UIView {
    static var nib: UINib {
        return UINib(
            nibName: String("\(type(of: self as Any))".split(separator: ".")[0]),
            bundle: nil
        )
    }
    
    static var fromNib: Self? {
        return nib.instantiate(withOwner: nil, options: nil).first as? Self
    }
}

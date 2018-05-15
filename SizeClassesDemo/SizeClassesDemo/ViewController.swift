//
//  ViewController.swift
//  SizeClassesDemo
//
//  Created by Kyle Blazier on 5/14/18.
//  Copyright © 2018 WillowTree, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // original update background color
        updateBackgroundColor(for: nil)
        
        // Add another view to the stack view to make things interesting
        addPlainView()
        
        // Correct the stackView's axis based on the original trait collection
        updateStackViewAxis(with: nil)
    }
    
    private func addPlainView() {
        let plainView = PlainView.fromNib! // force unwrap okay here because programmer error if this fails
        stackView.addArrangedSubview(plainView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        print("traitCollectionDidChange - new traitCollection = \(traitCollection.horizontalSizeClassString)")
        
        updateBackgroundColor(for: nil)
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        print("willTransitionToTraitCollection - new horizontal size class = \(newCollection.horizontalSizeClassString)")

        coordinator.animate(alongsideTransition: { (_) in
            // Compact use gray background, regular use green
            self.updateBackgroundColor(for: newCollection)
        })
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        print("willTransitionToSize: new size: \(size)")
        
        // Adjust the stackview's axis while we transition to the new size
        coordinator.animate(alongsideTransition: { (_) in
            self.updateStackViewAxis(with: size)
        })
    }
    
    private func updateStackViewAxis(with viewSize: CGSize?) {
        // If we weren't given a size, use the view's current size
        let size = viewSize ?? view.frame.size
        
        // Stack items horizontally when we are in landscape (and regular width)
        //  to utilize all screen space
        if case .regular = traitCollection.horizontalSizeClass {
            stackView.axis = size.width > size.height ? .horizontal : .vertical
        } else {
            // Compact width - always use vertical axis
            stackView.axis = .vertical
        }
    }
    
    private func updateBackgroundColor(for traitCollection: UITraitCollection?) {
        // If we weren't given a trait collection, use the viewController's
        let trait = traitCollection ?? self.traitCollection
        
        // Compact use gray background, regular use green
        switch trait.horizontalSizeClass {
        case .regular:
            view.backgroundColor = UIColor.green
        case .compact:
            view.backgroundColor = UIColor.gray
        case .unspecified:
            view.backgroundColor = UIColor.red
        }
    }
}

extension UITraitCollection {
    var horizontalSizeClassString: String {
        switch horizontalSizeClass {
        case .regular:
            return "Regular"
        case .compact:
            return "Compact"
        case .unspecified:
            return "Unspecified"
        }
    }
}

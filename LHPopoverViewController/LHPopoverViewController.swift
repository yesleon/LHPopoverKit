//
//  LHPopoverViewController.swift
//  LHPopoverViewController
//
//  Created by 許立衡 on 2018/10/30.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit
import LHConvenientMethods

public class LHPopoverViewController: UIViewController {
    
    let containedView: UIView
    
    public override func loadView() {
        view = containedView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = containedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if preferredContentSize != containedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) {
            preferredContentSize = containedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
    }

    public init(containedView: UIView, popoverSource: LHPopoverSource) {
        self.containedView = containedView
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        if let popoverController = popoverPresentationController {
            popoverController.delegate = self
            popoverController.setPopoverSource(popoverSource)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LHPopoverViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

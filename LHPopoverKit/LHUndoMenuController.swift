//
//  LHUndoMenuController.swift
//  LHUndoMenuController
//
//  Created by 許立衡 on 2018/10/27.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

open class LHUndoMenuController: LHMenuController {
    
    private let managedUndoManager: UndoManager
    
    public convenience init(undoManager: UndoManager, barButtonItem: UIBarButtonItem) {
        self.init(undoManager: undoManager)
        if let popoverController = popoverPresentationController {
            popoverController.barButtonItem = barButtonItem
        }
    }
    
    public convenience init(undoManager: UndoManager, sourceView: UIView, sourceRect: CGRect? = nil) {
        self.init(undoManager: undoManager)
        if let popoverController = popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceRect ?? sourceView.bounds
        }
    }
    
    private init(undoManager: UndoManager) {
        self.managedUndoManager = undoManager
        super.init()
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LHUndoMenuController: LHMenuControllerDelegate {
    
    public func numberOfItems(for menuController: LHMenuController) -> Int {
        return 2
    }
    
    public func menuController(_ menuController: LHMenuController, titleForItemAtIndex index: Int) -> String? {
        switch index {
        case 0:
            return managedUndoManager.undoMenuItemTitle
        case 1:
            return managedUndoManager.redoMenuItemTitle
        default:
            fatalError()
        }
    }
    
    public func menuController(_ menuController: LHMenuController, shouldEnableItemAtIndex index: Int) -> Bool {
        switch index {
        case 0:
            return managedUndoManager.canUndo
        case 1:
            return managedUndoManager.canRedo
        default:
            fatalError()
        }
    }
    
    public func menuController(_ menuController: LHMenuController, didSelectItemAtIndex index: Int) {
        switch index {
        case 0:
            managedUndoManager.undo()
        case 1:
            managedUndoManager.redo()
        default:
            fatalError()
        }
    }
    
}

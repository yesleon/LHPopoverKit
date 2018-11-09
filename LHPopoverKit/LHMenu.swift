//
//  LHMenu.swift
//  LHPopoverKit
//
//  Created by 許立衡 on 2018/10/31.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

@IBDesignable
open class LHMenu: UIScrollView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bounces = false
        tableView.delaysContentTouches = false
        tableView.separatorInset = .zero
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    public struct Action {
        
        public typealias Handler = (Action) -> Action?
        
        fileprivate var title: String
        fileprivate var isEnabled: Bool
        fileprivate var handler: Handler
        public init(title: String, isEnabled: Bool, handler: @escaping Handler) {
            self.title = title
            self.isEnabled = isEnabled
            self.handler = handler
        }
    }
    
    open var actions: [Action] = [
        Action(title: "asdf", isEnabled: true, handler: { action in return nil }),
        Action(title: "aaaa", isEnabled: true, handler: { action in return nil }),
        Action(title: "bbbb", isEnabled: true, handler: { action in return nil }),
        Action(title: "cccc", isEnabled: true, handler: { action in return nil }),
        ] {
        didSet {
            tableView.reloadData()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if intrinsicContentSize != tableView.contentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    public convenience init(undoManager: UndoManager) {
        self.init()
        addConstraint(.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240))
        weak var weakSelf = self
        func updateActions(undoManager: UndoManager) {
            weakSelf?.actions = [
                .init(title: undoManager.undoMenuItemTitle, isEnabled: undoManager.canUndo, handler: { action in
                    undoManager.undo()
                    updateActions(undoManager: undoManager)
                    return nil
                }),
                .init(title: undoManager.redoMenuItemTitle, isEnabled: undoManager.canRedo, handler: { action in
                    undoManager.redo()
                    updateActions(undoManager: undoManager)
                    return nil
                }),
            ]
        }
        updateActions(undoManager: undoManager)
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = true
        delaysContentTouches = false
        addSubview(tableView)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    open override var intrinsicContentSize: CGSize {
        return tableView.contentSize
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        tableView.reloadData()
    }

}

extension LHMenu: UITableViewDataSource, UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let action = actions[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        cell.textLabel?.text = action.title
        cell.textLabel?.textColor = action.isEnabled ? tintColor : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return actions[indexPath.row].isEnabled
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if actions[indexPath.row].isEnabled {
            return indexPath
        } else {
            return nil
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = actions[indexPath.row].handler(actions[indexPath.row]) {
            actions[indexPath.row] = action
        }
    }
    
}

extension UIViewController {
    
    open func presentUndoMenu(undoManager: UndoManager, popoverSource: LHPopoverSource) {
        let popoverVC = LHPopoverViewController(popoverSource: popoverSource)
        popoverVC.addManagedView(LHMenu(undoManager: undoManager))
        present(popoverVC, animated: true, completion: nil)
    }
    
}

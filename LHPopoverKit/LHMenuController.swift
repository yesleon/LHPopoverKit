//
//  LHMenuController.swift
//  LHUndoMenuController
//
//  Created by 許立衡 on 2018/10/27.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

public protocol LHMenuControllerDelegate: AnyObject {
    func numberOfItems(for menuController: LHMenuController) -> Int
    func menuController(_ menuController: LHMenuController, titleForItemAtIndex index: Int) -> String?
    func menuController(_ menuController: LHMenuController, shouldEnableItemAtIndex index: Int) -> Bool
    func menuController(_ menuController: LHMenuController, didSelectItemAtIndex index: Int)
}

open class LHMenuController: UITableViewController {
    
    open weak var delegate: LHMenuControllerDelegate?
    
    public init() {
        super.init(style: .plain)
        
        modalPresentationStyle = .popover
        if let popoverController = popoverPresentationController {
            popoverController.delegate = self
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateContentSize() {
        if let itemCount = delegate?.numberOfItems(for: self) {
            preferredContentSize.height = CGFloat((44 + 1) * itemCount)
            preferredContentSize.width = 240
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        updateContentSize()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bounces = false
        tableView.delaysContentTouches = false
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfItems(for: self) ?? 0
    }
    
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.textAlignment = .center
        
        cell.textLabel?.text = delegate?.menuController(self, titleForItemAtIndex: indexPath.row)
        cell.textLabel?.textColor = delegate?.menuController(self, shouldEnableItemAtIndex: indexPath.row) ?? true ? .black : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return delegate?.menuController(self, shouldEnableItemAtIndex: indexPath.row) ?? true
    }
    
    open override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if delegate?.menuController(self, shouldEnableItemAtIndex: indexPath.row) != false {
            return indexPath
        } else {
            return nil
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuController(self, didSelectItemAtIndex: indexPath.row)
        tableView.reloadData()
        updateContentSize()
    }
    
}

extension LHMenuController: UIPopoverPresentationControllerDelegate {
    
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

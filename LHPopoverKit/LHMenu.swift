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
        cell.textLabel?.textColor = action.isEnabled ? tintColor : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
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

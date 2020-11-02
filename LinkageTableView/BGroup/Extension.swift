//
//  Extension.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/28.
//  Copyright © 2020 刘凯. All rights reserved.
//

import Foundation
import UIKit

extension SubTableViewController {
    
}

protocol SubTableViewControllerDelegate : NSObjectProtocol {
    func subScrollView(controller : BaseViewController,isMainTop : Bool,isSubTop : Bool)
}

protocol MainTableViewControllerDelegate : NSObjectProtocol {
    func mainScrollView(controller : UIViewController,isMainTop : Bool,isSubTop : Bool)
}

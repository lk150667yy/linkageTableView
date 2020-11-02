//
//  HomeBaseViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/25.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class HomeBaseViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

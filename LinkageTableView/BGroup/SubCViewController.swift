//
//  SubCViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/11/2.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class SubCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("my is subC!")
    }
}

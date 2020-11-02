//
//  AViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/24.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class AViewController: UIViewController {

    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview().offset(0)
        }
        
    }

}
extension AViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension AViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("subScrollView -- \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y > 0  {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "aaaa"),
                object:["aaa":"\(scrollView.contentOffset.y)"])
        }
    }
}

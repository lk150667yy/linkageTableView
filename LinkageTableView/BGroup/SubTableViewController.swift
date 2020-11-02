//
//  SubTableViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/28.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit
import MJRefresh

class SubTableViewController: BaseViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(subTableView)
        subTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            sleep(2)
            self.subTableView.mj_header?.endRefreshing()
        })
        self.subTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview().offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("我将要进入SubTableViewController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text = "第一个页面,我是红色的字体，哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textColor = UIColor.red
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ceshi = CeshiViewController()
        bgroupVC.show(ceshi, sender: self)
    }
    
}

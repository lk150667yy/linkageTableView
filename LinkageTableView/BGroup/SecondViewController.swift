//
//  SecondViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/28.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class SecondViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(subTableView)
        subTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview().offset(0)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("我将要进入SecondViewController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
        }
        cell?.textLabel?.text = "Second--\(indexPath.row)"
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ceshi = AddSubViewController()
        bgroupVC.show(ceshi, sender: self)
    }
    
}

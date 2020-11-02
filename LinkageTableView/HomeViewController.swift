//
//  HomeViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/25.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        return tableView
    }()
    
    var groupArray : [String] = ["AGroup","BGroup"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview().offset(0)
        }
    }

}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
        }
        cell?.textLabel?.text = groupArray[indexPath.row]
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ViewController()
            vc.title = groupArray[indexPath.row]
            show(vc, sender: self)
        case 1:
            let bGroupVC = BGroupViewController()
            bGroupVC.title = groupArray[indexPath.row]
            self.show(bGroupVC, sender: self)
        default:
            break
        }
    }
}

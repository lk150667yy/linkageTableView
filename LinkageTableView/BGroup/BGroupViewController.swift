//
//  BGroupViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/28.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

/// 主tableView发送的通知，通知子tableView，主tableView离开最顶部，子tableView到达最顶部
let kNotification_MainToSubLocation : String = "MainToSubLocation"
/// 子tableView发送的通知，通知主TableView，子tableView离开最顶部
let kNotification_SubToMainLocation : String = "SubToMainLocation"
/// 子ScrollView滚动时的通知，通知主tableView，子tableView的位置
let kNotification_SubScrollViewScroll_Main : String = "SubScrollViewScrollMain"
let kNotification_SubScrollViewScroll_Sub : String = "SubScrollViewScrollSub"

let isFull : Bool = true

let headerView : CGFloat = 200


let kMaxOffset : CGFloat = isFull ? (200 - 88) : (200 - 64)


class BGroupViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, SubTableViewControllerDelegate {
    func subScrollView(controller: BaseViewController, isMainTop: Bool, isSubTop: Bool) {
        self.isMainTop = isMainTop
        self.isSubTop = isSubTop
    }
    
    var scrollViewLocation : Int = 0
    
    var isMainTop : Bool = true
    var isSubTop : Bool = false
    
    
    
    var delegate : MainTableViewControllerDelegate?
    
    
    lazy var mainTableView: HomeBaseTableView = {
        var mainTableView = HomeBaseTableView(frame: CGRect.zero, style: .plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.bounces = false
        return mainTableView
    }()
    
    var subTableVC : SubTableViewController = SubTableViewController()
    var secondVC : SecondViewController = SecondViewController()
    
    var vcArray : [UIViewController] = []
    var subScrollView : UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subTableVC.bgroupVC = self
        secondVC.bgroupVC = self
        vcArray.append(subTableVC)
        vcArray.append(secondVC)
        
        NotificationCenter.default.addObserver(self, selector: #selector(subToMainNotification), name: NSNotification.Name(rawValue: kNotification_SubToMainLocation), object: nil)
        
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview().offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func subToMainNotification(notification : Notification) {
        let userInfo = notification.userInfo
        self.isMainTop = userInfo!["isMainTop"] != nil
        self.isSubTop = userInfo!["isSubTop"] != nil
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
            }
            cell?.backgroundColor = UIColor.red
            return cell!
        } else {
            let cell = SubControllerTableViewCell.tableViewCell(tableView: tableView)
            subScrollView = cell.setupContent(vcArray: vcArray)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        if isFull {
            return kScrenH - (200 - 88)
        } else {
            return kScrenH - 64
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("mainTableView -- \(scrollView.contentOffset.y)")
        // 当主tableView在顶部时，滑动tableView，子tableView位置不变，主tableView向上移动，直到子tableView到达最顶部
        // 当子tableView到达最顶部时，固定主tableView，向上随意移动子tableView,但是当向下移动子tableView时，
        // 如果offset.y <= 0，那么固定子tableView，向下移动主tableView，直到主tableView在最顶部
        // 当处于中间位置时也就是说，子tableView在最顶部，主tableView，不在最顶部，这个时候向上移动或向下移动都要固定
        // 子tableView
        if isMainTop {
            // 当前offset 大于等于 kMaxOffset 时，说明子tableView到达最顶部，告诉子tableView，可以移动子tableView
            if scrollView.contentOffset.y >= kMaxOffset {
                print("主tableView移动了最大偏移量")
                self.isMainTop = false
                self.isSubTop = true
                mainTableView.contentOffset = CGPoint(x: 0, y: kMaxOffset)
                // 发送通知，主tableView离开最顶部,子tableView到达顶部
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotification_MainToSubLocation), object: self,userInfo: ["isSubTop":true,"isMainTop":false])
            } else {
                // 子tableView固定zero位置
                if scrollView.contentOffset.y <= (isFull ? -44 : -20) {
                    print("主tableView到顶部了")
                    self.isMainTop = true
                    self.isSubTop = false
                    // 发送通知，主tableView离开最顶部,子tableView到达顶部
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotification_MainToSubLocation), object: self,userInfo: ["isSubTop":false,"isMainTop":true])
                } else if scrollView.contentOffset.y > -44 && scrollView.contentOffset.y < kMaxOffset {
                    
                }
            }
        } else {
            if isSubTop {
                mainTableView.contentOffset = CGPoint(x: 0, y: kMaxOffset)
            }
        }
    }
    
}


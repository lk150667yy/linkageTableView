//
//  BaseViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/29.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var bgroupVC : BGroupViewController!
    
    func controllerChange(view: SubControllerTableViewCell, subTableView tableView: UITableView, isMainTop: Bool, isSubTop: Bool) {
        self.subTableView = tableView as! HomeBaseTableView
        self.isMainTop = isMainTop
        self.isSubTop = isSubTop
    }
    
    var subScrollViewLocation : Int = 0
    
    var isMainTop : Bool = true
    var isSubTop : Bool = false
    var isVertical : Bool = true
    
    
    
    var subScrollV : UIScrollView!
    
    lazy var subTableView: HomeBaseTableView = {
        var subTableView = HomeBaseTableView(frame: CGRect.zero, style: .plain)
        subTableView.delegate = self
        subTableView.dataSource = self
        return subTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(mainToSubNotifiaction), name: NSNotification.Name(rawValue: kNotification_MainToSubLocation), object: nil)
        
    }
    
    @objc func mainToSubNotifiaction(notification : Notification) {
        let userInfo = notification.userInfo
        self.isMainTop = userInfo!["isMainTop"] as! Bool
        self.isSubTop = userInfo!["isSubTop"] as! Bool
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BaseID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "BaseID")
        }
        return cell!
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("subScrollView -- \(scrollView.contentOffset.y)")
        // 当主tableView在顶部时，滑动tableView，如果offset.y >= 0则
        // 子tableView位置不变，主tableView向上移动，直到子tableView到达最顶部
        // 当子tableView到达最顶部时，固定主tableView，向上随意移动子tableView,但是当向下移动子tableView时，
        // 如果offset.y <= 0，那么固定子tableView，向下移动主tableView，直到主tableView在最顶部
        // 当处于中间位置时也就是说，子tableView在最顶部，主tableView，不在最顶部，这个时候向上移动或向下移动都要固定
        // 子tableView
        
        if isMainTop {
            // 当主tableView在最顶部时，子tableView固定，主向上移动至顶部
            if scrollView.contentOffset.y >= 0 {
                subTableView.contentOffset = CGPoint.zero
            }
        } else if isSubTop {
            // 当子tableView在顶部时，offset.y <= 0，并且主tableView不在顶部，固定子tableView，
            // 并发送通知子tableView离开了顶部
            if scrollView.contentOffset.y <= 0 && !isMainTop {
                subTableView.contentOffset = CGPoint.zero
                self.isMainTop = false
                self.isSubTop = false
                // 发送通知，通知主tableView，子tableView离开了顶部
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotification_SubToMainLocation), object: self,userInfo: ["isMainTop":true,"isSubTop":false])
            }
        } else {
            subTableView.contentOffset = CGPoint.zero
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        subScrollV.isScrollEnabled = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        subScrollV.isScrollEnabled = true
        subTableView.isScrollEnabled = true
        print("结束拖动")
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        subScrollV.isScrollEnabled = true
        subTableView.isScrollEnabled = true
        print("减速结束")
        
    }
    
}

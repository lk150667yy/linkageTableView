//
//  SubControllerTableViewCell.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/28.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

fileprivate let cellID : String = "SubControllerTableViewCellID"

protocol SubControllerTableViewCellDelegate {
    
    /// 改变显示的子控制器时进行转移上一个控制器的位置状态
    /// - Parameters:
    ///   - view: tableViewCell
    ///   - tableView: tableView
    ///   - isMainTop: 是否主控制器在上面
    ///   - isSubTop: 是否子控制器在上面
    func controllerChange(view : SubControllerTableViewCell,subTableView tableView : UITableView,isMainTop : Bool,isSubTop : Bool)
}


class SubControllerTableViewCell: UITableViewCell,UIScrollViewDelegate {
    
    
    var delegate : SubControllerTableViewCellDelegate!
    
    lazy var subScrollView: UIScrollView = {
        var subScrollView = UIScrollView()
        subScrollView.bounces = false
        subScrollView.isPagingEnabled = true
        subScrollView.delegate = self
        return subScrollView
    }()
    
    lazy var tabbarView: UIView = {
        var tabbarView = UIView()
        tabbarView.backgroundColor = UIColor.blue
        return tabbarView
    }()
    
    var subControllerScrollView : UIScrollView!
    
    var currentController : BaseViewController!
    
    var toolsView = SelectedBarToolsView()
    
    
    
    var vcArray : [UIViewController] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(tabbarView)
        self.tabbarView.addSubview(toolsView)
        toolsView.tabbarDelegate = self
        toolsView.titles = ["我的比赛","我的赛鸽","我的鸽舍","我的组织","我的设备","我的商城","我的账户","我的我的"]
        toolsView.config()
        self.addSubview(subScrollView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func tableViewCell(tableView : UITableView) -> SubControllerTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            tableView.register(UINib(nibName: "SubControllerTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
            cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        }
        return cell as! SubControllerTableViewCell
    }
    
    func setupContent(vcArray : [UIViewController]) -> UIScrollView {
        self.vcArray = vcArray
        return subScrollView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == subScrollView {
            subControllerScrollView.isScrollEnabled = false
        }
    }
    
  
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        subControllerScrollView.isScrollEnabled = true
        subScrollView.isScrollEnabled = true
        let index : Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if self.delegate != nil {
            let currentC = vcArray[index] as! BaseViewController
            currentC.isMainTop = self.currentController.isMainTop
            currentC.isSubTop = self.currentController.isSubTop
            self.currentController = currentC
        }
        toolsView.changeTabbarLabelLocation(targetTag: index)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tabbarView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 44)
        toolsView.frame = CGRect(x: 0, y: 0, width: self.tabbarView.bounds.size.width, height: self.tabbarView.bounds.size.height)
        subScrollView.frame = CGRect(x: 0, y: tabbarView.frame.maxY, width: self.bounds.size.width, height: self.bounds.size.height - tabbarView.bounds.size.height)
        
        for (index,vc) in vcArray.enumerated() {
            // 当前显示的子控制器（默认第一个）
            self.currentController = (vcArray[0] as! BaseViewController)
            let subController = (vc as! BaseViewController)
            let view = vc.view
            subScrollView.addSubview(view!)
            subController.subScrollV = subScrollView
            subControllerScrollView = subController.subTableView
            
            view?.frame = CGRect(x: CGFloat(index) * subScrollView.bounds.size.width, y: 0, width: subScrollView.bounds.size.width, height: self.subScrollView.bounds.size.height)
        }
        subScrollView.contentSize = CGSize(width: CGFloat(vcArray.count) * subScrollView.bounds.size.width, height: subScrollView.bounds.size.height)
    }
    
    
    
}

extension SubControllerTableViewCell : SelectedBarToolsViewDelegate {
    func selectedBarToolsView(view: SelectedBarToolsView, currentView: Int, targetView: Int) {
        print("\(currentView)---->\(targetView)")
        
        UIView.animate(withDuration: 1, animations: {
            self.subScrollView.contentOffset.x = kScrenW * CGFloat(targetView)
        }) { (_) in
            self.subControllerScrollView.isScrollEnabled = true
            self.subScrollView.isScrollEnabled = true
            let index : Int = Int(self.subScrollView.contentOffset.x / self.subScrollView.bounds.size.width)
            if self.delegate != nil {
                let currentC = self.vcArray[index] as! BaseViewController
                currentC.isMainTop = self.currentController.isMainTop
                currentC.isSubTop = self.currentController.isSubTop
                self.currentController = currentC
            }
        }
    }
}

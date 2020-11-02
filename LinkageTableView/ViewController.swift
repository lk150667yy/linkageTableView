//
//  ViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/23.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit
import SnapKit

// MARK:- 手机宽度和高度
/// 手机宽度
let kScrenW : CGFloat = UIScreen.main.bounds.width
/// 手机高度
let kScrenH : CGFloat = UIScreen.main.bounds.height

class ViewController: HomeBaseViewController {
    
    lazy var mainScrollView: UIScrollView = {
        var mainScrollView = UIScrollView()
        mainScrollView.bounces = false
        mainScrollView.delegate = self
        return mainScrollView
    }()
    
    lazy var headerView: UIView = {
        var headerView = UIView()
        headerView.backgroundColor = UIColor.blue
        return headerView
    }()
    
    lazy var tabbarView: UIView = {
        var tabbarView = UIView()
        tabbarView.backgroundColor = UIColor.orange
        return tabbarView
    }()
    
    lazy var subScrollView: UIScrollView = {
        var subScrollView = UIScrollView()
        subScrollView.bounces = false
        subScrollView.isPagingEnabled = true
        subScrollView.delegate = self
        return subScrollView
    }()
    
    
    
    var AVC = AViewController()
    var BVC = BViewController()
    var CVC = CViewController()
    var DVC = DViewController()
    var EVC = EViewController()
    var vcArray : [UIView] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 11, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeAction), name: NSNotification.Name(rawValue: "aaaa"), object: nil)
        
        vcArray.append(AVC.view)
        vcArray.append(BVC.view)
        vcArray.append(CVC.view)
        vcArray.append(DVC.view)
        vcArray.append(EVC.view)
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(headerView)
        mainScrollView.addSubview(tabbarView)
        mainScrollView.addSubview(subScrollView)
        mainScrollView.frame = CGRect(x: 0, y: -44, width: kScrenW, height: kScrenH) //  + 44 + 34
        headerView.frame = CGRect(x: 0, y: 0, width: kScrenW, height: 200)
        tabbarView.frame = CGRect(x: 0, y: headerView.bounds.height, width: kScrenW, height: 50)
        subScrollView.frame = CGRect(x: 0, y: headerView.bounds.height + tabbarView.bounds.height, width: kScrenW, height: kScrenH - 88 - 50)
        mainScrollView.contentSize = CGSize(width: kScrenW, height: kScrenH + (250 - 88 - 50))
        for (index,v) in vcArray.enumerated() {
            let view = v
            view.frame = CGRect(x: CGFloat(index) * kScrenW, y: 0, width: kScrenW, height: subScrollView.bounds.height)
            subScrollView.addSubview(view)
        }
        subScrollView.contentSize = CGSize(width: kScrenW * CGFloat(vcArray.count), height: subScrollView.bounds.height)
        
    }

    @objc func changeAction(no : Notification) {
//        let offsetY = no.userInfo!["aaa"]
//        
//        mainScrollView.contentOffset.y = offsetY as! CGFloat
    }
    
    

}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView == subScrollView {
            if scrollView.contentOffset.y >= 0 {
                subScrollView.isScrollEnabled = false
                mainScrollView.isScrollEnabled = true
            }
        } else {
            if scrollView.contentOffset.y == 68 {
                mainScrollView.isScrollEnabled = false
            }
        }
    }
}


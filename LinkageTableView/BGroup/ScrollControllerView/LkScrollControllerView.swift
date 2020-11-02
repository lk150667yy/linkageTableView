//
//  LkScrollControllerView.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/11/2.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

protocol LkScrollControllerViewDelegate {
    func scrollViewDidEndDecelerating(view : LkScrollControllerView,toLocation location : Int)
}

class LkScrollControllerView: UIView {

    var delegate : LkScrollControllerViewDelegate?
    
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    /// 需要添加的数据view
    var dataView : [UIView] = [] {
        didSet {
            for _ in 0..<dataView.count {
                loadView.append(false)
            }
        }
    }
    
    var loadView : [Bool] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LkScrollControllerView {
    /// 设置scrollView滚动的位置
    /// - Parameter location: location
    func scrollViewDidScrillLocation(location : Int) {
        self.scrollView.contentOffset.x = scrollView.bounds.size.width * CGFloat(location)
        if !loadView[location] {
            let view = dataView[location]
            view.frame = CGRect(x: scrollView.bounds.size.width * CGFloat(location), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            self.scrollView.addSubview(view)
            loadView[location] = true
        }
    }
}
    


extension LkScrollControllerView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 处理滚动时的动画设置
        
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index : Int = Int(scrollView.contentOffset.x / self.scrollView.bounds.size.width)
        if self.delegate != nil {
            self.delegate!.scrollViewDidEndDecelerating(view: self, toLocation: index)
        }
        if !loadView[index] {
            let view = dataView[index]
            view.frame = CGRect(x: scrollView.bounds.size.width * CGFloat(index), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            self.scrollView.addSubview(view)
            loadView[index] = true
        }
    }
}


extension LkScrollControllerView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        let width = self.scrollView.bounds.size.width
        let height = self.scrollView.bounds.size.height
    
        for (index,subView) in dataView.enumerated() {
            if index == 0 {
                self.scrollView.addSubview(subView)
                subView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
                loadView[index] = true
            }
        }
        scrollView.contentSize = CGSize(width: CGFloat(dataView.count) * width, height: 0)
    }
}

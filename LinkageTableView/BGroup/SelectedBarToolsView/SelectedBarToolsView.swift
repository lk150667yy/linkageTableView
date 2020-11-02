//
//  SelectedBarToolsView.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/29.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

protocol SelectedBarToolsViewDelegate : NSObjectProtocol {
    
    /// 点击标签时进行控制器的转换
    /// - Parameters:
    ///   - view: view
    ///   - currentView: 当前的控制器
    ///   - targetView: 目标控制器
    func selectedBarToolsView(view : SelectedBarToolsView,currentView : Int,targetView : Int)
}

class SelectedBarToolsView: UIView,UIScrollViewDelegate {
    
    /// 线的位置
    enum MarkerLineMode {
        case top
        case bottom
    }
    
    /// 线动画模式
    enum MarkerLineAnimation {
        /// 无动画
        case none
        /// 匀速到下一个位置
        case constantSpeedNextLocation
        /// 弹簧效果
        case usingSpring
    }
    
    /// 选中的文字模式
    enum TabbarSelectedMode {
        /// 默认(即放大又有背景)
        case normal
        /// 一大一小(大的是选中的)
        case aLargeAndASmall
        /// 背景切圆
        case backGroundTangential
    }
    
    
    lazy var tabbarTools: UIScrollView = {
        var tabbarTools = UIScrollView()
        tabbarTools.bounces = false
        tabbarTools.showsVerticalScrollIndicator = false
        tabbarTools.showsHorizontalScrollIndicator = false
        tabbarTools.delegate = self
        return tabbarTools
    }()
    
    /// 上面的分割线
    lazy var topLine: UIView = {
        var topLine = UIView()
        topLine.backgroundColor = splitLineTopBackgroundColor
        return topLine
    }()
    /// 下面的分割线
    lazy var bottomLine: UIView = {
        var bottomLine = UIView()
        bottomLine.backgroundColor = splitLineBottomBackgroundColor
        return bottomLine
    }()
    /// 分割线的颜色
    var splitLineTopBackgroundColor : UIColor = UIColor.lightGray {
        didSet {
            topLine.backgroundColor = splitLineTopBackgroundColor
        }
    }
    /// 分割线的颜色
    var splitLineBottomBackgroundColor : UIColor = UIColor.lightGray {
        didSet {
            topLine.backgroundColor = splitLineBottomBackgroundColor
        }
    }
    /// 是否显示上面的分割线
    var isHiddenTopLine : Bool = false {
        didSet {
            topLine.isHidden = isHiddenTopLine
        }
    }
    /// 是否显示下面的分割线
    var isHiddenBottomLine : Bool = false {
        didSet {
            bottomLine.isHidden = isHiddenBottomLine
        }
    }
    
    /// 代理
    var tabbarDelegate : SelectedBarToolsViewDelegate!
    
    /// 标签的背景view
    var tabbarBackgroundView : UIView = UIView()
    /// 文字选中的背景颜色
    open var tabbarSelectedBackgroundColor : UIColor = UIColor.lightGray {
        didSet {
            tabbarBackgroundView.backgroundColor = tabbarSelectedBackgroundColor
        }
    }
    /// 标签view
    fileprivate var tabbarArray : [TabbarToolsLabel] = []
    /// 标签title
    open var titles : [String] = []
    /// 标签文字大小
    fileprivate var titlesSize : [CGSize] = []
    /// 当前被选中的标签
    fileprivate var selectedTabbarLocation : Int = 0
    /// 工具的背景颜色
    open var toolsBackGroundColor : UIColor = UIColor.white
    /// 标签标志线
    open var markerLine : UIView = UIView()
    /// 是否显示标签标志线
    open var isHiddenMarkerLine : Bool = false {
        didSet {
            markerLine.isHidden = isHiddenMarkerLine
        }
    }
    /// 标志线的颜色
    open var markerColor : UIColor = UIColor.red
    /// 标志线的类型
    open var markerLineMode : MarkerLineMode = .bottom
    /// 标志线是否固定宽度
    open var isMarkerLineFixationWidth : Bool = true
    /// 标志线的高度
    fileprivate var markerLineHeight : CGFloat = 2
    /// 标志线动画
    open var markerLineAnimation : MarkerLineAnimation = .none
    /// 文字选中mode
    open var tabbarSelectedMode : TabbarSelectedMode = .aLargeAndASmall {
        didSet {
            if tabbarSelectedMode == .aLargeAndASmall {
                tabbarBackgroundView.isHidden = true
            } else {
                tabbarBackgroundView.isHidden = false
            }
        }
    }
    /// 文字选中的文字颜色
    open var tabbarSelectedTextColor : UIColor = UIColor.red
    /// 文字选中的字体大小
    open var selectedFont : UIFont = UIFont.systemFont(ofSize: 16)
    /// 文字正常字体大小
    open var normalFont : UIFont = UIFont.systemFont(ofSize: 14)
    /// 文字正常的文字颜色
    open var normalTextColor : UIColor = UIColor.black
    /// 文字正常的背景颜色
    open var normalBackgroundColor : UIColor = UIColor.white
    /// 是否显示导向标
    
    /// 是否有更多操作
    
    /// 文字选中时是否居中显示
    
    /// 文字标签是否平分当前屏幕的宽度（超过4个自动按宽度排列，如果总宽度小于）
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = toolsBackGroundColor
        self.addSubview(tabbarTools)
        self.tabbarTools.addSubview(tabbarBackgroundView)
        self.tabbarBackgroundView.backgroundColor = tabbarSelectedBackgroundColor
        self.addSubview(topLine)
        self.addSubview(bottomLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置相关数据后需要进行配置的方法
    func config() {
        tabbarArray.removeAll()
        titlesSize.removeAll()
        var contentSizeWidth : CGFloat = 0
        
        for (index,title) in titles.enumerated() {
            let tabbarLabel : TabbarToolsLabel = TabbarToolsLabel()
            if index == 0 {
                tabbarLabel.font = selectedFont
                tabbarLabel.textColor = tabbarSelectedTextColor
            } else {
                tabbarLabel.font = normalFont
                tabbarLabel.textColor = normalTextColor
            }
            titlesSize.append(textSize(text: title, font: selectedFont))
            tabbarLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabbarTouchAction)))
            tabbarLabel.title = title
            tabbarLabel.tag = index
            contentSizeWidth += titlesSize[index].width
            self.tabbarTools.addSubview(tabbarLabel)
            tabbarArray.append(tabbarLabel)
        }
        tabbarTools.contentSize = CGSize(width: contentSizeWidth, height: 0)
        markerLine.backgroundColor = markerColor
        self.tabbarTools.addSubview(markerLine)
        
    }
    
    /// 计算文字的大小
    func textSize(text : String,font : UIFont) -> CGSize {
        let rect = NSString(string: text).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil)
        let height : CGFloat = ceil(rect.height + 10)
        let width : CGFloat = ceil(rect.width + 20)
        return CGSize(width: width, height: height)
    }
    
    /// 改变tabbarLabel的位置
    /// - Parameter targetTag: 目标的tag
    func changeTabbarLabelLocation(targetTag : Int) {
        let targetView = tabbarArray[targetTag]
        
        let currentView = tabbarArray[selectedTabbarLocation]
        // 当点击的view是同一个时，不做任何操作
        if targetView.tag == currentView.tag {
            return
        }
        
        // 传递点击的tabbar
        if self.tabbarDelegate != nil {
            self.tabbarDelegate.selectedBarToolsView(
                view: self,
                currentView: selectedTabbarLocation,
                targetView: targetView.tag)
        }
        // 设置tabbarSelectedMode
        switch tabbarSelectedMode {
        case .normal:
            self.tabbatToolsTextAttribute(
                targetView: targetView,
                currentView: currentView,
                targetFont: selectedFont,
                targetTextcolor: tabbarSelectedTextColor,
                currentFont: normalFont,
                currentTextColor: normalTextColor)
        case .aLargeAndASmall:
            self.tabbatToolsTextAttribute(
                targetView: targetView,
                currentView: currentView,
                targetFont: selectedFont,
                targetTextcolor:tabbarSelectedTextColor,
                currentFont: normalFont,
                currentTextColor: normalTextColor)
        case .backGroundTangential:
            self.tabbatToolsTextAttribute(
                targetView: targetView,
                currentView: currentView,
                targetFont: normalFont,
                targetTextcolor: tabbarSelectedTextColor,
                currentFont: normalFont,
                currentTextColor: normalTextColor)
        }
        
        // 设置markerLineAnimation
        switch markerLineAnimation {
        case .none:
            self.tabbarMoveAnimation(
                targetView: targetView,
                isAnimation: false)
        case .constantSpeedNextLocation:
            self.tabbarMoveAnimation(
                targetView: targetView,
                duration: 1,
                usingSpring: 1,
                initialSpring: 8,
                isAnimation: true)
        case .usingSpring:
            self.tabbarMoveAnimation(
                targetView: targetView,
                duration: 1,
                usingSpring: 0.3,
                initialSpring: 8,
                isAnimation: true)
        }
        
        // 赋值为当前的view
        selectedTabbarLocation = targetView.tag
    }
}

extension SelectedBarToolsView {
    /// 点击标签的方法
    @objc func tabbarTouchAction(tap : UITapGestureRecognizer) {
        let targetView = tap.view as! TabbarToolsLabel
        self.changeTabbarLabelLocation(targetTag: targetView.tag)
    }
    
    /// 设置文字属性
    /// - Parameters:
    ///   - targetView: 目标view
    ///   - currentView: 当前view
    ///   - targetFont: 目标字号
    ///   - targetTextcolor: 目标颜色颜色
    ///   - currentFont: 当前字号
    ///   - currentTextColor: 当前文字颜色
    func tabbatToolsTextAttribute(
        targetView:TabbarToolsLabel,
        currentView : TabbarToolsLabel,
        targetFont:UIFont,
        targetTextcolor:UIColor,
        currentFont:UIFont,
        currentTextColor:UIColor) {
        targetView.font = targetFont
        targetView.textColor = targetTextcolor
        currentView.font = currentFont
        currentView.textColor = currentTextColor
    }
    
    
    /// 标签线移动动画
    /// - Parameters:
    ///   - targetView: 移动到的目标标签
    ///   - duration: 动画时常 默认1秒
    ///   - delay: 延时 默认无延迟
    ///   - usingSpring: 弹簧效果 默认无弹簧效果
    ///   - initialSpring: 初始速度 8
    ///   - options: 动画选项
    ///   - isAnimation: 是否动画
    func tabbarMoveAnimation(
        targetView:TabbarToolsLabel,
        duration: TimeInterval = 1,
        delay : TimeInterval = 0,
        usingSpring :CGFloat = 1,
        initialSpring:CGFloat = 8,
        options :UIView.AnimationOptions = [],
        isAnimation : Bool) {
        
        let targetViewWidth = titlesSize[targetView.tag].width - 10
        let targetViewheight = titlesSize[targetView.tag].height - 5
        
        if isAnimation {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: usingSpring,
                initialSpringVelocity: initialSpring,
                options: options, animations: {
                    // 设置标志线的位置
                    self.markerLine.center = CGPoint(x: targetView.center.x, y: self.markerLine.center.y)
                    // 设置标签背景的大小及位置
                    self.tabbarBackgroundView.bounds = CGRect(x: 0, y: 0, width: targetViewWidth, height: targetViewheight)
                    self.tabbarBackgroundView.center = targetView.center
                    // 滚动条居中显示
                    var offset = targetView.center.x - kScrenW * 0.5
                    // 当偏移量过大时配置为最大偏移量
                    if offset > self.tabbarTools.contentSize.width - self.tabbarTools.bounds.size.width && offset > 0 {
                        offset = self.tabbarTools.contentSize.width - self.tabbarTools.bounds.size.width
                    } else if offset < 0 {
                        offset = 0
                    }
                    self.tabbarTools.contentOffset = CGPoint(x: offset, y: 0)
            }, completion: nil)
        } else {
            // 设置标志线的位置
            self.markerLine.center = CGPoint(x: targetView.center.x, y: self.markerLine.center.y)
            // 设置标签背景的大小及位置
            self.tabbarBackgroundView.bounds = CGRect(x: 0, y: 0, width: targetViewWidth, height: targetViewheight)
            self.tabbarBackgroundView.center = targetView.center
            // 滚动条居中显示
            var offset = targetView.center.x - kScrenW * 0.5
            // 当偏移量过大时配置为最大偏移量
            if offset > self.tabbarTools.contentSize.width - self.tabbarTools.bounds.size.width && offset > 0 {
                offset = self.tabbarTools.contentSize.width - self.tabbarTools.bounds.size.width
            } else if offset < 0 {
                offset = 0
            }
            self.tabbarTools.contentOffset = CGPoint(x: offset, y: 0)
        }
        
    }
    
}


extension SelectedBarToolsView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置线的位置
        topLine.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0.5)
        bottomLine.frame = CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5)
        // 设置tabbarTools及子view的frame
        tabbarTools.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        for (index,tabbar) in tabbarArray.enumerated() {
            if index == 0 {
                tabbar.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: titlesSize[index].width, height: tabbarTools.bounds.size.height))
            } else {
                let tempTabbar = tabbarArray[index - 1]
                tabbar.frame = CGRect(origin: CGPoint(x: tempTabbar.frame.maxX, y: 0), size: CGSize(width: titlesSize[index].width, height: tabbarTools.bounds.size.height))
            }
        }
        // 设置tabbarBackgroundView的frame
        tabbarBackgroundView.bounds = CGRect(x: 0, y: 0, width: titlesSize[0].width - 10, height: titlesSize[0].height - 5)
        tabbarBackgroundView.center = tabbarArray[0].center
        if tabbarSelectedMode != .aLargeAndASmall {
            tabbarBackgroundView.layer.cornerRadius = tabbarBackgroundView.bounds.size.height * 0.5
            tabbarBackgroundView.layer.masksToBounds = true
        } else {
            tabbarBackgroundView.isHidden = true
        }
        // 设置markerLine的frame
        markerLine.bounds = CGRect(x: 0, y: 0, width: 20, height: markerLineHeight)
        if markerLineMode == .top {
            markerLine.center = CGPoint(x: tabbarArray[0].center.x, y: markerLineHeight * 0.5)
        } else {
            markerLine.center = CGPoint(x: tabbarArray[0].center.x, y: self.bounds.size.height - (markerLineHeight * 0.5))
        }
        
    }
}

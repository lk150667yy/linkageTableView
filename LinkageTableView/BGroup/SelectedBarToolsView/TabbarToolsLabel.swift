//
//  TabbarToolsLabel.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/30.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class TabbarToolsLabel: UIView {

    /// 显示文字
    var title : String = "" {
        didSet {
            titleContent.text = title
        }
    }
    /// 文字颜色
    var textColor : UIColor = UIColor.black {
        didSet {
            titleContent.textColor = textColor
        }
    }
    /// 文字大小
    var font : UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleContent.font = font
        }
    }
    
    lazy var titleContent: UILabel = {
        var titleContent = UILabel()
        titleContent.textAlignment = .center
        return titleContent
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        titleContent.backgroundColor = UIColor.clear
        self.addSubview(titleContent)
        titleContent.font = font
        titleContent.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TabbarToolsLabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        titleContent.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalTo(self.center.y)
        }
    }
}

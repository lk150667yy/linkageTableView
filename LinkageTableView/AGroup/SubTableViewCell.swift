//
//  SubTableViewCell.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/23.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

fileprivate let cellID : String = "SubTableViewCellID"

class SubTableViewCell: UITableViewCell {

    var viewArray : [UIView] = [] {
        didSet {
            addScrollViewSubView()
        }
    }
    
    @IBOutlet weak var topView: UIView!
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(scrollView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static func tableViewCell(tableView : UITableView) -> SubTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            tableView.register(UINib(nibName: "SubTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
            cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        }
        return cell as! SubTableViewCell
    }
    
    
    
}

extension SubTableViewCell {
    func addScrollViewSubView() {
        for (index,v) in viewArray.enumerated() {
            let view = v
            view.frame = CGRect(x: CGFloat(index) * kScrenW, y: 0, width: kScrenW, height: scrollView.bounds.height)
            self.scrollView.addSubview(view)
        }
        scrollView.contentSize = CGSize(width: kScrenW * CGFloat(viewArray.count), height: scrollView.bounds.height)
    }
    
}


extension SubTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(0)
        }
    }
}

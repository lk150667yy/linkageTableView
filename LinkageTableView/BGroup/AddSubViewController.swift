//
//  AddSubViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/11/2.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class AddSubViewController: UIViewController, LkScrollControllerViewDelegate, SelectedBarToolsViewDelegate {
    
    
    
    lazy var selectedBarToolsView : SelectedBarToolsView = {
        var selectedBarToolsView = SelectedBarToolsView()
        selectedBarToolsView.tabbarDelegate = self
        return selectedBarToolsView
    }()
    

    var subAVC = SubAViewController()
    var subBVC = SubBViewController()
    var subCVC = SubCViewController()
    
    lazy var scrollController: LkScrollControllerView = {
        var scrollController = LkScrollControllerView()
        scrollController.delegate = self
        return scrollController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedBarToolsView.titles = ["subA","subB","subC"]
        selectedBarToolsView.config()
        self.view.addSubview(selectedBarToolsView)
        scrollController.dataView = [subAVC.view,subBVC.view,subCVC.view]
        self.view.addSubview(scrollController)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectedBarToolsView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().offset(0)
            make.height.equalTo(44)
        }
        scrollController.snp.makeConstraints { (make) in
            make.top.equalTo(selectedBarToolsView.snp.bottom).offset(0)
            make.left.right.bottom.equalToSuperview().offset(0)
        }
    }
    
    
    func scrollViewDidEndDecelerating(view: LkScrollControllerView, toLocation location: Int) {
        selectedBarToolsView.changeTabbarLabelLocation(targetTag: location)
    }
    
    func selectedBarToolsView(view: SelectedBarToolsView, currentView: Int, targetView: Int) {
        scrollController.scrollViewDidScrillLocation(location: targetView)
    }
    

}

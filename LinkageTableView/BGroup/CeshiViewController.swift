//
//  CeshiViewController.swift
//  LinkageTableView
//
//  Created by 刘凯 on 2020/10/31.
//  Copyright © 2020 刘凯. All rights reserved.
//

import UIKit

class CeshiViewController: UIViewController {

    
    lazy var btn: UIButton = {
        var button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(aaa), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    
    lazy var textV: UITextField = {
        var textV = UITextField()
        textV.backgroundColor = UIColor.green
        return textV
    }()
    
    
    var jiaodu : [Double] = [150.0,120.0,90.0,60.0,30.0]
    var timer : Timer?
    
    var num : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startAction111), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .default)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(btn)
        self.view.addSubview(textV)
        
        btn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(200)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        textV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn.snp.bottom).offset(100)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        
        
    }
    
    @objc func startAction111() {
        
        
        let pp = configDistance(j: jiaodu[num])
        
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.lightGray
        self.view.addSubview(v)
        v.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        v.center = CGPoint(x: kScrenW * 0.5, y: kScrenH - 50)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8, options: [], animations: {
            v.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
            v.center = pp
            v.layer.cornerRadius = 30
        }) { (a) in
            
        }
        num += 1
        if jiaodu.count == num {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    @objc func aaa() {
        
//        timer?.fire()
        
//        textV.resignFirstResponder()
//
//        if textV.text == "" {
//            return
//        }
//
//        let text : Double = Double(Int(textV.text!)!)

        let p = configDistance()
        
        for pp in p {
            let v = UIView()
            v.layer.cornerRadius = 10
            v.layer.masksToBounds = true
            v.backgroundColor = UIColor.lightGray
            self.view.addSubview(v)
            v.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            v.center = CGPoint(x: kScrenW * 0.5, y: kScrenH - 50)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8, options: [], animations: {
                v.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
                v.center = pp
                v.layer.cornerRadius = 30
            }) { (a) in
                
            }
        }
        
    }
    
    func configDistance(j : Double) -> CGPoint {
            let a = radianToAngle(angle: j)
            let co1 = cos(a)
            let si1 = sin(a)
            
            let r : Double = 160
            let hor = co1 * r
            let ver = si1 * r
            
            let x = kScrenW * 0.5 + CGFloat(hor)
            let y = kScrenH - CGFloat(ver) - 50
        return CGPoint(x: x, y: y)
        
        
    }
    
    
    func configDistance() -> [CGPoint] {
        var pointArray : [CGPoint] = []
        
        for j in jiaodu {
            let a = radianToAngle(angle: j)
            let co1 = cos(a)
            let si1 = sin(a)
            
            let r : Double = 160
            let hor = co1 * r
            let ver = si1 * r
            
            let x = kScrenW * 0.5 + CGFloat(hor)
            let y = kScrenH - CGFloat(ver) - 50
            pointArray.append(CGPoint(x: x, y: y))
        }
        
        return pointArray
        
        
    }
    
    
    ///
    func radianToAngle(angle : Double) -> Double{
        let radians = (angle / 180) * Double.pi
        return radians
    }
    
}

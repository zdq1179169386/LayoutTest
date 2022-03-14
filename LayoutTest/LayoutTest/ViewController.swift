//
//  ViewController.swift
//  LayoutTest
//
//  Created by zdq on 3/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "请输入 view 个数"
        return textField
    }()
    
    private lazy var textLab: UILabel = {
        let this = UILabel()
        this.textAlignment = .right
        return this
    }()
    
    private var views: [UIView] = []
    
    private var resultMap: [String: [String: [String: Double]]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn1 = createBtn(title: "AutoLayout")
        btn1.addTarget(self, action: #selector(generateViews), for: .touchUpInside)
        btn1.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        let btn2 = createBtn(title: "AutoLayout嵌套")
        btn2.addTarget(self, action: #selector(generateNestedViews), for: .touchUpInside)
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btn1.snp.centerY)
        }
        let btn3 = createBtn(title: "Frame")
        btn3.addTarget(self, action: #selector(generateFrameViews), for: .touchUpInside)
        btn3.snp.makeConstraints { make in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(btn1.snp.centerY)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(btn3.snp.top)
        }
        
        let btn5 = createBtn(title: "打印")
        btn5.addTarget(self, action: #selector(log), for: .touchUpInside)
        btn5.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(textLab)
        textLab.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(btn5.snp.centerY)
        }
        
        
    }
    
    
    private func createBtn(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        view.addSubview(btn)
        return btn
    }
    
    private func randomColor() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 256) / 256.0, saturation: CGFloat(arc4random() % 128) / 256.0 + 0.5, brightness: CGFloat(arc4random() % 128) / 256.0 + 0.5, alpha: 1)
    }
    
    // autolayout
    @objc func generateViews() {
        guard let text = textField.text, let number = Int(text) else { return }
        views.forEach({ $0.removeFromSuperview() })
        views.removeAll()
        
        let startTime = NSDate.timeIntervalSinceReferenceDate
        
        for _ in 0..<number {
            var leftView = self.view
            var topView = self.view
            if views.count != 0 {
                let left = Int(arc4random())%views.count
                let top = Int(arc4random())%views.count
                leftView = views[left]
                topView = views[top]
            }
            
            let leftSpace = CGFloat(arc4random() % 414) - (leftView?.frame.origin.x ?? 0)
            let topSpace = CGFloat(arc4random() % 568) - (topView?.frame.origin.y ?? 0)
            
            let newView = UIView()
            newView.backgroundColor = randomColor()
            view.addSubview(newView)
            newView.snp.makeConstraints { make in
                make.left.greaterThanOrEqualTo(0)
                make.right.lessThanOrEqualTo(0)
                make.top.greaterThanOrEqualTo(100)
                make.bottom.lessThanOrEqualTo(-150)
                make.left.equalTo(leftView!).offset(leftSpace).priority(.medium)
                make.top.equalTo(topView!).offset(topSpace).priority(.medium)
                make.size.equalTo(10)
            }
            views.append(newView)
        }
        let endTime = NSDate.timeIntervalSinceReferenceDate
        let timeInterval = endTime - startTime
        textLab.text = "\(timeInterval)"
        
        var layoutmap = resultMap["AutoLayout"] ?? [String: [String: Double]]()
        var timesMap = layoutmap["\(number)"] ?? [String: Double]()
        let times = timesMap["times"] ?? 0
        let avgTime = timesMap["avgTime"] ?? 0
        
        timesMap["times"] = times + 1
        timesMap["avgTime"] = (times * avgTime + timeInterval) / (times + 1)
        
        layoutmap["\(number)"] = timesMap
        
        resultMap["AutoLayout"] = layoutmap
    }
    
    // autolayout 嵌套
    @objc func generateNestedViews() {
        guard let text = textField.text, let number = Int(text) else { return }
        views.forEach({ $0.removeFromSuperview() })
        views.removeAll()
        
        let startTime = NSDate.timeIntervalSinceReferenceDate
        for i in 0..<number {
            let newView = UIView()
            newView.backgroundColor = randomColor()
            
            if views.count == 0 {
                view.addSubview(newView)
                newView.snp.makeConstraints { make in
                    make.left.equalTo(0.5)
                    make.top.equalTo(100)
                    make.right.equalTo(-0.5)
                    make.bottom.equalTo(-150)
                }
            } else {
                let aview = views[i - 1]
                aview.addSubview(newView)
                newView.snp.makeConstraints { make in
                    make.left.top.equalTo(1)
                    make.bottom.right.equalTo(-1)
                }
            }
            
            views.append(newView)
        }
        
        let endTime = NSDate.timeIntervalSinceReferenceDate
        let timeInterval = endTime - startTime
        textLab.text = "\(timeInterval)"
        
        var layoutmap = resultMap["AutoLayout嵌套"] ?? [String: [String: Double]]()
        var timesMap = layoutmap["\(number)"] ?? [String: Double]()
        let times = timesMap["times"] ?? 0
        let avgTime = timesMap["avgTime"] ?? 0
        
        timesMap["times"] = times + 1
        timesMap["avgTime"] = (times * avgTime + timeInterval) / (times + 1)
        
        layoutmap["\(number)"] = timesMap
        
        resultMap["AutoLayout嵌套"] = layoutmap
    }
    // frame
    @objc func generateFrameViews() {
        guard let text = textField.text, let number = Int(text) else { return }
        views.forEach({ $0.removeFromSuperview() })
        views.removeAll()
        
        let startTime = NSDate.timeIntervalSinceReferenceDate
        
        for _ in 0..<number {
            let leftSpace = CGFloat(arc4random() % 404 % UInt32(view.frame.size.width))
            let topSpace = CGFloat(arc4random() % 676 % UInt32(view.frame.size.height + 20)) + 70
            
            let newView = UIView(frame: CGRect(x: leftSpace, y: topSpace, width: 10, height: 10))
            newView.backgroundColor = randomColor()
            view.addSubview(newView)
            views.append(newView)
        }
        
        let endTime = NSDate.timeIntervalSinceReferenceDate
        let timeInterval = endTime - startTime
        textLab.text = "\(timeInterval)"
        
        var layoutmap = resultMap["Frame"] ?? [String: [String: Double]]()
        var timesMap = layoutmap["\(number)"] ?? [String: Double]()
        let times = timesMap["times"] ?? 0
        let avgTime = timesMap["avgTime"] ?? 0
        
        timesMap["times"] = times + 1
        timesMap["avgTime"] = (times * avgTime + timeInterval) / (times + 1)
        
        layoutmap["\(number)"] = timesMap
        
        resultMap["Frame"] = layoutmap
    }
    
    
    @objc func log() {
        print("\(resultMap)")
    }
}


//
//  narrowNavigationViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/15.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class narrowNavigationViewController: UINavigationController {

    lazy public var searchBtn: UIButton = self.createSearchButton()
    lazy var frameWidth : CGFloat = self.view.frame.width
    lazy var frameHeight : CGFloat = self.view.frame.height

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBtn = self.createSearchButton()
        self.searchModal.modalPresentationStyle = .custom
        self.searchModal.view.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        self.createNavigationItems()

        // Do any additional setup after loading the view.
    }

    public func Constraint(item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item:       item,
            attribute:  attr,
            relatedBy:  relate,
            toItem:     to,
            attribute:  attrTo,
            multiplier: multiplier,
            constant:   constant
        )
        ret.priority = priority
        return ret
    }


    private func createNavigationItems() {
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight * 1))
        navigationView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.1)
        let naviItem = UIBarButtonItem(customView: navigationView)
        self.navigationItem.rightBarButtonItem = naviItem
        navigationView.addSubview(self.searchBtn)
        
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addConstraints([
            Constraint(item:self.searchBtn, .top,     to: navigationView, .top, constant:0, multiplier:1.0),
            Constraint(item:self.searchBtn, .height,  to: navigationView, .height),
            Constraint(item:self.searchBtn, .right,   to: navigationView, .right, constant:0, multiplier: 1.0 ),
            Constraint(item:self.searchBtn, .width,   to: navigationView, .width, constant:0, multiplier: 1.0 ),
            ])
        print(self.title)
        self.navigationItem.title = self.title
    }


    open func createSearchButton() -> UIButton{
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: frameWidth * 0.1, height: frameHeight * 0.04)
        btn.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        btn.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .normal)
        btn.setTitle("検索", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(self.doBtn(sender:)), for:.touchUpInside)
        return btn
    }
    
    
    lazy var  searchModal:SearchModalViewController = SearchModalViewController()
    
    @objc open func doBtn(sender : UIButton) {
        print("doBtn")
        //        let searchModal = storyboard?.instantiateViewController(withIdentifier: "SearchModal")
        present(searchModal, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(rootVC:UIViewController , naviBarClass:AnyClass?, toolbarClass: AnyClass?){
        self.init(navigationBarClass: naviBarClass, toolbarClass: toolbarClass)
        self.viewControllers = [rootVC]
    }
    
}

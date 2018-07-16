//
//  BaseViewController
//  narrowReader
//
//  Created by kaeruko on 2018/07/11.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class narrowPageViewController: narrowBaseViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    var modalWidth : CGFloat = 0.0
    var modalHeight : CGFloat = 0.0
    var modalOriginX : CGFloat = 0.0
    var modalOriginY : CGFloat = 0.0

    var di:SearchPresentationController!
    lazy public var searchBtn: UIButton = self.createSearchButton()

    var segue :UIStoryboardSegue!

    func setRect() {
        let w = self.view.frame.width
        let h = self.view.frame.height
        self.modalWidth = w * 0.9
        self.modalHeight = h * 0.7
        self.modalOriginX =  ( w - self.modalWidth) * 0.5
        self.modalOriginY = ( h - self.modalHeight) * 0.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        self.setRect()
        self.searchBtn = self.createSearchButton()
        self.searchModal.modalWidth = self.modalWidth
        self.searchModal.modalHeight = self.modalHeight
        self.searchModal.modalOriginX = self.modalOriginX
        self.searchModal.modalOriginY = self.modalOriginY
        self.searchModal.modalPresentationStyle = .formSheet
        self.searchModal.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        self.searchModal.view.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        self.createNavigationItems()
    }
    
    func navigationController() {
        print("navigationController")

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
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        print("presentationController")
        di = SearchPresentationController(presentedViewController: presented, presenting: presenting)
        di.modalWidth = self.modalWidth
        di.modalHeight = self.modalHeight
        di.modalOriginX = self.modalOriginX
        di.modalOriginY = self.modalOriginY
        return di
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

        let modalViewController = SearchModalViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        present(modalViewController, animated: true, completion: nil)

//
//        let vc = SearchModalViewController()
//        let naviVC = narrowNavigationViewController(rootViewController: vc)
//        naviVC.viewControllers = [vc]
//        present(naviVC, animated: true)
//
//
//        present(self.searchModal, animated: true)
    }
    
}


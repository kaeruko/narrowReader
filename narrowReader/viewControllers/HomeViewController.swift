//
//  HomeViewController
//  narrowReader
//
//  Created by kaeruko on 2018/07/11.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import BTNavigationDropdownMenu

class HomeViewController: narrowBaseViewController, UITableViewDelegate, UITableViewDataSource,UIViewControllerTransitioningDelegate {
    
    var modalWidth : CGFloat = 0.0
    var modalHeight : CGFloat = 0.0
    var modalOriginX : CGFloat = 0.0
    var modalOriginY : CGFloat = 0.0

    var genres = ["恋愛","ファンタジー","ギャグ","エッセイ","詩","童話"]

    var di:SearchPresentationController!
    lazy public var searchBtn: UIButton = self.createSearchButton()


    func setRect() {
        let w = self.view.frame.width
        let h = self.view.frame.height
        self.modalWidth = w * 0.9
        self.modalHeight = h * 0.7
        self.modalOriginX =  ( w - self.modalWidth) * 0.5
        self.modalOriginY = ( h - self.modalHeight) * 0.5
    }
    

    override func viewDidLoad() {
        self.title = "小説家にnarrow"
        self.setRect()
        self.view.backgroundColor = UIColor.white
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        super.viewDidLoad()
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
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return SearchPresentationController(presentedViewController: presented, presenting: presenting)
    }

    @objc open func doBtn(sender : UIButton) {
        let modalViewController = SearchModalViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        present(modalViewController, animated: true, completion: nil)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "janres", for: indexPath)
        //        cell.textLabel?.text = self.favos![indexPath.row]["title"] as! String
        cell.textLabel?.text = self.genres[indexPath.row]
        return cell
    }
    


}


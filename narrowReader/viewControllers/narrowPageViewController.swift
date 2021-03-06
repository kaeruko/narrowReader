import UIKit
import Alamofire
import RealmSwift

class novelDetai{
    var ncode : String = ""
    var writer : String = ""
    var global_point : Int = 0
    var keyword : String = ""
    var genre : Int = 0
    var title : String = ""
    var userid : Int = 0
    var fav_novel_cnt : Int = 0
    var all_point : Int = 0
    var end : Int = 0
    var all_hyoka_cnt : Int = 0
    var review_cnt : Int = 0
    var general_all_no : Int = 0
    var novelupdated_at : Date = Date()
    var general_lastup : Date = Date()
    var general_firstup : Date = Date()
    var novel_type : Int = 0
    var biggenre : Int = 0
    var length : Int = 0
    var story : String = ""
}


class Novels: Object{
    @objc dynamic var ncode : String = ""
    @objc dynamic var nnumber : Int = 0
    @objc dynamic var global_point : Int = 0
    @objc dynamic var keyword : String = ""
    @objc dynamic var genre : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var userid : Int = 0
    @objc dynamic var fav_novel_cnt : Int = 0
    @objc dynamic var all_point : Int = 0
    @objc dynamic var end : Int = 0
    @objc dynamic var all_hyoka_cnt : Int = 0
    @objc dynamic var review_cnt : Int = 0
    @objc dynamic var general_all_no : Int = 0
    @objc dynamic var novelupdated_at : Date = Date()
    @objc dynamic var general_lastup : Date = Date()
    @objc dynamic var general_firstup : Date = Date()
    @objc dynamic var novel_type : Int = 0
    @objc dynamic var biggenre : Int = 0
    @objc dynamic var length : Int = 0
    @objc dynamic var story : String = ""   //あらすじ
    @objc dynamic var last_read_no : Int = 0
    @objc dynamic var bookmark : CGFloat = 0
}

class Stories: Object{
    @objc dynamic var ncode : String = ""
    @objc dynamic var nnumber : Int = 0
    @objc dynamic var no : Int = 0
    @objc dynamic var story : String = ""
}

class Favorites: Object{
    @objc dynamic var no : Int = 0
    @objc dynamic var ncode : String = ""
    @objc dynamic var nnumber : Int = 0
}

//
//  BaseViewController
//  narrowReader
//
//  Created by kaeruko on 2018/07/11.
//  Copyright © 2018年 kaeruko. All rights reserved.
//


class narrowPageViewController: narrowBaseViewController, SearchModalViewControllerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    var modalWidth : CGFloat = 0.0
    var modalHeight : CGFloat = 0.0
    var modalOriginX : CGFloat = 0.0
    var modalOriginY : CGFloat = 0.0

    lazy public var searchBtn: UIButton = self.createSearchButton()
    lazy var  searchModal:SearchModalViewController = SearchModalViewController()
    
    func SearchModalDidFinished(condition: searchCondition) {
        self.searchModal.dismiss(animated: true, completion: nil)
        let result = SearchResultViewController()
        result.condition = condition
        self.navigationController?.pushViewController(result, animated: true)
    }

    func setRect() {
        let w = self.frameWidth
        let h = self.frameHeight
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
        self.searchModal.modalPresentationStyle = .formSheet
        self.searchModal.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        self.searchModal.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.createNavigationItems()
    }

    
    var modalname : String = ""
    
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
        self.navigationItem.title = self.title
    }
    

    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if(self.modalname == "search"){
            return SearchPresentationController(presentedViewController: presented, presenting: presenting)
        }else{
            return ErrorPresentationController(presentedViewController: presented, presenting: presenting)
        }
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
    
    @objc open func doBtn(sender : UIButton) {
        self.modalname = "search"
        self.searchModal.modalPresentationStyle = .custom
        self.searchModal.delegate = self as! SearchModalViewControllerDelegate        
        self.searchModal.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        present(self.searchModal, animated: true, completion: nil)
    }
    
    
}


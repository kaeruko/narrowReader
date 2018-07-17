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

class HomeViewController: narrowPageViewController, UITableViewDelegate, UITableViewDataSource {
    
    var genres = ["恋愛","ファンタジー","ギャグ","エッセイ","詩","童話"]

    override func viewDidLoad() {
        self.title = "小説家にnarrow"
        self.setRect()
        self.view.backgroundColor = UIColor.white
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        super.viewDidLoad()
        self.createNavigationItems()
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
        
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return SearchPresentationController(presentedViewController: presented, presenting: presenting)
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


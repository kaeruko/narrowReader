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

class HomeViewController: narrowPageViewController, UITableViewDelegate, UITableViewDataSource {
    
    var genres = ["恋愛","ファンタジー","ギャグ","エッセイ","詩","童話"]
    private var realm: Realm!

    var scrollView : UIScrollView = UIScrollView()
    var textView : UITextView = UITextView()
    
    func setScroll(){
        self.scrollView.backgroundColor = UIColor.white
        
        // 表示窓のサイズと位置を設定
        self.scrollView.frame.size = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight * 1.0 )
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: 3000 )
        self.scrollView.center = self.view.center
        self.textView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight * 1.0)
        self.textView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: 3000 )
        self.textView.text = "お待ち下さいAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        self.textView.isEditable = false
        self.textView.font = UIFont.systemFont(ofSize: 30)
        
        let fitsize : CGSize = (self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )
        self.textView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )


        self.scrollView.addSubview(self.textView)
        
        self.scrollView.delegate = self as! UIScrollViewDelegate
        self.view.addSubview(self.scrollView)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll \(scrollView.bounces)")
        print("\(scrollView.contentOffset.y) / \(scrollView.bounds.size.height) \(scrollView.contentSize.height)")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        print(scrollView.bounces)
        print(scrollView.bounds.size.height)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging")
        print(velocity)
        print(targetContentOffset)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "narrow-reader"
        self.view.backgroundColor = UIColor.white
        let appDelegate = UIApplication.shared.delegate as! AppDelegate




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


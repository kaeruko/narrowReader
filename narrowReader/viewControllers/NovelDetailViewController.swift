//
//  NovelDetailViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/18.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class NovelDetailViewController: narrowPageViewController, UIScrollViewDelegate {

    private var realm: Realm!
    var ndetail : novelDetai = novelDetai()
    var novelModel : Novels = Novels()
    var favModel : Favorites = Favorites()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.ndetail.title
        self.setScroll()
    }

    var menubtn : UIButton = UIButton()
    var favbtn : UIButton = UIButton()
    var bkbtn : UIButton = UIButton()

    var footer : UIView = UIView()

    func setFooter(){
        self.footer.backgroundColor = UIColor.brown
        let footerhight = self.frameHeight * 0.1
        let diff = self.frameHeight - footerhight
        self.footer.frame = CGRect(x: 0, y: diff , width: self.frameWidth, height: footerhight)
        self.view.addSubview(self.footer)
        
        let menuheight = self.footer.frame.height * 0.5
        let menuwidth = self.footer.frame.width * 0.1
        let menux = ((self.footer.frame.width) - (menuwidth)) * 0.9
        let menuy = ((self.footer.frame.height) - (menuheight)) * 0.5
        self.menubtn.frame = CGRect(x: menux, y: menuy, width: menuwidth, height: menuheight)
        self.menubtn.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.menubtn.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .normal)
        self.menubtn.setTitle("menu", for: .normal)
        self.menubtn.setTitleColor(UIColor.white, for: .normal)
//        self.menubtn.addTarget(self, action: #selector(self.openMenu(sender:)), for:.touchUpInside)
        self.footer.addSubview(self.menubtn)
        
        self.favbtn.frame = CGRect(x: ((self.footer.frame.width) - (menuwidth)) * 0.1, y: menuy, width: menuwidth, height: menuheight)
        self.favbtn.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.favbtn.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .normal)
        self.favbtn.setTitle("☆", for: .normal)
        self.favbtn.setTitleColor(UIColor.white, for: .normal)
        self.favbtn.addTarget(self, action: #selector(self.addFavorite(sender:)), for:.touchUpInside)
        self.footer.addSubview(self.favbtn)
        
        self.bkbtn.frame = CGRect(x: ((self.footer.frame.width) - (menuwidth)) * 0.3, y: menuy, width: menuwidth, height: menuheight)
        self.bkbtn.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.bkbtn.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .normal)
        self.bkbtn.setTitle("BK", for: .normal)
        self.bkbtn.setTitleColor(UIColor.white, for: .normal)
        self.bkbtn.addTarget(self, action: #selector(self.addBookmark(sender:)), for:.touchUpInside)
        self.footer.addSubview(self.bkbtn)
        self.getNovel()
    }
    

    func isFavorite(){

    }

    @objc open func addFavorite(sender : UIButton) {
        print(self.favModel)
        //お気に入り登録してない場合、登録する
        if(self.favModel.nnumber == 0){
            self.favModel.ncode = self.novelModel.ncode
            self.favModel.nnumber = self.novelModel.nnumber
            
            try! self.realm.write {
                self.realm.add(self.favModel)
                self.favbtn.setTitle("★", for: .normal)
            }
            //しおりはさむボタン表示
        }else{
            //お気に入り登録済、押したら解除する
            try! self.realm.write {
                self.realm.delete(self.favModel)
                self.favbtn.setTitle("☆", for: .normal)
                self.favModel = Favorites()
                if var favorites : Results<Favorites> = self.realm.objects(Favorites.self){
print("naka")
                    print(favorites)
                }
            }
            if var favorites : Results<Favorites> = self.realm.objects(Favorites.self){
                print("soto")
                print(favorites)
            }

        }
        
        
    }

    @objc open func addBookmark(sender : UIButton) {
        print("bookmark: \(self.novelModel.bookmark)")
        print("nowOffsety: \(self.nowOffsety)")
        try! self.realm.write() {
            self.novelModel.bookmark = self.nowOffsety
        }
    }

    var scrollView : UIScrollView = UIScrollView()
    var textView : UITextView = UITextView()
    
    func setScroll(){
        self.scrollView.backgroundColor = UIColor.white
        
        // 表示窓のサイズと位置を設定
        self.scrollView.center = self.view.center
        self.textView.isEditable = false
        self.textView.font = UIFont.systemFont(ofSize: 30)
        self.scrollView.addSubview(self.textView)
        self.scrollView.delegate = self as! UIScrollViewDelegate
        let fitsize : CGSize = (self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
        print(fitsize)
        self.scrollView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight )
        self.textView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: fitsize.height)
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight )
        self.textView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )
        self.view.addSubview(self.scrollView)
        self.textView.text = "お待ち下さい"
        self.setFooter()

    }

    var isLoading : Bool = false
    var nowOffsety : CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.footer.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        self.menubtn.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        self.favbtn.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        self.bkbtn.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        self.nowOffsety = scrollView.contentOffset.y
        
        var isBouncing : Bool = false
//        print("scrollViewDidScroll \(scrollView.bounces)")
//        isBouncing = (scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height)) > 0.9
        isBouncing = ((scrollView.contentSize.height - scrollView.bounds.size.height) - scrollView.contentOffset.y ) < 3000

        if(self.isLoading == true){
            return
        }
//        print("\(scrollView.contentOffset.y) / \(scrollView.bounds.size.height) \(scrollView.contentSize.height)")
//        print((scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height)))
//        print((scrollView.contentSize.height - scrollView.bounds.size.height) - scrollView.contentOffset.y  )

        if(isBouncing){
            if(self.novelModel.last_read_no >= self.novelModel.general_all_no){
                return
            }
            self.isLoading = true
            self.getNovelText(nnumber: self.novelModel.nnumber, no: self.novelModel.last_read_no + 1)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.footer.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.menubtn.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.favbtn.backgroundColor = UIColor(red:  0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.bkbtn.backgroundColor = UIColor(red:  0.8, green: 0.8, blue: 0.8, alpha: 1.0)

        print("scrollViewDidEndDecelerating")
        print(scrollView.bounces)
        print(scrollView.bounds.size.height)
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.footer.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.menubtn.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.favbtn.backgroundColor = UIColor(red:  0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.bkbtn.backgroundColor = UIColor(red:  0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        print("scrollViewDidEndDragging")
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("scrollViewWillEndDragging")
//        print(velocity)
//        print(targetContentOffset)
    }

    func endsetText(){
        let fitsize : CGSize = (self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
        print(fitsize)
        self.scrollView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight)
        self.textView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: fitsize.height)
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )
        self.textView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )
    }
    
    func getNovelNumber(){
        self.textView.text = "本文取得中……"
        
        var url : String = "https://ncode.syosetu.com/"
        url.append((ndetail.ncode as NSString).lowercased)
        url.append("/")
        Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//print(utf8Text)
                var ans: [String] = []
                utf8Text.pregMatche(pattern: "ncode/(\\d+)/", matches: &ans)
                print(ans[1])
                self.novelModel.ncode = self.ndetail.ncode
                self.novelModel.nnumber = Int(ans[1])!
                self.novelModel.title = self.ndetail.title
                self.novelModel.story = self.ndetail.story
                self.novelModel.general_all_no = self.ndetail.general_all_no
                self.novelModel.last_read_no = 0
                
                try! self.realm.write {
                    self.realm.add(self.novelModel)
                }

                do {
                    self.textView.text = "本文取得準備中"
                    self.isLoading = true
                    self.getNovelText(nnumber: self.novelModel.nnumber, no: 1)
                } catch {
                    print(error)
                }
            }
        }

    }

    func getNovelTextByRealm(nnumber : Int , no : Int = 0, last_no : Int) {

        if var stories : Results<Stories> = self.realm.objects(Stories.self).filter("ncode ='\(self.ndetail.ncode)'").sorted(byKeyPath: "no", ascending: true){
            for story in stories {
                print("No: \(story.no)")
                if(story.no == 1){
                    self.noveltext.append("\n\n\(self.novelModel.title)(\(story.no)/\(self.novelModel.general_all_no))➡\n\n")
                }else{
                    self.noveltext.append("\n\n\(story.no)/\(self.novelModel.general_all_no))➡\n\n")
                }
                self.noveltext.append(story.story)
                self.noveltext.append("\n\n--------⬅\(story.no)/\(self.novelModel.general_all_no) --------\n\n")
print("realmに保存：\(story.no)")
            }
            self.textView.font = UIFont.systemFont(ofSize: 20)
            self.textView.text = self.noveltext
            //更新があれば次の一話取得。その後は遅延ロードに任せる
print("現在読んでるところ\(no)全話\(last_no)")

            let isbookmark = true
            if(isbookmark){
                self.endsetText()
                //一番下
//                let a  = CGPoint(x:0, y:(self.scrollView.contentSize.height - self.scrollView.bounds.size.height))
                let a  = CGPoint(x:0, y:self.novelModel.bookmark+62)
                print("\(a)に移動")
                self.scrollView.setContentOffset(a, animated: false)
            }

            if(last_no > no){
            }else{
                self.endsetText()
                print("更新はありません")
            }
        }
    }


    var noveltext : String = ""
    func getNovelText(nnumber : Int , no : Int = 0) {
//        if(self.isLoading == true){
//            return
//        }

        var url : String = "https://novel18.syosetu.com/txtdownload/dlstart/ncode/"
        url.append(String(nnumber))
        url.append("/?no=")
        url.append(String(no))
        url.append("&hankaku=0&code=utf-8&kaigyo=crlf")

        print(url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in
                self.isLoading = true

                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("----response.data")
                    print(response.error)
                    print(response.response)
                    print("response.data----")
                    do {
                        if(response.error == nil){
                            print("no:\(no)")
                            if(no == 1){
                                self.noveltext.append("\n\n\(self.novelModel.title)(\(no)/\(self.novelModel.general_all_no))➡\n\n")
                            }else{
                                self.noveltext.append("\n\n\(no)/\(self.novelModel.general_all_no))➡\n\n")
                            }
                            self.noveltext.append(utf8Text)
                            
                            //新規Storyを追加
                            var newStory : Stories = Stories()
                            newStory.ncode = self.novelModel.ncode
                            newStory.nnumber = self.novelModel.nnumber
                            newStory.no = no
                            newStory.story = utf8Text
                            
                            // データを更新
                            try! self.realm.write() {
                                self.novelModel.last_read_no = no
                            }
                            try! self.realm.write() {
                                self.realm.add(newStory)
                            }
                            print(String(self.ndetail.general_all_no)+" : "+String(no))
                            self.textView.font = UIFont.systemFont(ofSize: 20)
                            self.textView.text = self.noveltext
                            self.endsetText()
                            
                            self.isLoading = false
                            print("1self.isLoading:\(self.isLoading)")
                            if(no >= self.ndetail.general_all_no || no >= 3){
                                return
                            }
                        }


                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func getNovel(){
        print("self.isLoading:\(self.isLoading)")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/narrowreader5.realm"
        print(path)
        let url = NSURL(fileURLWithPath: path)
        self.realm = try! Realm(fileURL: url as URL)
        self.textView.text = self.ndetail.title
        if let hit = self.realm.objects(Novels.self).filter("ncode ='\(self.ndetail.ncode)'").first{
            print("getNovel 存在チェック")
            //保存されてるnoチェック
            print("保存してる最終章番号:\(hit.last_read_no)")
            print("最終更新話:\(self.ndetail.general_all_no)")
            //最新情報に更新
            try! self.realm.write {
                hit.title = self.ndetail.title
                hit.story = self.ndetail.story
                hit.general_all_no = self.ndetail.general_all_no
                self.novelModel = hit
                print(self.novelModel)
                self.getNovelTextByRealm(nnumber:self.novelModel.nnumber, no: self.novelModel.last_read_no, last_no: self.novelModel.general_all_no)
            }

            //hitした場合お気に入りかも見る
            if let fav = self.realm.objects(Favorites.self).filter("ncode ='\(self.ndetail.ncode)'").first{
                self.favModel = fav
                if(self.favModel.nnumber != 0){
                    print(self.favModel)
                    self.favbtn.setTitle("★", for: .normal)
                }
                print(self.favModel)
            }
            
        }else{
            //新規なのでnnumberから新規追加
            self.getNovelNumber()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

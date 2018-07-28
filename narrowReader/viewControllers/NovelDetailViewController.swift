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

class NovelDetailViewController: narrowBaseViewController, UIScrollViewDelegate {

    private var realm: Realm!
    var ndetail : novelDetai = novelDetai()
    var novelModel : Novels = Novels()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ndetail.title

        self.setScroll()
        self.getNovel()
    }

    var scrollView : UIScrollView = UIScrollView()
    var textView : UITextView = UITextView()
    
    func setScroll(){
        self.scrollView.backgroundColor = UIColor.white
        
        // 表示窓のサイズと位置を設定
        self.scrollView.center = self.view.center
//        self.endsetText()
        self.textView.isEditable = false
        self.textView.font = UIFont.systemFont(ofSize: 30)
        self.scrollView.addSubview(self.textView)
        self.scrollView.delegate = self as! UIScrollViewDelegate
        let fitsize : CGSize = (self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
        print(fitsize)
        self.scrollView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight)
        self.textView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: fitsize.height)
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight )
        self.textView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: fitsize.height )
        self.view.addSubview(self.scrollView)
        self.textView.text = "お待ち下さい"
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

//        NSLayoutConstraint.activate([
//            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
////            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
////            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
//        ])

//        NSLayoutConstraint.activate([
//            self.textView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
//            self.textView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
////            self.textView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
////            self.textView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0),
//        ])

    }

    var isLoading : Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var isBouncing : Bool = false
//        print("scrollViewDidScroll \(scrollView.bounces)")
//        isBouncing = (scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height)) > 0.9
        isBouncing = ((scrollView.contentSize.height - scrollView.bounds.size.height) - scrollView.contentOffset.y ) < 10000

        if(self.isLoading == true){
            return
        }
        print("\(scrollView.contentOffset.y) / \(scrollView.bounds.size.height) \(scrollView.contentSize.height)")
//        print((scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height)))
        print((scrollView.contentSize.height - scrollView.bounds.size.height) - scrollView.contentOffset.y  )

        if(isBouncing){
            self.isLoading = true
            if(self.novelModel.last_read_no >= self.novelModel.general_all_no){
                return
            }
print("ここ何度も来てる？")
            self.getNovelText(nnumber: self.novelModel.nnumber, no: self.novelModel.last_read_no + 1)
        }
        
        
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
                self.noveltext.append(String(story.no))
                self.noveltext.append("\n\n--------\(story.no)/\(self.novelModel.general_all_no)--------\n\n")
                self.noveltext.append(story.story)
print("realmに保存：\(story.no)")
            }
            self.textView.font = UIFont.systemFont(ofSize: 12)
            self.textView.text = self.noveltext
            //更新があれば次の一話取得。その後は遅延ロードに任せる
print("現在読んでるところ\(no)全話\(last_no)")
            if(last_no > no){
                self.isLoading = true
                self.getNovelText(nnumber: nnumber, no: no+1, scrollend: true  )
            }else{
                self.endsetText()
                print("更新はありません")
            }
        }
    }


    var noveltext : String = ""
    func getNovelText(nnumber : Int , no : Int = 0, scrollend : Bool = false) {
        var url : String = "https://novel18.syosetu.com/txtdownload/dlstart/ncode/"
        url.append(String(nnumber ))
        url.append("/?no=")
        url.append(String(no))
        url.append("&hankaku=0&code=utf-8&kaigyo=crlf")

        print(url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    do {
                        self.noveltext.append("\n\n--------\(no)/\(self.ndetail.general_all_no)--------\n\n")
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
                        self.textView.font = UIFont.systemFont(ofSize: 12)
                        self.textView.text = self.noveltext
                        self.endsetText()

                        if(scrollend){
                            let a  = CGPoint(x:0, y:(self.scrollView.contentSize.height - self.scrollView.bounds.size.height))
                            print("\(a)に移動")
                            self.scrollView.setContentOffset(a, animated: false)
                        }



                        self.isLoading = false
                        if(no >= self.ndetail.general_all_no || no >= 3){
                            return
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func getNovel(){

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/narrowreader.realm"
        print(path)
        let url = NSURL(fileURLWithPath: path)
        self.realm = try! Realm(fileURL: url as URL)
        if let hit = self.realm.objects(Novels.self).filter("ncode ='\(self.ndetail.ncode)'").first{
            print("getNovel 存在チェック")
            //保存されてるnoチェック
            print("保存してる最終章番号:\(hit.last_read_no)")
            print("最終更新話:\(self.ndetail.general_all_no)")
            print(url)
            //最新情報に更新

            try! self.realm.write {
                hit.title = self.ndetail.title
                hit.story = self.ndetail.story
                hit.general_all_no = self.ndetail.general_all_no
                self.novelModel = hit
                print(self.novelModel)
                self.getNovelTextByRealm(nnumber:self.novelModel.nnumber, no: self.novelModel.last_read_no, last_no: self.novelModel.general_all_no)
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

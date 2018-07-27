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
        self.scrollView.frame.size = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight * 1.0 )
        self.scrollView.contentSize = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight * 1.0 )
        self.scrollView.center = self.view.center
        self.textView.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight * 1.0)
        self.textView.text = "お待ち下さい"
        self.textView.isEditable = false
        self.textView.font = UIFont.systemFont(ofSize: 30)

print(self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
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

    func getNovelNumber(){
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
                self.noveltext.append("\n--------------\n")
                self.noveltext.append(story.story)
            }
            self.textView.font = UIFont.systemFont(ofSize: 12)
            self.textView.text = self.noveltext
            print(self.textView.sizeThatFits(CGSize(width: self.frameWidth * 1.0 , height: CGFloat.greatestFiniteMagnitude)))
            //次の1話を取得。それが最後まで読めたらその次の1話を取得
        }
    }


    var noveltext : String = ""
    func getNovelText(nnumber : Int , no : Int = 0) {
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
                        var waitingtext : String = "本文取得中……("
                        waitingtext.append(String(no))
                        waitingtext.append(" / ")
                        waitingtext.append(String(self.ndetail.general_all_no))
                        waitingtext.append(")")
                        self.textView.text = waitingtext
                        self.noveltext.append("\n\(no)\n")
                        self.noveltext.append(utf8Text)

                        //新規Storyを追加
                        var newStory : Stories = Stories()
                        newStory.ncode = self.novelModel.ncode
                        newStory.nnumber = self.novelModel.nnumber
                        newStory.no = no
                        newStory.story = utf8Text

                        // データを更新
                        try! self.realm.write() {
                            self.realm.add(newStory)
                            self.novelModel.last_read_no = no
                        }
                        print("self.ndetail.general_all_no")
print(String(self.ndetail.general_all_no)+" : "+String(no))
                        if(no >= self.ndetail.general_all_no){
                            self.textView.font = UIFont.systemFont(ofSize: 12)
                            self.textView.text = self.noveltext
                            return
                        }
//再帰やめる
                        self.getNovelText(nnumber: nnumber,no:no+1)
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
            self.getNovelTextByRealm(nnumber:self.novelModel.nnumber, no: 0, last_no: self.ndetail.general_all_no)

        }else{
            //新規なのでnnumberから新規追加
            self.getNovelNumber()
        }
        

        
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81
        //https://novel18.syosetu.com/txtdownload/dlstart/ncode/1250059/?no=1&hankaku=0&code=utf-8&kaigyo=crlf
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&nocgenre=3&word=%E7%9B%A3%E7%A6%81
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

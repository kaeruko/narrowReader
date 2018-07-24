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
    var newNovel : Novels = Novels()

    override func viewDidLoad() {
        super.viewDidLoad()


        self.setScroll()
        self.getNovel()



        return

        let file_name = "textdl.txt"
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            print(dir)
            let path_file_name = dir.appendingPathComponent( file_name )
            do {
                
                let searchresult: String = try String( contentsOf: path_file_name, encoding: String.Encoding.utf8 )
                print(searchresult)
                var sr: Data =  searchresult.data(using: String.Encoding.utf8)!
                
                self.view.addSubview(scrollView)
                
                
            } catch {
                //エラー処理
            }
        }

    }

    var scrollView : UIScrollView = UIScrollView()
    var textLabel : UITextView = UITextView()
    
    func setScroll(){
        self.scrollView.backgroundColor = UIColor.white
        
        // 表示窓のサイズと位置を設定
        self.scrollView.frame.size = CGSize(width: self.frameWidth * 1.0 , height: self.frameHeight * 1.0 )
        self.scrollView.center = self.view.center
        self.textLabel.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 1.0, height: self.frameHeight * 1.0)
        self.textLabel.text = "お待ち下さい"
        self.textLabel.font = UIFont.systemFont(ofSize: 30)

        self.scrollView.addSubview(self.textLabel)
        // Delegate を設定
        self.scrollView.delegate = self as! UIScrollViewDelegate
        self.view.addSubview(scrollView)
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
                self.newNovel.ncode = self.ndetail.ncode
                self.newNovel.nnumber = Int(ans[1])!
                self.newNovel.title = self.ndetail.title
                self.newNovel.story = self.ndetail.story
                self.newNovel.general_all_no = self.ndetail.general_all_no
                try! self.realm.write {
                    self.realm.add(self.newNovel)
                }

                do {
                    self.textLabel.text = "本文取得準備中"
                    self.getNovelText(nnumber: self.newNovel.nnumber, no: 1)
                } catch {
                    print(error)
                }
            }
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
                        self.textLabel.text = waitingtext
                        self.noveltext.append("\n\(no)\n")
                        self.noveltext.append(utf8Text)
print("self.ndetail.general_all_no")
print(String(self.ndetail.general_all_no)+" : "+String(no))
                        if(no >= self.ndetail.general_all_no){
                            self.textLabel.font = UIFont.systemFont(ofSize: 12)
                            self.textLabel.text = self.noveltext
                            return
                        }
                        self.getNovelText(nnumber: nnumber,no:no+1)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func getNovel(){
        let hit = self.realm.objects(Novels.self).filter("ncode ="+self.ndetail.ncode)
print(hit)
        //DB保存されてるか
        if(hit.count > 0){
            print(hit.value(forKey: "title"))
        }else{
            //nnumber取得
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

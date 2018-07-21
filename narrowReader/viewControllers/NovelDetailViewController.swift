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

    var ndetail : novelDetai = novelDetai()
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
        
        self.scrollView.addSubview(self.textLabel)
        // Delegate を設定
        self.scrollView.delegate = self as! UIScrollViewDelegate
    }

    func getNovelNumber(){
        var url : String = "https://ncode.syosetu.com/"
        url.append((ndetail.ncode as NSString).lowercased)
        url.append("/")
        Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var ans: [String] = []
                utf8Text.pregMatche(pattern: "ncode/(\\d+)/", matches: &ans)
                print(ans[1])
                do {
                    
                    self.getNovelText(nnumber: Int(ans[1])!, no: 1)
                } catch {
                    print(error)
                }
            }
        }

    }

    func getNovelText(nnumber : Int , no : Int = 0){
        var url : String = "https://novel18.syosetu.com/txtdownload/dlstart/ncode/"
        url.append(String(nnumber ))
        url.append("/?no=")
        url.append(String(no))
        url.append("&hankaku=0&code=utf-8&kaigyo=crlf")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    do {
                        
                        self.getNovelText(nnumber : nnumber, no : no+1)
                    } catch {
                        print(error)
                    }
                }
            }
            

        }

    }
    
    func getNovel(){
        //何ページあるか
        self.getNovelNumber()
        //nnumber取得
        

        
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81
        //https://novel18.syosetu.com/txtdownload/dlstart/ncode/1250059/?no=1&hankaku=0&code=utf-8&kaigyo=crlf
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&nocgenre=3&word=%E7%9B%A3%E7%A6%81

        print(self.ndetail.title)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

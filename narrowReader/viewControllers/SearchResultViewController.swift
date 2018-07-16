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

class SearchResultViewController: UIViewController, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.novelcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> NovelTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath) as! NovelTableViewCell
        cell.title?.text = self.results?[indexPath.row]["title"] as? String
        cell.story?.text = self.results?[indexPath.row]["story"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        //画面遷移
    }

    var nnumber:Int?
    var search_word:String?
    var novelcount : Int = 0
    var results:[Dictionary<String,Any?>]?=[]

    
    override func viewDidLoad() {
        // ナビゲーションバーの設定
        navigationController?.navigationBar.backgroundColor = UIColor.green
        navigationController?.setNavigationBarHidden(false, animated: false)
        // 遷移先でナビゲーションバーに戻るボタンを表示させない
        navigationItem.setHidesBackButton(true, animated: false)

        self.title = "検索結果"
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.searchByApi()
        print(self.search_word)
        let backBtn = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(self.backBtnTapped))
        self.navigationItem.leftBarButtonItem = backBtn

    }

    @objc func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    

    
    open func searchByApi() {
        
        let file_name = "search.txt"
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
print(dir)
            let path_file_name = dir.appendingPathComponent( file_name )
            do {
                
                let searchresult: String = try String( contentsOf: path_file_name, encoding: String.Encoding.utf8 )
                print(searchresult)
                var sr: Data =  searchresult.data(using: String.Encoding.utf8)!
                
                // パースする
                let items:NSArray = try JSONSerialization.jsonObject(with: sr, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                //                    print(items[1])
                for n in items {
                    let i = n as! Dictionary<String,Any?>
                    if((i["title"] == nil)){continue}
                    self.results?.append(["title": i["title"], "ncode" : i["ncode"], "general_all_no":i["general_all_no"], "novel_type": i["novel_type"],"story": i["story"] ])
                    
                }
                self.novelcount = (self.results?.count)!
                
            } catch {
                //エラー処理
            }
        }
        
        for n in self.results! {
            let i = n as! Dictionary<String,Any?>
            print(i)
            print(i["title"])
            print(i["story"])
        }
        
        return;
        
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81
        //https://novel18.syosetu.com/txtdownload/dlstart/ncode/1250059/?no=1&hankaku=0&code=utf-8&kaigyo=crlf
        Alamofire.request("https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81", headers:["Cookie": "over18=yes;"]).responseJSON { response in      //連載
            
            if let json = response.result.value {
                //                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                let regex = try! NSRegularExpression(pattern: "S(w+)ift", options: [])
                var searchresult: Data =  utf8Text.data(using: String.Encoding.utf8)!
                do {
                    // パースする
                    let items:NSArray = try JSONSerialization.jsonObject(with: searchresult, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    //                    print(items[1])
                    let i = items[1] as! Dictionary<String,Any?>
                    //                    let i = items[1] as! Dictionary<Int, [String:String]?>
                    print(i["general_all_no"])
                    
                    
                    //                    let items:Dictionary<Int, Any?> = try JSONSerialization.jsonObject(with: personalData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<Int, Any?>
                    //                    let i = items[0] as! [String:String]
                    //                    let location = users[0]["user_location"] ?? "(unknown)"
                    //                    print(i)
                    //
                    //                    print(items[1]["keyword"]) // メンバid Intにキャスト
                    //
                    //                    if let i = items.value as? [String:[String]]
                    //                    {
                    //                        print(i[1]["keyword"]) // メンバid Intにキャスト
                    //                    }
                    //                    print(items["name"] as! String) // メンバname Stringにキャスト
                } catch {
                    print(error)
                }
            }
        }
    }
    

}

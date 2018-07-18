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

class SearchResultViewController: narrowPageViewController,  UITableViewDelegate, UITableViewDataSource {
    
    
    var nnumber:Int?
    var search_word:String?
    var novelcount : Int = 0
    var results:[Dictionary<String,Any?>]?=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "検索結果"
        self.view.backgroundColor = UIColor.white
        self.searchByApi()
        print(self.search_word)
    }
    
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.novelcount
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NovelTableViewCell.self), for: indexPath) as! NovelTableViewCell
        cell.summary?.font = UIFont.systemFont(ofSize: 12)
        cell.summary?.minimumScaleFactor = 15.0/15.0;
        cell.summary?.adjustsFontSizeToFitWidth = true
        cell.summary?.numberOfLines = 0
        cell.summary?.text = self.results?[indexPath.row]["story"] as? String
        cell.title?.text = self.results?[indexPath.row]["title"] as? String
        cell.layoutIfNeeded()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "検索結果"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    open func searchByApi() {
        
//        let file_name = "search.txt"
//
//        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
//            //print(dir)
//            let path_file_name = dir.appendingPathComponent( file_name )
//            do {
//
//                let searchresult: String = try String( contentsOf: path_file_name, encoding: String.Encoding.utf8 )
//                //                print(searchresult)
//                var sr: Data =  searchresult.data(using: String.Encoding.utf8)!
//
//                // パースする
//                let items:NSArray = try JSONSerialization.jsonObject(with: sr, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
//                //                    print(items[1])
//                for n in items {
//                    let i = n as! Dictionary<String,Any?>
//                    if((i["title"] == nil)){continue}
//                    self.results?.append(["title": i["title"], "ncode" : i["ncode"], "general_all_no":i["general_all_no"], "novel_type": i["novel_type"],"story": i["story"] ])
//
//                }
//                self.novelcount = (self.results?.count)!
//
//            } catch {
//                //エラー処理
//            }
//        }
        
//        for n in self.results! {
//            let i = n as! Dictionary<String,Any?>
//            //            print(i)
//            //            print(i["title"])
//            print(i["story"])
//        }
        
        
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81
        //https://novel18.syosetu.com/txtdownload/dlstart/ncode/1250059/?no=1&hankaku=0&code=utf-8&kaigyo=crlf
        Alamofire.request("https://api.syosetu.com/novel18api/api/?libtype=1&out=json&nocgenre=2&word=%E7%9B%A3%E7%A6%81", headers:["Cookie": "over18=yes;"]).response { response in      //連載
            
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                let regex = try! NSRegularExpression(pattern: "S(w+)ift", options: [])
                var searchresult: Data =  utf8Text.data(using: String.Encoding.utf8)!
                do {
                    // パースする
                    let items:NSArray = try JSONSerialization.jsonObject(with: searchresult, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray

                    for n in items {
                        let i = n as! Dictionary<String,Any?>
                        print(i["story"])

                        if((i["title"] == nil)){continue}
                        self.results?.append(["title": i["title"], "ncode" : i["ncode"], "general_all_no":i["general_all_no"], "novel_type": i["novel_type"],"story": i["story"] ])
    
                    }
                    self.novelcount = (self.results?.count)!


                    let myTableView = UITableView(frame: self.view.frame, style: .plain)
                    myTableView.estimatedRowHeight = UITableViewAutomaticDimension
                    myTableView.rowHeight = UITableViewAutomaticDimension
                    myTableView.flashScrollIndicators()
                    myTableView.delegate      =   self as UITableViewDelegate
                    myTableView.dataSource    =   self as! UITableViewDataSource
                    myTableView.register(NovelTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(NovelTableViewCell.self))
                    self.view.addSubview(myTableView)

                } catch {
                    print(error)
                }
            }
        }
    }
    
    
}

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
    
    var condition : searchCondition = searchCondition()
    var nnumber:Int?
    var search_word:String?
    var novelcount : Int = 0
    var results:[Dictionary<String,Any?>]?=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "検索結果"
        self.view.backgroundColor = UIColor.white
        self.searchByApi()
    }
    
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
        cell.summary?.adjustsFontSizeToFitWidth = true
        cell.summary?.numberOfLines = 0
        cell.summary?.text = self.resultRow[indexPath.row].story as? String
        cell.title?.text = self.resultRow[indexPath.row].title as? String
        cell.title?.font = UIFont.systemFont(ofSize: 20)
        cell.length?.text = "\(self.resultRow[indexPath.row].length)文字"
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = NovelDetailViewController()
        next.ndetail = self.resultRow[indexPath.row]
        self.navigationController?.pushViewController(next, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var TableView : UITableView = UITableView()

    open func setTable() {

        self.TableView.flashScrollIndicators()
        self.TableView.tableFooterView = UIView()
        self.TableView.delegate      =   self as UITableViewDelegate
        self.TableView.dataSource    =   self as! UITableViewDataSource
        self.TableView.register(NovelTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(NovelTableViewCell.self))
        self.view.addSubview(self.TableView)
        self.TableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.TableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.TableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.TableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.TableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

    }
    
    
    var resultRow : [novelDetai] = []
    open func searchByApi() {
        var url : String = "https://api.syosetu.com/novel18api/api/?maxtime=200&lim=20&libtype=1&out=json&nocgenre=3&word="
        url.append(self.condition.searchWord.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.alphanumerics )!)
        url.append("&notword="+self.condition.notword)
        
        //https://api.syosetu.com/novel18api/api/?libtype=1&out=json&word=%E7%9B%A3%E7%A6%81
        //https://novel18.syosetu.com/txtdownload/dlstart/ncode/1250059/?no=1&hankaku=0&code=utf-8&kaigyo=crlf
        Alamofire.request(url, headers:["Cookie": "over18=yes;"]).response { response in

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var searchresult: Data =  utf8Text.data(using: String.Encoding.utf8)!
                do {
                    // パースする
                    let items:NSArray = try JSONSerialization.jsonObject(with: searchresult, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray

                    for n in items {
                        let i = n as! Dictionary<String,Any?>

                        if((i["title"] == nil)){continue}
                        var ndetail : novelDetai = novelDetai()
                        ndetail.ncode = i["ncode"] as! String
                        ndetail.writer = i["writer"] as! String
                        ndetail.global_point = i["global_point"] as! Int
                        ndetail.keyword = i["keyword"] as! String
                        ndetail.genre = i["nocgenre"] as! Int
                        ndetail.title = i["title"] as! String
                        ndetail.fav_novel_cnt = i["fav_novel_cnt"] as! Int
                        ndetail.all_point = i["all_point"] as! Int
                        ndetail.end = i["end"] as! Int
                        ndetail.all_hyoka_cnt = i["all_hyoka_cnt"] as! Int
                        ndetail.review_cnt = i["review_cnt"] as! Int
                        ndetail.general_all_no = i["general_all_no"] as! Int
                        //                    ndetail.novelupdated_at = i["novelupdated_at"] as! Date
                        //                    ndetail.general_lastup = i["general_lastup"] as! Date
                        //                    ndetail.general_firstup = i["general_firstup"] as! Date
                        ndetail.novel_type = i["novel_type"] as! Int
                        ndetail.length = i["length"] as! Int as! Int
                        ndetail.story = i["story"] as! String
                        self.resultRow.append(ndetail)
                    }
                    self.setTable()
                    self.novelcount = (self.resultRow.count)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    

}

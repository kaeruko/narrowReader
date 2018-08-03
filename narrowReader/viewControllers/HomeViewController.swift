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

    private var realm: Realm!
    var novelcount : Int = 0
    var resultRow : [Novels] = []
    var TableView : UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var did : Bool = false
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear \(self.did)")
        super.viewWillAppear(animated)
        if(self.did == false) {
            self.title = "narrow-reader"
            self.view.backgroundColor = UIColor.white
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.getNovelRist()
            self.did = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.did = false
        print("viewWillDisappear \(self.did)")
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = NovelDetailViewController()
        next.ndetail.ncode = self.resultRow[indexPath.row].ncode
        next.ndetail.title = self.resultRow[indexPath.row].title
        next.ndetail.story = self.resultRow[indexPath.row].story
        next.ndetail.general_all_no = self.resultRow[indexPath.row].general_all_no

        self.navigationController?.pushViewController(next, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func getNovelRist(){
        self.resultRow = []
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/narrowreader4.realm"
        print(path)
        let url = NSURL(fileURLWithPath: path)
        self.realm = try! Realm(fileURL: url as URL)
        
        if var favorites : Results<Favorites> = self.realm.objects(Favorites.self){
print(favorites)
            for fav in favorites {
                print(fav)
                if var novel : Novels = self.realm.objects(Novels.self).filter("ncode ='\(fav.ncode)'").first{
                    self.resultRow.append(novel)
                }
            }
            self.novelcount = self.resultRow.count
            self.setTable()
        }else{
print("koko")
            self.novelcount = 0
            self.setTable()
        }
    }

    
    func setTable() {
        self.TableView.flashScrollIndicators()
        self.TableView.tableFooterView = UIView()
        self.TableView.delegate      =   self as UITableViewDelegate
        self.TableView.dataSource    =   self as! UITableViewDataSource
        self.TableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        self.view.addSubview(self.TableView)
        self.TableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.TableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.TableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.TableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.TableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        self.TableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.novelcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
print("cellForRowAt")
        print(self.resultRow[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.resultRow[indexPath.row].title as? String
        return cell
    }
    
    


}

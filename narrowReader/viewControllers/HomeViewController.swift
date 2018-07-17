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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "小説家にnarrow"
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


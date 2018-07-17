//
//  ViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/18.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var articles: Array<Article>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(NovelTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(NovelTableViewCell.self))

        articles = [
            Article(title: "私わたくしはその人を常に先生と呼んでいた。だからここでもただ先生と書くだけで本名は打ち明けない。", userName: "夏目漱石"),
            Article(title: "この書の世に出づるにいたりたるは、函館にある秦慶治氏、及び信濃にある神津猛氏のたまものなり。労作終るの日にあたりて、このものがたりを二人の恩人のまへにさゝぐ。", userName: "島崎藤村"),
            Article(title: "散文に二種あると考へてゐるが、一を小説、他を作文とかりに言つておく。", userName: "坂口安吾"),
            Article(title: "機敏な晩熟児といふべき此の男が、現に存するのだから僕は機敏な晩熟児が如何にして存るママかその様を語らうと思ふ。", userName: "中原中也")
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return articles!.count
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        let cell: NovelTableViewCell = tableView?.dequeueReusableCell(withIdentifier: NSStringFromClass(NovelTableViewCell.self), for: indexPath as IndexPath) as! NovelTableViewCell

        cell.article = articles?[indexPath.row]
        cell.layoutIfNeeded()
        return cell;
    }
}

//
//  NovelDetailViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/18.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class NovelDetailViewController: narrowBaseViewController, UIScrollViewDelegate {

    var ncode : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let file_name = "textdl.txt"
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            print(dir)
            let path_file_name = dir.appendingPathComponent( file_name )
            do {
                
                let searchresult: String = try String( contentsOf: path_file_name, encoding: String.Encoding.utf8 )
                print(searchresult)
                var sr: Data =  searchresult.data(using: String.Encoding.utf8)!
                
                let scrollView = UIScrollView()
                scrollView.backgroundColor = UIColor.white
                
                // 表示窓のサイズと位置を設定
                scrollView.frame.size = CGSize(width: self.frameWidth * 0.9 , height: self.frameHeight * 0.7 )
                scrollView.center = self.view.center
//                scrollView.contentSize = CGSize(width: self.frameWidth * 0.9, height: self.frameHeight * 3)
                // スクロールの跳ね返り
//                scrollView.bounces = false
                
                // スクロールバーの見た目と余白
//                scrollView.indicatorStyle = .white
//                scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                
                let label = UITextView()
                label.text = searchresult
                label.frame = CGRect(x: 0 , y: 0, width: self.frameWidth * 0.9, height: self.frameHeight * 0.7)

                scrollView.addSubview(label)
                // Delegate を設定
                scrollView.delegate = self as! UIScrollViewDelegate
                self.view.addSubview(scrollView)
                
                
            } catch {
                //エラー処理
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

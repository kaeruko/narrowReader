//
//  NovelModalViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/19.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit


protocol NovelModalViewControllerDelegate {
    func novelModalDidFinished(modaltext: String)
}


class NovelModalViewController: narrowBaseViewController, UIScrollViewDelegate {
    
    var ncode : String = ""
    var ntitle : String = ""
    var nstory : String = ""
    var general_all_no: Int = 0  //general_all_no 全掲載部分数です。短編の場合は1です。
    var novel_type: Int = 0 //連載の場合は1、短編の場合は2
    var general_firstup: Date  = Date()
    var general_lastup: Date  = Date()
    var keyword : String = ""
    var writer : String = ""
    
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

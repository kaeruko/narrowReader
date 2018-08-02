//
//  ErrorModalViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/08/01.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class ErrorMessage{
    var errortext : String = ""
}

protocol ErrorModalViewControllerDelegate {
    func modalDidFinished(condition: String)
}

class ErrorModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

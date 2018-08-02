//
//  MenuModalViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/30.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit


protocol MenuModalViewControllerDelegate {
    func modalDidFinished(condition: String)
}


class MenuModalViewController: UIViewController {

    var delegate: MenuModalViewControllerDelegate! = nil

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SearchPresentationController(presentedViewController: presented, presenting: presenting)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func createUIView(uiview : UIView) -> UIView{
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uiview)
        return uiview
    }
    
    open func createLabel() -> UILabel{
        var label = UILabel(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        label = self.createUIView(uiview: label) as! UILabel
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    open func createButton() -> UIButton{
        var btn = UIButton(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        btn = self.createUIView(uiview: btn) as! UIButton
        return btn
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

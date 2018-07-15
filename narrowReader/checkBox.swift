//
//  checkBox.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/14.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
//    let checkedImage = UIImage(named: "ico_check_on")! as UIImage
//    let uncheckedImage = UIImage(named: "ico_check_off")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
print("check")
                //                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
print("not check")
//                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    func initWithCoder(){
        print("initWithCoder")
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    

    @objc func buttonClicked(sender: UIButton) {
        print("buttonClicked")
        if sender == self {
            isChecked = !isChecked
        }
    }
}


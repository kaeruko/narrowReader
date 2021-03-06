//
//  HomeViewController
//  narrowReader
//
//  Created by kaeruko on 2018/07/11.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class narrowBaseViewController: UIViewController {
    
    lazy var frameWidth : CGFloat = self.view.frame.width
    lazy var frameHeight : CGFloat = self.view.frame.height

    open func createUIView(uiview : UIView) -> UIView{
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uiview)
        return uiview
    }
    
    open func createButton() -> UIButton{
        var btn = UIButton(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        btn = self.createUIView(uiview: btn) as! UIButton
        return btn
    }

    open func createLabel() -> UILabel{
        var label = UILabel(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        label = self.createUIView(uiview: label) as! UILabel
        label.adjustsFontSizeToFitWidth = true
        return label
    }

    open func layoutElement(target : UIView, element : UIView, attr: NSLayoutAttribute, constant: CGFloat, mult: CGFloat = 1.0){
        target.addConstraint(Constraint(item:element, attr,    to: target, attr,    constant: constant,  multiplier:mult))
    }

    public func Constraint(item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item:       item,
            attribute:  attr,
            relatedBy:  relate,
            toItem:     to,
            attribute:  attrTo,
            multiplier: multiplier,
            constant:   constant
        )
        ret.priority = priority
        return ret
    }
    
}


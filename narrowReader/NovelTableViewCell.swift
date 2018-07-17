//
//  NovelTableViewCell.swift
//  single
//
//  Created by kaeruko on 2018/07/08.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class NovelTableViewCell: UITableViewCell {
    
    var title: UILabel!
    
    var story: UILabel!
    
    open func createUIView(uiview : UIView) -> UIView{
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(uiview)
        return uiview
    }
    

    open func createLabel() -> UILabel{
        var label = UILabel(frame:CGRect(x: 10, y: 10, width: self.frame.width * 0.8 , height: 30))
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

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.title = self.createLabel()
        self.story = self.createLabel()
        self.layoutElement(target: self, element: self.title, attr: NSLayoutAttribute.top, constant: 20)
        self.layoutElement(target: self, element: self.title, attr: NSLayoutAttribute.centerX, constant: 0)

        self.layoutElement(target: self, element: self.story, attr: NSLayoutAttribute.top, constant: 40)
        self.layoutElement(target: self, element: self.story, attr: NSLayoutAttribute.centerX, constant: 0)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

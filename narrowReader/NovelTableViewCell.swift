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
    var summary: UILabel!
    var length: UILabel!
    
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
        self.summary = self.createLabel()
        self.length = self.createLabel()

        self.summary?.minimumScaleFactor = 15.0/15.0;
        self.title.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: self.frame.width * 0.9 , height: 0))
        self.summary.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: self.frame.width*1.5, height: 0))
        self.length.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: self.frame.width*1.5, height: 0))
        self.summary.font = UIFont.systemFont(ofSize: 12)

        self.title.adjustsFontSizeToFitWidth = true
        self.summary.adjustsFontSizeToFitWidth = true
        self.length.adjustsFontSizeToFitWidth = true

        self.title.numberOfLines = 0
        self.summary.numberOfLines = 0

        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.summary.translatesAutoresizingMaskIntoConstraints = false
        self.length.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            self.title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            self.length.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            self.length.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            self.length.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            self.length.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            self.summary.topAnchor.constraint(equalTo: topAnchor, constant: self.frame.height * 1.0),
            self.summary.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            self.summary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            self.summary.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

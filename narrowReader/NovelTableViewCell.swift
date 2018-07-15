//
//  NovelTableViewCell.swift
//  single
//
//  Created by kaeruko on 2018/07/08.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class NovelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var story: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

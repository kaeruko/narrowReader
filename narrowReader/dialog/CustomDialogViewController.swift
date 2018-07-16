//
//  CustomDialogViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/07/16.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class CustomDialogViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    @IBAction func okButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func transparentButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

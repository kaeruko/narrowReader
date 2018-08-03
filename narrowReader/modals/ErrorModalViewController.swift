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

class ErrorPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView : CGRect {
        var presentedViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        let w = presentedViewFrame.size.width
        let h = presentedViewFrame.size.height
        presentedViewFrame.size = CGSize(width: w*0.8, height: h*0.3)
        presentedViewFrame.origin.x = ( w - (w*0.8)) * 0.5
        presentedViewFrame.origin.y = ( h - (h*0.5)) * 0.5
        return presentedViewFrame
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        /// レイアウト開始前の処理
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
    
    private let overlayView = UIView()
    var overlay: UIView!
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        self.overlay = UIView(frame: containerView.bounds)
        self.overlay.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(self.overlayDidTouch(_:)))]
        containerView.insertSubview(self.overlay, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.5
        })
    }

    @objc func overlayDidTouch(_ sender: UITapGestureRecognizer){
        print("overlayDidTouch")
        self.presentedViewController.dismiss(animated: true, completion: nil)
        
    }

    
}

class ErrorModalViewController: narrowBaseViewController {

    lazy var titleLabel : UILabel = self.createLabel()
    lazy var subTitleLabel : UILabel = self.createLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.titleLabel.text = "ネットワークにつながっていません"
        self.layoutElement(target: self.view, element: self.titleLabel, attr: NSLayoutAttribute.top, constant: 10)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

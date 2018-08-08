//
//  ErrorModalViewController.swift
//  narrowReader
//
//  Created by kaeruko on 2018/08/01.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class ErrorMessage{
    var error_title : String = ""
    var error_text : String = ""
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
    lazy var submitButton : UIButton = self.createButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.titleLabel.text = "ネットワークにつながっていません"
        self.layoutElement(target: self.view, element: self.titleLabel, attr: NSLayoutAttribute.top, constant: 30)
        self.layoutElement(target: self.view, element: self.titleLabel, attr: NSLayoutAttribute.leading, constant: 10)

        self.submitButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        self.submitButton.setTitle("OK", for: .normal)
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.backgroundColor = UIColor.black
        self.submitButton.addTarget(self, action: #selector(self.reConnect(sender:)), for:.touchUpInside)
        self.layoutElement(target: self.view, element: self.submitButton, attr: NSLayoutAttribute.bottom, constant: -50)
        self.layoutElement(target: self.view, element: self.submitButton, attr: NSLayoutAttribute.centerX, constant: 0)
    }

    @objc open func reConnect(sender : UIButton) {
        let result = SearchResultViewController()
//        result.condition = nil
        self.navigationController?.pushViewController(result, animated: true)
        self.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

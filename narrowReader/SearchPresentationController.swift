//
//  SearchPresentationController.swift
//  single
//
//  Created by kaeruko on 2018/07/09.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit

class SearchPresentationController: UIPresentationController {
    /// 呼び出し元のViewControllerの上に重ねるオーバーレイ
    private let overlayView = UIView()
    var overlay: UIView!
    public var modalWidth:CGFloat = 0
    public var modalHeight:CGFloat = 0
    public var modalOriginX:CGFloat = 0
    public var modalOriginY:CGFloat = 0

    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        
        self.overlay = UIView(frame: containerView.bounds)
        self.overlay.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(self.overlayDidTouch(_:)))]
        containerView.insertSubview(self.overlay, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.5
        })
    }
    

    override func dismissalTransitionWillBegin() {
        //        super.dismissalTransitionWillBegin()
        // 非表示トランジション開始前の処理
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        //        super.dismissalTransitionDidEnd(completed)
        // 非表示トランジション終了時の処理
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        var presentedViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        let w = presentedViewFrame.size.width
        let h = presentedViewFrame.size.height
        self.modalWidth = w * 0.9
        self.modalHeight = h * 0.9
        presentedViewFrame.size = CGSize(width: self.modalWidth, height: self.modalHeight)
        presentedViewFrame.origin.x = ( w - modalWidth) * 0.5
        presentedViewFrame.origin.y = ( h - modalHeight) * 0.1
        return presentedViewFrame
    }

    // 子のコンテナサイズを返す
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
print("containerViewWillLayoutSubviews")
        /// レイアウト開始前の処理
        overlayView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
        
    }
    
    
    @objc func overlayDidTouch(_ sender: UITapGestureRecognizer){
        print("overlayDidTouch")
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}

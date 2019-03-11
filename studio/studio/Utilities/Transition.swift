//
//  Transition.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/11/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresentation : Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.x += initialFrameForVC.size.width;
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
            animatingView?.frame = finalFrame
        }) { (success) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    }
    

}

extension Transition: UIViewControllerTransitioningDelegate {
    
}

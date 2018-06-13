//
//  PopTransition.swift
//  CustomSizeController
//
//  Created by Warif Akhand Rishi on 14/6/18.
//  Copyright © 2018 Warif Akhand Rishi. All rights reserved.
//

import Foundation
import UIKit

class PopTransition: NSObject {
    
    var duration: TimeInterval = 0.3
    var springWithDamping: CGFloat = 0.8
    var reverse: Bool
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?
    
    init(originFrame: CGRect, reverse: Bool = false) {
        self.reverse = reverse
        self.originFrame = originFrame
    }
}

extension PopTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let viewControllerKey: UITransitionContextViewControllerKey = reverse ? .from : .to
        let viewControllerToAnimate = transitionContext.viewController(forKey: viewControllerKey)!

        let viewToAnimate = viewControllerToAnimate.view!
        viewToAnimate.frame = transitionContext.finalFrame(for: viewControllerToAnimate)
        
        let initialFrame = originFrame
        let finalFrame = viewToAnimate.frame

        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
    
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if !reverse {
            viewToAnimate.transform = scaleTransform
            viewToAnimate.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            viewToAnimate.clipsToBounds = true
            transitionContext.containerView.addSubview(viewToAnimate)
        }
        
        UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0.0, animations: { [weak self] in
            
            guard let `self` = self else { return }
            
            viewToAnimate.transform = self.reverse ?
                scaleTransform : CGAffineTransform.identity
            
            let frame = self.reverse ? initialFrame : finalFrame
            viewToAnimate.center = CGPoint(x: frame.midX, y: frame.midY)
            
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
//
//  MenuTransitionManager.swift
//  SlideMenu
//
//  Created by Соловьев Олег Витальевич on 19/01/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private let duration = 0.7
    private var isPresenting = false
    
    weak var delegate: MenuTransitionManagerDelegate?
    
    private var snapshot: UIView? {
        didSet {
            if let delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: #selector(delegate.dismiss))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        let moveRight = CGAffineTransform(translationX: container.frame.width - 50, y: 0)
        let moveLeft = CGAffineTransform(translationX: 50 - container.frame.width, y: 0)
        
        if isPresenting {
            toView.transform = moveLeft
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {

            if self.isPresenting {
                self.snapshot?.transform = moveRight
                toView.transform = CGAffineTransform.identity
            } else {
                self.snapshot?.transform = CGAffineTransform.identity
                fromView.transform = moveLeft
            }

        }, completion: { finished in

            transitionContext.completeTransition(true)

            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })

    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
    
}

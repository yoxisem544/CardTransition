//
//  CardTransitioningDelegate.swift
//  CardTransition
//
//  Created by David on 2019/10/28.
//  Copyright © 2019 kkday. All rights reserved.
//

import UIKit

final public class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPushTransitionAnimator()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPopTransitionAnimator()
    }

}

fileprivate let darkOverlay: UIView = {
    let dark = UIView()
    dark.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    return dark
}()

fileprivate class CardPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let from = transitionContext.viewController(forKey: .from),
            let to = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        from.view.addSubview(darkOverlay)
        containerView.addSubview(to.view)

        to.view.layer.cornerRadius = 4
        to.view.clipsToBounds = true
        to.view.transform = CGAffineTransform(translationX: 0, y: to.view.frame.height)

        darkOverlay.frame.size = from.view.bounds.size
        darkOverlay.alpha = 0

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: {
                to.view.transform = CGAffineTransform(translationX: 0, y: 64)
                darkOverlay.alpha = 1
            },
            completion: { done in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

}

fileprivate class CardPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let from = transitionContext.viewController(forKey: .from),
            let to = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(from.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: {
                from.view.transform = CGAffineTransform(translationX: 0, y: from.view.bounds.height)
                darkOverlay.alpha = 0
            },
            completion: { done in
                darkOverlay.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

}

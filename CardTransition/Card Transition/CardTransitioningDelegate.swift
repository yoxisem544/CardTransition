//
//  CardTransitioningDelegate.swift
//  CardTransition
//
//  Created by David on 2019/10/28.
//  Copyright © 2019 kkday. All rights reserved.
//

import UIKit

final public class CardTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {

    public var nextScene: UIViewController? {
        didSet {
            nextScene?.modalPresentationStyle = .custom
            nextScene?.transitioningDelegate = self
            // add pan
            let pan =
            nextScene?.view.addGestureRecognizer(panGesture)
        }
    }

    private var panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
    private var isInteractive: Bool = false

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPushTransitionAnimator()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPopTransitionAnimator()
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }

    @objc private func pan(gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: gesture.view!)

//        switch gesture.state {
//        case .began:
//            isInteractive = true
//            nextScene?.dismiss(animated: true, completion: nil)
//
//        case .changed:
//
//
//        default:
//            isInteractive = false
//        }
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

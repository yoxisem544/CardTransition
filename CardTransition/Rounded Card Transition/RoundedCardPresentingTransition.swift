//
//  AppleMusicPresentingTransition.swift
//  Round
//
//  Created by David on 2018/7/5.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

final public class RoundedCardPresentingTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let duration: TimeInterval

  public init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    guard let to = transitionContext.viewController(forKey: .to) else { return }

    container.addSubview(to.view)

    let cardTopToScreenTopSpacing =
      RoundedCardTransitionManualLayout.presentingViewTopInset
        + RoundedCardTransitionManualLayout.insetForPresntedView

    let height = container.bounds.height - cardTopToScreenTopSpacing
    let initialFrame = CGRect(origin: CGPoint(x: 0, y: height),
                              size: CGSize(width: container.bounds.width, height: height))
    
    to.view.frame = initialFrame
    to.view.transform = .identity

    // Final frame & corner radius
    let cornerRadius: CGFloat = 14
    let corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    let finalFrame = transitionContext.finalFrame(for: to)

    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      delay: 0,
      options: .curveEaseOut,
      animations: {
        to.view.frame = finalFrame
        to.view.clipsToBounds = true
        to.view.layer.cornerRadius = cornerRadius
        to.view.layer.maskedCorners = corners
      },
      completion: { done in
        transitionContext.completeTransition(done)
      })
  }

}

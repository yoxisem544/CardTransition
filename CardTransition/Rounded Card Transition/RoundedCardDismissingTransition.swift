//
//  AppleMusicDismissingTransition.swift
//  Round
//
//  Created by David on 2018/7/5.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

final public class RoundedCardDismissingTransition: NSObject, UIViewControllerAnimatedTransitioning {

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
    guard let from = transitionContext.viewController(forKey: .from) else { return }

    container.addSubview(from.view)

    let offScreenFrame = CGRect(x: 0,
                                y: container.bounds.height,
                                width: from.view.bounds.width,
                                height: from.view.bounds.height)

    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      delay: 0,
      options: .curveEaseOut,
      animations: {
        from.view.frame = offScreenFrame
      },
      completion: { done in
        transitionContext.completeTransition(done)
      })
  }

}

//
//  RoundedCardTransitioningDelegate.swift
//  Round
//
//  Created by David on 2018/7/5.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

public protocol RoundedCardTransitioningDismissingDelegate: class {
  func roundedCardTransitioningWillDismiss()
}

final public class RoundedCardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

  private let isSwipeToDismissEnabled: Bool
  private let presentationDuration: TimeInterval
  private let dismissalDuration: TimeInterval
  public var showDismissButton: Bool = true

  public weak var dismissingDelegate: RoundedCardTransitioningDismissingDelegate?

  public init(presentationDuration: TimeInterval = 0.3,
              dismissalDuration: TimeInterval = 0.3,
              isSwipeToDismissEnabled: Bool = true) {
    self.presentationDuration = presentationDuration
    self.dismissalDuration = dismissalDuration
    self.isSwipeToDismissEnabled = isSwipeToDismissEnabled
    super.init()
  }

  public func bind(nextAnimating view: UIViewController) {
    view.transitioningDelegate = self
    view.modalPresentationStyle = .custom
  }

  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return RoundedCardPresentingTransition(duration: presentationDuration)
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return RoundedCardDismissingTransition(duration: dismissalDuration)
  }

  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController =
      RoundedCardPresentationController(presentedViewController: presented,
                                        presenting: presenting,
                                        presentationDuration: presentationDuration,
                                        dismissalDuration: dismissalDuration,
                                        showDismissButton: showDismissButton,
                                        isSwipeToDismissGestureEnabled: isSwipeToDismissEnabled)
    presentationController.transitioningDelegate = self
    return presentationController
  }

}


//
//  UIViewController+RoundedCardTransitionViewControllerProtocol.swift
//  2140-iOS
//
//  Created by David on 2018/11/3.
//  Copyright © 2018 BitCle. All rights reserved.
//

import UIKit

extension UITabBarController: RoundedCardTransitionViewControllerProtocol {

  /// The view controller representing the selected tab is assumed to contain
  /// the `UIScrollView` to be tracked
  public var childViewControllerForRoundedCard: UIViewController? {
    return self.selectedViewController
  }

}

extension UINavigationController: RoundedCardTransitionViewControllerProtocol {

  /// The view controller at the top of the navigation stack is assumed to
  /// contain the `UIScrollView` to be tracked
  public var childViewControllerForRoundedCard: UIViewController? {
    return self.topViewController
  }

}


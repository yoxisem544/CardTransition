//
//  RoundedCardTransitionManualLayout.swift
//  Round
//
//  Created by David on 2018/7/23.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

/// A wrapper for a bunch of sizing methods
final class RoundedCardTransitionManualLayout {

  /// Just a convenience method to access the height of the status bar
  class var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
  }

  /// The top inset of the presentingView within the containerView.
  ///
  class var presentingViewTopInset: CGFloat {
    let statusBarHeight = RoundedCardTransitionManualLayout.statusBarHeight

    switch statusBarHeight {
    case 20:    return 20
    case 40:    return 20
    case 44:    return 44
    default:    return statusBarHeight
    }
  }

  /// The top inset of the containerView within its window based on the status
  /// bar. This exists entirely because the opaque blue location and green
  /// in-call status bars on portrait non-X iPhones inset the containerView
  /// by 20px
  class var containerViewTopInset: CGFloat {
    let statusBarHeight = RoundedCardTransitionManualLayout.statusBarHeight

    switch statusBarHeight {
    case 0:     return 0
    case 20:    return 0
    case 40:    return 20
    case 44:    return 0
    default:    return 0
    }
  }

  class var insetForPresntedView: CGFloat {
    return 12
  }
}

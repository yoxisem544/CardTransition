//
//  RoundedCardTransition+IsPresentedUsingRoundedCard.swift
//  Round
//
//  Created by David on 2018/7/23.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

extension UIViewController {

  var isPresentedUsingRoundedCard: Bool {
    return
      transitioningDelegate is RoundedCardTransitioningDelegate
      && modalPresentationStyle == .custom
      && presentingViewController != nil
  }

}

//
//  HitTestExtendView.swift
//  ContentPage
//
//  Created by David on 2018/6/11.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

final public class HitTestExtendView: UIView {

  public var reciever: UIView?

  public convenience init(with width: CGFloat, cornerRadius: CGFloat = 0, andRecieverView r: UIView?) {
    self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width)))

    self.layer.cornerRadius = cornerRadius
    self.reciever = r
  }

  public convenience init(with size: CGSize, cornerRadius: CGFloat = 0, andReceiverView r: UIView?) {
    self.init(frame: CGRect(origin: CGPoint.zero, size: size))

    self.layer.cornerRadius = cornerRadius
    self.reciever = r
  }

  fileprivate override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    return (self.point(inside: point, with: event) ? reciever : nil)
  }
}

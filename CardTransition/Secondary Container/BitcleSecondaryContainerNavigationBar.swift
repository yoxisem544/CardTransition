//
//  BitcleSecondaryContainerNavigationBar.swift
//  2140-iOS
//
//  Created by David on 2018/8/13.
//  Copyright © 2018年 BitCle. All rights reserved.
//

import UIKit

fileprivate struct NavigationBarStyleSheet {
  static let height: CGFloat = 70

  struct Title {
    static let height: CGFloat = 31
    static let textColor = "#0e1c2d".color
    static let fontSize: CGFloat = 26
    static let font = UIFont(name: "PingFangTC-Semibold", size: NavigationBarStyleSheet.Title.fontSize)!
    static let leftSpacing: CGFloat = 20
    static let bottomSpacing: CGFloat = 10
  }
}

final public class BitcleSecondaryContainerNavigationBar: UIView {

  // MARK: - Subviews
  private var backgroundView: UIVisualEffectView!
  private var titleLabel: UILabel!

  // MARK: - Properties
  public var title: String? {
    didSet {
      titleLabel.text = title
      titleLabel.sizeToFit()
    }
  }

  // MARK: - Init

  /// Init nav bar with default height 70
  public convenience init() {
    self.init(height: NavigationBarStyleSheet.height)
  }

  /// Init nav bar with a given height
  ///
  /// - Parameter height: height for nav bar
  public convenience init(height: CGFloat) {
    self.init(frame: CGRect(origin: .zero,
                            size: CGSize(width: UIScreen.main.bounds.width,
                                         height: height)))
  }

  private override init(frame: CGRect) {
    super.init(frame: frame)

    setupUI()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UI
  private func setupUI() {
    backgroundColor = .clear
    
    configureBackgroundView()
    configureTitleLabel()
  }

  private func configureBackgroundView() {
    backgroundView = UIVisualEffectView(frame: bounds)
    backgroundView.effect = UIBlurEffect(style: .light)
    backgroundView.anchor(to: self)
  }

  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel
      .change(height: NavigationBarStyleSheet.Title.height)
      .anchor(to: self)
    titleLabel
      .move(NavigationBarStyleSheet.Title.leftSpacing, pointsLeadingToAndInside: self)
      .move(NavigationBarStyleSheet.Title.bottomSpacing, pointsBottomToAndInside: self)
    titleLabel
      .changeFont(to: NavigationBarStyleSheet.Title.font)
      .changeTextColor(to: NavigationBarStyleSheet.Title.textColor)
  }

}

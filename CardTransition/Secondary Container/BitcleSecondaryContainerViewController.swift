//
//  BitcleSecondaryContainerViewController.swift
//  2140-iOS
//
//  Created by David on 2018/8/13.
//  Copyright © 2018年 BitCle. All rights reserved.
//

import UIKit

final public class BitcleSecondaryContainerViewController: UIViewController {

  // MARK: - Properties
  public var displayingViewController: UIViewController? {
    willSet {
      guard let newDisplayingViewController = newValue else {
        // when new value is nil, remove previous vc from current container
        displayingViewController?.willMove(toParentViewController: nil)
        displayingViewController?.view.removeFromSuperview()
        displayingViewController?.removeFromParentViewController()
        displayingViewController?.didMove(toParentViewController: nil)
        return
      }
    }

    didSet {
      guard let displayingViewController = displayingViewController else { return }
      displayingViewController.willMove(toParentViewController: self)
      view.addSubview(displayingViewController.view)
      addChildViewController(displayingViewController)
      // when displaying view controller is set, add view to view stack
      // then call didMove to parent vc
      displayingViewController.didMove(toParentViewController: self)
      arrangeViewHierarchy()
    }
  }

  public var titleOfNavBar: String? {
    didSet {
      navBar?.title = titleOfNavBar
    }
  }

  // MARK: - Subviews
  private var navBar: BitcleSecondaryContainerNavigationBar!


  // MARK: - Initialization
  public init() {
    super.init(nibName: nil, bundle: nil)

    view.layoutIfNeeded()
    view.setNeedsLayout()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    displayingViewController?.view.frame = view.bounds
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  // MARK: - UI
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func setupUI() {
    // view style
    view.backgroundColor = .white
    // set status bar style
    modalPresentationCapturesStatusBarAppearance = true

    // subviews
    configureNavBar()

    arrangeViewHierarchy()
  }

  private func configureNavBar() {
    navBar = BitcleSecondaryContainerNavigationBar().anchor(to: view)
  }

  private func arrangeViewHierarchy() {
    guard let displayingView = displayingViewController?.view else { return }
    guard let navBar = navBar else { return }

    displayingView.anchor(to: view, below: navBar)
  }

  public func hideBar() {
    navBar.hide()
  }

  public func showBar() {
    navBar.show()
  }

}


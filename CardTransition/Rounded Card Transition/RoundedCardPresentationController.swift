//
//  RoundedCardPresentationController.swift
//  Round
//
//  Created by David on 2018/7/5.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

final public class RoundedCardPresentationController: UIPresentationController {

  /// The presentation controller holds a strong reference to the
  /// transitioning delegate because `UIViewController.transitioningDelegate`
  /// is a weak property, and thus the `DeckTransitioningDelegate` would be
  /// unallocated right after the presentation animation.
  ///
  /// Since the transitioningDelegate only vends the presentation controller
  /// object and does not hold a reference to it, there is no issue of a
  /// circular dependency here.
  var transitioningDelegate: RoundedCardTransitioningDelegate?

  /// Pan gesture to dismiss view.
  private var isSwipeToDismissGestureEnabled = true
  private var pan: UIPanGestureRecognizer?
  private var scrollViewUpdater: ScrollViewUpdater?

  private var presentationDuration: TimeInterval = 0.3
  private var dismissalDuration: TimeInterval = 0.3

  private let backgroundView = UIView()

  private var snapshotView: UIView?

  private var showDismissButton: Bool = true


  private var insetForPresntedView: CGFloat = RoundedCardTransitionManualLayout.insetForPresntedView
  private var cardCornerRadius: CGFloat = 14
  private let croppedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  private let alphaFor: (initialState: CGFloat, middleState: CGFloat, endState: CGFloat) = (1.0, 0.75, 0.0)
  private let scaleRatio: CGFloat = 0.93

  // FIXME: Use weak var
  private var dismissView: UIView?

  /// Create a transitioning delegate for apple music like transition.
  ///
  /// - Parameters:
  ///   - presentedViewController: view controller to present presenting view
  ///   - presenting: view controller to present
  ///   - presentationDuration: duration for presentation
  ///   - dismissalDuration: duration for dismissal
  convenience init(presentedViewController: UIViewController,
                   presenting: UIViewController?,
                   presentationDuration: TimeInterval,
                   dismissalDuration: TimeInterval,
                   showDismissButton: Bool = true,
                   isSwipeToDismissGestureEnabled: Bool) {
    self.init(presentedViewController: presentedViewController, presenting: presenting)

    self.presentationDuration = presentationDuration
    self.dismissalDuration = dismissalDuration
    self.showDismissButton = showDismissButton

    self.isSwipeToDismissGestureEnabled = isSwipeToDismissGestureEnabled
  }


  // MARK: - Presentation
  public override func presentationTransitionWillBegin() {
    guard let container = containerView else { return }

    let initialFrame: CGRect
    if presentingViewController.isPresentedUsingRoundedCard {
      initialFrame = presentingViewController.view.frame
    } else {
      initialFrame = container.frame
    }

    // setup background color
    backgroundView.frame = container.frame
    backgroundView.backgroundColor = .black
    container.addSubview(backgroundView)

    // handle from view transition
    guard let snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: true) else { return }
    container.insertSubview(snapshotView, belowSubview: presentedViewController.view)
    self.snapshotView?.removeFromSuperview()
    self.snapshotView = snapshotView

    // determine if snapshot should move up or down
    let translation: CGAffineTransform = {
      if presentingViewController.isPresentedUsingRoundedCard {
        return CGAffineTransform.identity.translatedBy(x: 0, y: -insetForPresntedView)
      } else {
        return CGAffineTransform.identity.translatedBy(x: 0, y: RoundedCardTransitionManualLayout.presentingViewTopInset)
      }
    }()
    let finalTransform: CGAffineTransform = translation.concatenating(scale(view: snapshotView))

    if presentingViewController.isPresentedUsingRoundedCard {
      // move down if already presented with apple music
      // match size of initial frame
      snapshotView.frame = initialFrame
      // move y to proper point
      snapshotView.frame.origin.y = initialFrame.origin.y - container.frame.origin.y
    }

    // Add previous transition view if presenting view is presented by apple music transition
    var previousSnapshot: UIView?
    if presentingViewController.isPresentedUsingRoundedCard {
      if let previousSnapshotView = presentingViewController.presentingViewController?.view.snapshotView(afterScreenUpdates: false) {
        previousSnapshot = previousSnapshotView
        previousSnapshotView.transform = CGAffineTransform.identity
          .translatedBy(x: 0, y: RoundedCardTransitionManualLayout.presentingViewTopInset)
          .concatenating(scale(view: previousSnapshotView))
        maskCorner(view: previousSnapshotView, alpha: alphaFor.middleState)
        container.insertSubview(previousSnapshotView, belowSubview: snapshotView)
      }
    }

    // add dismiss view to presented view
    if showDismissButton {
      anchorDismissView(to: presentedViewController.view)
    }

    presentedViewController.transitionCoordinator?.animate(
      alongsideTransition: { [weak self] (context) in
        guard let `self` = self else { return }
        self.snapshotView?.transform = finalTransform
        self.maskCorner(view: self.snapshotView, alpha: self.alphaFor.middleState)
        previousSnapshot?.alpha = 0
      }, completion: { (context) in
        //        self.snapshotView?.removeFromSuperview()
    })
  }

  public override func presentationTransitionDidEnd(_ completed: Bool) {
    //    // setup pan when presentation ended.
    //    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    //    self.pan = pan
    //    presentedViewController.view.addGestureRecognizer(pan)

    if isSwipeToDismissGestureEnabled {
      pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
      pan!.delegate = self
      pan!.maximumNumberOfTouches = 1
      pan!.cancelsTouchesInView = false
      presentedViewController.view.addGestureRecognizer(pan!)
    }
  }

  // MARK: - Dismissal
  public override func dismissalTransitionWillBegin() {

    let finalFrame = presentingViewController.view.frame
    let finalTransform = CGAffineTransform.identity

    // check if has previous snapshot view
    var previousSnapshotView: UIView?
    if presentingViewController.isPresentedUsingRoundedCard {
      if let snapshotView = presentingViewController.presentingViewController?.view.snapshotView(afterScreenUpdates: false),
        let frontSnapshotView = self.snapshotView {
        previousSnapshotView = snapshotView
        snapshotView.transform = frontSnapshotView.transform
        snapshotView.frame.origin.y = RoundedCardTransitionManualLayout.presentingViewTopInset
        maskCorner(view: snapshotView, alpha: alphaFor.endState)
        containerView?.insertSubview(snapshotView, belowSubview: frontSnapshotView)
      }
    }

    presentedViewController.transitionCoordinator?.animate(
      alongsideTransition: { [weak self] (context) in
        guard let `self` = self else { return }
        self.snapshotView?.transform = finalTransform
        self.snapshotView?.frame = finalFrame
        self.snapshotView?.alpha = self.alphaFor.initialState
        self.snapshotView?.layer.cornerRadius = 0
        previousSnapshotView?.alpha = self.alphaFor.middleState
      }, completion: nil)

  }

  public override func dismissalTransitionDidEnd(_ completed: Bool) {
    dismissView?.removeFromSuperview()
    snapshotView?.removeFromSuperview()
  }

  // MARK: - Frame
  public override var frameOfPresentedViewInContainerView: CGRect {
    // place to determine next presented view's frame
    guard let container = containerView else { return .zero }

    let yOffset = RoundedCardTransitionManualLayout.presentingViewTopInset + insetForPresntedView

    let frame = CGRect(x: 0,
                       y: yOffset,
                       width: container.bounds.width,
                       height: container.bounds.height - yOffset)

    return frame
  }

  private func scale(view: UIView) -> CGAffineTransform {
    return CGAffineTransform.identity
      .translatedBy(x: 0, y: -view.bounds.height / 2)
      .scaledBy(x: scaleRatio, y: scaleRatio)
      .translatedBy(x: 0, y: view.bounds.height / 2)
  }

  private func maskCorner(view: UIView?, alpha: CGFloat) {
    view?.alpha = alpha
    view?.layer.cornerRadius = cardCornerRadius
    view?.layer.maskedCorners = croppedCorners
    view?.clipsToBounds = true
  }

  // MARK: - Presented view transition
  private func updatePresentedView(inVerticalDirection translation: CGFloat) {
    let dismissThreshold: CGFloat = 240
    let elasticThreshold: CGFloat = 120
    let translationFactor: CGFloat = 0.5

    let translationForModal: CGFloat = {
      if translation >= elasticThreshold {
        let frictionLength = translation - elasticThreshold
        let frictionTranslation = 30 * atan(frictionLength/120) + frictionLength/10
        return frictionTranslation + (elasticThreshold * translationFactor)
      } else {
        return translation * translationFactor
      }
    }()

    let transform = CGAffineTransform(translationX: 0, y: translationForModal)
    presentedView?.transform = transform

    if translation >= dismissThreshold {
      presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

  private func updatePresentedView(inHorizontalDirection translation: CGFloat) {
    let x = max(0, translation)
    let transform = CGAffineTransform(translationX: x, y: 0)
    presentedView?.transform = transform

    if translation >= 240 {
      presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

  // MARK: - Add arrow view
  private func generateDismissView() -> UIImageView {
    let view = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 29, height: 11)))
    view.image = UIImage(named: "DismissDownArrowIcon")
    return view
  }

  private func anchorDismissView(to view: UIView) {
    let dismissView = generateDismissView()
    presentedViewController.view.addSubview(dismissView)
    dismissView.center.x = view.center.x
    dismissView.frame.origin.y = 10
    dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    dismissView.isUserInteractionEnabled = true
    self.dismissView = dismissView // keep ref to dismiss view

    let extendView = HitTestExtendView(with: CGSize(width: dismissView.bounds.width + 20,
                                                    height: dismissView.bounds.height + 20),
                                       andReceiverView: dismissView)
    extendView
      .centerX(to: dismissView)
      .centerY(to: dismissView)
      .anchor(to: presentedViewController.view)
  }

  @objc
  private func dismiss() {
    if transitioningDelegate?.dismissingDelegate != nil {
      transitioningDelegate?.dismissingDelegate?.roundedCardTransitioningWillDismiss()
    } else {
      presentingViewController.dismiss(animated: true, completion: nil)
    }
  }

  // MARK: - Gesture handling

  private func isSwipeToDismissAllowed() -> Bool {
    guard let updater = scrollViewUpdater else {
      return isSwipeToDismissGestureEnabled
    }

    return updater.isDismissEnabled
  }

  @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    guard gestureRecognizer.isEqual(pan), isSwipeToDismissGestureEnabled else {
      return
    }

    switch gestureRecognizer.state {

    case .began:
      let detector = ScrollViewDetector(withViewController: presentedViewController)
      if let scrollView = detector.scrollView {
        scrollViewUpdater = ScrollViewUpdater(
          withRootView: presentedViewController.view,
          scrollView: scrollView)
      }
      gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: containerView)

    case .changed:
      if isSwipeToDismissAllowed() {
        let translation = gestureRecognizer.translation(in: presentedView)
        updatePresentedViewForTranslation(inVerticalDirection: translation.y)
      } else {
        gestureRecognizer.setTranslation(.zero, in: presentedView)
      }

    case .ended:
      UIView.animate(
        withDuration: 0.25,
        animations: {
          self.presentedView?.transform = .identity
      })
      scrollViewUpdater = nil

    default: break

    }
  }

  /// Method to update the modal view for a particular amount of translation
  /// by panning in the vertical direction.
  ///
  /// The translation of the modal view is proportional to the panning
  /// distance until the `elasticThreshold`, after which it increases at a
  /// slower rate, given by `elasticFactor`, to indicate that the
  /// `dismissThreshold` is nearing.
  ///
  /// Once the `dismissThreshold` is reached, the modal view controller is
  /// dismissed.
  ///
  /// - parameter translation: The translation of the user's pan gesture in
  ///   the container view in the vertical direction
  private func updatePresentedViewForTranslation(inVerticalDirection translation: CGFloat) {

    let elasticThreshold: CGFloat = 120
    let dismissThreshold: CGFloat = 240

    let translationFactor: CGFloat = 1/2

    /// Nothing happens if the pan gesture is performed from bottom
    /// to top i.e. if the translation is negative
    if translation >= 0 {
      let translationForModal: CGFloat = {
        if translation >= elasticThreshold {
          let frictionLength = translation - elasticThreshold
          let frictionTranslation = 30 * atan(frictionLength/120) + frictionLength/10
          return frictionTranslation + (elasticThreshold * translationFactor)
        } else {
          return translation * translationFactor
        }
      }()

      presentedView?.transform = CGAffineTransform(translationX: 0, y: translationForModal)

      if translation >= dismissThreshold {
        presentedViewController.dismiss(animated: true, completion: nil)
      }
    }
  }


}

extension RoundedCardPresentationController : UIGestureRecognizerDelegate {

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    guard gestureRecognizer.isEqual(pan) else {
      return false
    }

    return true
  }

}

//
//  SecondViewController.swift
//  CardTransition
//
//  Created by David on 2019/10/28.
//  Copyright © 2019 kkday. All rights reserved.
//

import UIKit

final public class SecondViewController: UIViewController {

    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    // MARK: - 🎨 Style

    // MARK: - 🧩 Subviews
    private lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        return s
    }()

    // MARK: - 👆 Actions

    // MARK: - 🔨 Initialization
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🖼 View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        seutpUI()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // resize when frame has changed...
    }

    // MARK: - 🏗 UI
    private func seutpUI() {
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))

        scrollView.frame.size = view.bounds.size
        scrollView.contentSize.width = view.bounds.size.width
        scrollView.contentSize.height = 2000
        view.addSubview(scrollView)
    }

    // MARK: - 🚌 Public Methods

    // MARK: - 🔒 Private Methods
    @objc func tap() {
        let vc = SecondViewController()
//        vc.transitioningDelegate = nn
//        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }

}

// MARK: - 🧶 Extensions

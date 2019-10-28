//
//  ViewController.swift
//  CardTransition
//
//  Created by David on 2019/10/28.
//  Copyright © 2019 kkday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let ct = CardTransitionManager()
    let nn = RoundedCardTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        view.backgroundColor = .white
    }

    @objc func tap() {
        let vc = SecondViewController()
        vc.transitioningDelegate = nn
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }

}


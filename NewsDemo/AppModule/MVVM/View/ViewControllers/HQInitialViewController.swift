//
//  HQInitialViewController.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-10.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

protocol HQInitialViewControllerDelegate: AnyObject {
    func initialScreenLoadDone()
}

class HQInitialViewController: UIViewController {

    weak var delegate: HQInitialViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Added 2 seconds delay to show some UI, animation, etc.
        let DELAY_IN_SECONDS = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + DELAY_IN_SECONDS) {
            self.delegate?.initialScreenLoadDone()
        }
    }
}

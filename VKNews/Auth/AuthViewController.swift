//
//  AuthViewController.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 31.08.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    private var authSetvice: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authSetvice = AppDelegate.shared().authService
    }
    

    @IBAction func sighInTouch() {
        authSetvice.wakeUpSession()
    }
    

}

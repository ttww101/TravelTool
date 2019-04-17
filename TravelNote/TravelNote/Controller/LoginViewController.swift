//
//  LoginViewController.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/6/12.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUp()
    }
    
    func setUp() {
        
        setUpLoginView()
    }
    
    func setUpLoginView() {
        
        view.addSubview(loginView)
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        loginView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

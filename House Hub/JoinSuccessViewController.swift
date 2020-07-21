//
//  JoinSuccessViewController.swift
//  House Hub
//
//  Created by Humza Raza on 7/19/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

class JoinSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToAppbtn(_ sender: Any) {//successfully joined group take to app
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
}

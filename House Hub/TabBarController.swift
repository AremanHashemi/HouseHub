//
//  TabBarController.swift
//  House Hub
//
//  Created by Humza Raza on 7/13/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizableViewControllers = nil;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if let moreTableView = moreNavigationController.topViewController?.view as? UITableView {

            moreTableView.backgroundColor = UIColor(red: 0.9406759143, green: 0.9559720159, blue: 0.9371087551, alpha: 1)

            for cell in moreTableView.visibleCells {
                cell.backgroundColor = UIColor(red: 0.9406759143, green: 0.9559720159, blue: 0.9371087551, alpha: 1)
                cell.textLabel?.textColor = UIColor(#colorLiteral(red: 0.1529411765, green: 0.1568627451, blue: 0.2196078431, alpha: 1))
            }
            
            moreTableView.tintColor = UIColor(#colorLiteral(red: 0.1529411765, green: 0.1568627451, blue: 0.2196078431, alpha: 1))
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

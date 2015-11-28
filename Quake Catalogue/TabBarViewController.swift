//
//  TabBarViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 22/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for controller in self.viewControllers! {
            if controller.tabBarItem.title == "QuakeLog" {
                let splitViewController = (controller as! UINavigationController).viewControllers[0] as! UISplitViewController
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                splitViewController.delegate = self
            }
        }
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? QuakeDetailViewController else { return false }
        if topAsDetailController.selectedQuakeFeature == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

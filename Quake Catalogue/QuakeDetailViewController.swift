//
//  QuakeDetailViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit

class QuakeDetailViewController: UIViewController {
    var selectedQuakeFeature: QCQuakeFeature?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let buttonBack = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "updateSearchCriteria:")
        //self.navigationItem.leftBarButtonItem = buttonBack
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateSearchCriteria(sender: AnyObject) {
        
    }
}

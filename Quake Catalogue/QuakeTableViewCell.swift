//
//  QuakeTableViewCell.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 26/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit

class QuakeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var magnitude: UILabel?
    @IBOutlet weak var place: UILabel?
    @IBOutlet weak var coordinates: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func backFromDetail(segue: UIStoryboardSegue) {
        
    }
}

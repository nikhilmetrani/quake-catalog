//
//  QCMapAnnotation.swift
//  Quake Catalogue
//
//  Created by Pyisoe Yarzar on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import Foundation
import MapKit


class QCMapAnnotation : MKPointAnnotation
{
    var feature:QCQuakeFeature!    
    var subTitle:String!
    
    init(title:String, subtitle: String, loc:CLLocationCoordinate2D, feature:QCQuakeFeature)
    {
        super.init()
        super.title = title;
        super.subtitle = subtitle
        super.coordinate = loc
        self.feature = feature
    }
}
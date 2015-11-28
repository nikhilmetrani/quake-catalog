//
//  QuakeSearchViewController.swift
//  Quake Catalogue
//
//  Created by Nikhil Metrani on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit

class QuakeSearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textFieldMinMagnitude: UITextField!
    @IBOutlet weak var textFieldMaxMagnitude: UITextField!
    @IBOutlet weak var dateTimePickerQuakeForDay: UIDatePicker!
    
    var magnitudes: [Int] = [0,1,2,3,4,5,6,7,8,9,10]
    var maxMagnitudes: [Int] = []
    let pickerViewMinMag: UIPickerView = UIPickerView()
    let pickerViewMaxMag: UIPickerView = UIPickerView()
    
    var searchCriteria: QuakeSearchCriteria?
    
    var minMag: Int = 0
    var maxMag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTimePickerQuakeForDay.maximumDate = NSDate()
        
        pickerViewMinMag.delegate = self
        pickerViewMinMag.dataSource = self
        textFieldMinMagnitude.inputView = pickerViewMinMag
        
        pickerViewMaxMag.delegate = self
        pickerViewMaxMag.dataSource = self
        textFieldMaxMagnitude.inputView = pickerViewMaxMag
    }
    
    override func viewWillAppear(animated: Bool) {
        minMag = (searchCriteria?.minmagnitude)!
        maxMag = (searchCriteria?.maxmagnitude)!
        dateTimePickerQuakeForDay.date = QCDateTimeConponents.getDateFromComponentsAsNSDate((searchCriteria?.year)!, month: (searchCriteria?.month)!, day: (searchCriteria?.day)!)
        
        textFieldMaxMagnitude.text = "\(maxMag)"
        textFieldMinMagnitude.text = "\(minMag)"
        prepareMaxMagnitudesArray()
        pickerViewMinMag.reloadAllComponents()
        pickerViewMaxMag.reloadAllComponents()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        searchCriteria?.maxmagnitude = maxMag
        searchCriteria?.minmagnitude = minMag
        let dtComponents = QCDateTimeConponents.getDateTimeComponents(dateTimePickerQuakeForDay.date)
        searchCriteria?.year = dtComponents.year
        searchCriteria?.month = dtComponents.month
        searchCriteria?.day = dtComponents.day
        
        let urlQuery: QCURLQuery = QCURLQuery.instance
        
        urlQuery.createQueryFromSearchCriteria(searchCriteria!)
        urlQuery.execute()
        
        super.viewDidDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textFieldMinMagnitude.resignFirstResponder()
        textFieldMaxMagnitude.resignFirstResponder()
    }
    
    func prepareMaxMagnitudesArray() {
        maxMagnitudes = []
        for item in magnitudes {
            if item >= minMag {
                maxMagnitudes.append(item)
            }
        }
        pickerViewMaxMag.reloadAllComponents()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewMinMag {
            return magnitudes.count
        }
        if pickerView == pickerViewMaxMag {
            return maxMagnitudes.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewMinMag {
            return "\(magnitudes[row])"
        }
        if pickerView == pickerViewMaxMag {
            return "\(maxMagnitudes[row])"
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewMinMag {
            textFieldMinMagnitude.text = "\(magnitudes[row])"
            minMag = magnitudes[row]
            if minMag > maxMag {
                textFieldMaxMagnitude.text = "\(minMag)"
                maxMag = minMag
            }
        }
        if pickerView == pickerViewMaxMag {
            textFieldMaxMagnitude.text = "\(maxMagnitudes[row])"
            maxMag = maxMagnitudes[row]
        }
        prepareMaxMagnitudesArray()
    }
}

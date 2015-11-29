//
//  AnalyticsViewController.swift
//  Quake Catalogue
//
//  Created by Sugesh K.S on 28/11/15.
//  Copyright © 2015 Group04. All rights reserved.
//

import UIKit
import PNChart

class AnalyticsViewController: UIViewController {
    
    var selectedIndex = 0
    @IBOutlet weak var stackView: UIStackView!
    var pieChart: PNPieChart!
    var lineChart: PNLineChart!
    
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        onIndexSelected(selectedIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSegmentChanged(sender: UISegmentedControl) {
        onIndexSelected(sender.selectedSegmentIndex)
    }
    func onIndexSelected(index: Int) {
        self.selectedIndex = index
        let subViews = self.containerView.subviews
        
        for subView in subViews {
            subView.removeFromSuperview()
        }
        
        if(index == 0) {
            setupPieChart()
            refreshPieChart()
        }
        else {
            setupLineChart()
            refreshLineChart()
        }
    }
    private func setupPieChart() {
        let width = self.view.bounds.width
        self.pieChart = PNPieChart(frame: CGRectMake(0, 135.0, width, 200.0))
        self.pieChart.descriptionTextColor = UIColor.blackColor()
        //self.pieChartView.descriptionTextFont  = UIFont(name: "Avenir-Medium", size: 11.0)
        self.pieChart.descriptionTextShadowColor = UIColor.clearColor()
        self.pieChart.showAbsoluteValues = false
        self.pieChart.showOnlyValues = false
        self.pieChart.legendStyle = PNLegendItemStyle.Serial
        self.pieChart.legendFont = UIFont.boldSystemFontOfSize(12.0)
        self.containerView.addSubview(pieChart)
    }
    
    private func setupLineChart() {
        let width = self.view.bounds.width
        self.lineChart = PNLineChart(frame: CGRectMake(0, 135.0, width, 200.0))
        self.lineChart.yLabelFormat = "%1.1f";
        self.lineChart.backgroundColor = UIColor.clearColor()
        self.lineChart.yLabels = ["0", "2", "4", "6", "8"]
        self.lineChart.xLabels = [""]

        self.lineChart.showCoordinateAxis = true
        self.lineChart.yFixedValueMax = 8.0
        self.lineChart.yFixedValueMin = 0.0
        
        self.containerView.addSubview(lineChart)
    }
    
    private func refreshPieChart() {
        var chartItems : [AnyObject] = []
        let searchResults = QCURLQuery.instance.searchResult!
        
        var magnitudeCount = [Int : Int] ()
        
        for feature in searchResults.features {
            let key = Int(feature.mag!)
            var value = magnitudeCount[key]
            if value == nil {
                value = 0
                magnitudeCount[key] = value
            }
            magnitudeCount[key]!++
        }

        for (key,value) in magnitudeCount {
            let item = PNPieChartDataItem(value: CGFloat(value), color: PieCharColors[key], description: "Mag:\(key) - \(key+1)")
            chartItems.append(item)
        }
        self.pieChart.updateChartData(chartItems)
        
        let legend = self.pieChart.getLegendWithMaxWidth(320.0)
        if(legend != nil) {
            legend.frame = CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)
            self.containerView.addSubview(legend)
        }
    }
    
    private func refreshLineChart() {
        let magnitudes = QCURLQuery.instance.searchResult?.features.map({$0.mag})
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        let chartData = PNLineChartData()
        chartData.dataTitle = "Magnitude"
        chartData.color = PNRed
        chartData.alpha = 0.3
        let count = (magnitudes?.count)!
        chartData.itemCount = UInt(count)        
        chartData.inflexionPointStyle = PNLineChartPointStyle.Triangle;
        chartData.getData = { index in
            let mag = CGFloat(magnitudes![Int(index)]!)
            return PNLineChartDataItem(y: mag)
        }
        self.lineChart.chartData = [chartData]
        self.lineChart.strokeChart()
        let legend = self.lineChart.getLegendWithMaxWidth(320.0)
        if(legend != nil) {
            legend.frame = CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)
            self.containerView.addSubview(legend)
        }
    }
}

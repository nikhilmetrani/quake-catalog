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
    
    @IBOutlet weak var stackView: UIStackView!
    var pieChart: PNPieChart!
    var lineChart: PNLineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieView()
        refreshPieChart()
        setupLineChart()
        refreshLineChart()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPieView() {
        let width = self.view.bounds.width
        self.pieChart = PNPieChart(frame: CGRectMake(0, 135.0, width, 200.0))
        self.pieChart.descriptionTextColor = UIColor.blackColor()
        //self.pieChartView.descriptionTextFont  = UIFont(name: "Avenir-Medium", size: 11.0)
        self.pieChart.descriptionTextShadowColor = UIColor.clearColor()
        self.pieChart.showAbsoluteValues = false
        self.pieChart.showOnlyValues = false
        self.pieChart.legendStyle = PNLegendItemStyle.Serial
        self.pieChart.legendFont = UIFont.boldSystemFontOfSize(12.0)
        self.view.addSubview(pieChart)
    }
    
    private func setupLineChart() {
        let width = self.view.bounds.width
        self.lineChart = PNLineChart(frame: CGRectMake(0, 135.0, width, 200.0))
        self.lineChart.yLabelFormat = "%1.1f";
        self.lineChart.backgroundColor = UIColor.clearColor()
        self.lineChart.yLabels = ["0", "2", "4", "6", "8"]
        self.lineChart.xLabels = ["Magnitudes"]

        self.lineChart.showCoordinateAxis = true
        self.lineChart.yValueMax = 8.0
        self.lineChart.yValueMin = 0.0
        self.view.addSubview(lineChart)
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
            let item = PNPieChartDataItem(value: CGFloat(value), color: PNGreen, description: "Mag:\(key) - \(key+1)")
            chartItems.append(item)
        }
        self.pieChart.updateChartData(chartItems)
        //let legend = self.pieChartView.getLegendWithMaxWidth(320.0)
        //legend.frame = CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)
    }
    
    private func refreshLineChart() {
        let magnitudes = QCURLQuery.instance.searchResult?.features.map({$0.mag})
        
        let chartData = PNLineChartData()
        chartData.dataTitle = "Magnitude";
        chartData.color = PNFreshGreen;
        chartData.alpha = 0.3
        let count = (magnitudes?.count)! - 1
        chartData.itemCount = UInt(count)
        chartData.inflexionPointStyle = PNLineChartPointStyle.Triangle;
        chartData.getData = { index in
            let mag = CGFloat(magnitudes![Int(index)]!)
            return PNLineChartDataItem(y: mag)
        }
        self.lineChart.chartData = [chartData]
        self.lineChart.strokeChart()
        //self.lineChart.updateChartData([chartData])
    }
}

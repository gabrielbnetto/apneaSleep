//
//  HomeViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 09/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Lottie
import Charts

class HomeViewController: UIViewController {

    @IBOutlet weak var moonLoader: AnimationView!
    @IBOutlet weak var sleepQualityImage: AnimationView!
    @IBOutlet weak var sleepQualityLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var hellowLabel: UILabel!
    
    var helloName = ""
    var sleepQualityEntry = PieChartDataEntry(value: 0)
    var sleepQualityEntry2 = PieChartDataEntry(value: 0)
    var qualitySleepEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        pieChart.isHidden = true
        super.viewDidLoad()
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue){
            hellowLabel.text = "Olá " + userName + "!"
        }
        startAnimation(animation: "moonLoader", label: loadingLabel, view: moonLoader)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.pieChart.isHidden = false
            self.moonLoader.isHidden = true
            self.createChart()
            self.startAnimation(animation: "sleepQualityImage", label: self.sleepQualityLabel, view: self.sleepQualityImage)
        }
    }
    
    func createChart() {
        self.pieChart.chartDescription?.text = ""
        self.sleepQualityEntry.value = 75
        self.sleepQualityEntry.label = "Quality \(self.sleepQualityEntry.value)"
        self.sleepQualityEntry2.value = 25
        self.sleepQualityEntry2.label = ""
        self.qualitySleepEntries = [self.sleepQualityEntry, self.sleepQualityEntry2]
        let chartDataSet = PieChartDataSet(entries: self.qualitySleepEntries, label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor(named: "pieChartColor"), UIColor(named: "pieChartColor2")]  as! [NSUIColor]
//        pieChart.centerText = "amsosmak"
        pieChart.transparentCircleColor = nil
        pieChart.holeColor = nil
        pieChart.data = chartData
        
    }

    func startAnimation(animation: String, label: UILabel, view: AnimationView) {
        label.textAlignment = .center
        let checkMarkAnimation = AnimationView(name: animation)
        view.contentMode = .scaleAspectFit
        view.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = view.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
    }
}


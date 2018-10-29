//
//  MarketChart.swift
//  FGWallet
//
//  Created by David on 1/16/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class MarketChart: BaseViewController {
    
    var data: [(Date, Double)] = []
    
    @IBOutlet weak var lblCurentMount: UILabel!
    
    @IBOutlet weak var lblCureentMoutn2: UILabel!
    
    @IBOutlet weak var lblCureentPrice3: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var chart: LineChartView!
    let fortmat: DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "dd MMM"
        return fm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        navigationItem.title = Klang.market_chart.localized()
        
        let earlyDate = Calendar.current.date(
            byAdding: .day,
            value: -30,
            to: Date())
        print(earlyDate!)
        lblCurentMount.textColor = FGColor.primary
        lblCureentMoutn2.textColor = FGColor.green
        lblCureentPrice3.textColor = FGColor.red
        resetText()
        chart.pinchZoomEnabled = false
        chart.chartDescription?.text = nil
        chart.legend.enabled = false
        chart.noDataText = ""
    
      
        
        let rightAxis = chart.rightAxis
     
   
        rightAxis.labelTextColor = .white
        rightAxis.setLabelCount(20, force: true)
        
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .white
        xAxis.granularity = 3
        xAxis.labelCount = 5
        xAxis.valueFormatter = self
        
        
        
        resetText()
        getValue()
        
        
    }
    
    func resetText() {
        lblDate.text = ""
        lblCurentMount.text = ""
        lblCureentMoutn2.text = ""
        lblCureentPrice3.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getValue() {
        showLoading()
                API.getConvertMoney({ (value) in
                 
                    if let value = value {
                        
                        
                        self.lblCurentMount.text = "￥ \(value)"
                        self.lblCureentMoutn2.text = "￥ \(value)"
                        self.lblCureentPrice3.text = "￥ \(value)"
                        self.lblDate.text = FormatDate.string(from: Date())
                      /*  API.getChart{[weak self]
                            (valeu, err) in
                            hideLoading()
                            guard let strongSelf = self else {return}
                            if err == nil {
                                strongSelf.data = valeu
                                
                                
                            }
                            strongSelf.data.append((Date(), value))
                            strongSelf.setDataChart()
                           
                        }
 */
                    }else{
                        hideLoading()
                        
                        
                    }
                })
                
          
    }
    
    
    func setDataChart() {
        let yVals1 = (0..<data.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: data[i].1)
        }
        let set1 = LineChartDataSet(values: yVals1, label: "")
        
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.8
        set1.circleRadius = 4
        set1.setCircleColor(.white)
        set1.highlightColor = colorFrom("0000ff")
        set1.fillColor = .white
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
                set1.fillFormatter = CubicLineSampleFillFormatter()
        let gradientColors = [ChartColorTemplates.colorFromString("#0000ff").cgColor,
                              ChartColorTemplates.colorFromString("#0000ff").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 0.5
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        
        let dataadd = LineChartData(dataSet: set1)
        dataadd.setDrawValues(false)
    
        
        chart.data = dataadd
        chart.leftAxis.enabled = false
    
    }
    
    
    
    
    
}



extension MarketChart : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print(value)
        return  fortmat.string(from: data[Int(value)].0)
    }
    
}









//
//  MarketCharVC.swift
//  FGWallet
//
//  Created by Ivan on 1/18/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit



class MarketCharVC: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [(Date, Double)] = []
    let refeshControler = UIRefreshControl()
   
    var priceCurent: Double = 0
    
    let fortmat: DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "dd MMM"
        return fm
    }()
    
    var dateCurrent: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        navigationItem.title = Klang.market_chart.localized()
        
        refeshControler.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refeshControler.tintColor = .white
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refeshControler
        } else {
            self.tableView.backgroundView = refeshControler
        }
        self.tableView.contentOffset = CGPoint(x:0, y: -self.refeshControler.frame.size.height)
        self.tableView.tableFooterView = UIView()
        loadData()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getMaxMin() -> (Double, Double) {
        if data.count  == 0 {
            return (0, 0)
        }
        let valueYs = data.map {($0.1)}
        return (valueYs.max() ?? 0, valueYs.min() ?? 0)
        
    }
  
    
    @objc func loadData() {
        refeshControler.beginRefreshing()
        API.getCureentPrice {[weak self] (value, date, error) in
            guard let sSelf = self else {return}
          
            sSelf.dateCurrent = date ?? Date()
            if let value = value {
                sSelf.priceCurent = value
                API.getChart(sSelf.dateCurrent) {[weak self] (valeu, err) in
                
                    guard let strongSelf = self else {return}
                    if err == nil {
                        strongSelf.data = valeu
                        
                        
                    }
                    strongSelf.data.append((sSelf.dateCurrent!, value))
                
        
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                        strongSelf.refeshControler.perform(#selector(strongSelf.refeshControler.endRefreshing), with: nil, afterDelay: 0.2)
                    }
                    
                }
            }else{
                
                sSelf.refeshControler.perform(#selector(sSelf.refeshControler.endRefreshing), with: nil, afterDelay: 0.2)
                return
            }
        }
     
    }
    
    
    
}

extension MarketCharVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MarketCharCell", for: indexPath) as! MarketCharCell
        configCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.bounds.height
    }
    
    func configCell(_ cell: MarketCharCell) {
        cell.lblPrice0.text = "￥ \(priceCurent)"
        cell.lblPrice1.text = "￥ \(priceCurent)"
        cell.lblPrice2.text = "￥ \(priceCurent)"
        cell.lblDate.text = FormatDate.string(from: dateCurrent!)
        cell.chart.pinchZoomEnabled = false
        cell.chart.chartDescription?.text = nil
        cell.chart.dragEnabled = false
        cell.chart.legend.enabled = false
        cell.chart.noDataText = ""
       
        cell.chart.setScaleEnabled(false)
      
        
        
        let rightAxis =  cell.chart.rightAxis
        rightAxis.labelTextColor = .white
        rightAxis.setLabelCount(15, force: true)
        rightAxis.axisMinimum = 0
   
        
        let xAxis =  cell.chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .white
   
        xAxis.granularity = 4
        xAxis.labelCount = 5
        xAxis.valueFormatter = self
        xAxis.drawGridLinesEnabled = true
        
        
        
        let yVals1 = (0..<data.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: data[i].1)
        }
        let set1 = LineChartDataSet(values: yVals1, label: "")
        
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.5
//        set1.circleRadius = 4
//        set1.setCircleColor(.white)
        set1.highlightColor = FGColor.green
        set1.fillColor = .white
        set1.fillAlpha = 0.5
       
        let gradientColors = [ChartColorTemplates.colorFromString("#0000ff").cgColor,
                              ChartColorTemplates.colorFromString("#0000ff").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
     
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        set1.setDrawHighlightIndicators(true)
        
        
        let dataadd = LineChartData(dataSet: set1)
        
        set1.axisDependency = .right
        dataadd.setDrawValues(false)
        set1.highlightEnabled = true
        
        
        cell.chart.data = dataadd
        cell.chart.leftAxis.enabled = false
        
    
    }
    
    
    
}

extension MarketCharVC : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return  fortmat.string(from: data[Int(value)].0)
    }
    
}





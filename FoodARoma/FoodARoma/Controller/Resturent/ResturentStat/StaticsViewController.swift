//
//  StaticsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-07.
//

import UIKit
import Charts
import DGCharts
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class StaticsViewController: UIViewController {
    
    private var loading : (NVActivityIndicatorView,UIView)?
    @IBOutlet weak var lineChartView: LineChartView!
    
    var historyData : [OrderHistories]? = [OrderHistories]()
    var orders: [Order] = []
    var yValues : [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        lineChartView.rightAxis.enabled = false
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
//        yAxis.labelPosition = .insideChart
        yAxis.setLabelCount(6, force: false)
        
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(6, force: false)
        
        lineChartView.animate(xAxisDuration: 1.0)
//        SetData()
        makeYaxisData()
    }
    
    private func calculateHourlyTotalPrices(orders: [Order]) -> [String: Double] {
        var hourlyTotalPrices: [String: Double] = [:]

        let calendar = Calendar.current

        for order in orders {
            let hourComponents = calendar.dateComponents([.year, .month, .day, .hour], from: order.dateTime)
            
            if calendar.isDateInToday(order.dateTime) {
                if let hourDate = calendar.date(from: hourComponents) {
                    let hourFormatter = DateFormatter()
                    hourFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    let hourString = hourFormatter.string(from: hourDate)

                    if let existingTotal = hourlyTotalPrices[hourString] {
                        hourlyTotalPrices[hourString] = existingTotal + order.price
                    } else {
                        hourlyTotalPrices[hourString] = order.price
                    }
                }
            }
        }

        return hourlyTotalPrices
    }
    
    func getHourFromDateString(_ dateString: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let hour = Double(calendar.component(.hour, from: date))
            return hour
        }
        
        return nil // Return nil if the input date string is invalid
    }
    
    private func makeYaxisData(){
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)

        let paramss : [String : String] = [
                "Mode" : "listAllCompletedOrders"
            ]

        AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:paramss, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    
                    let jsonData = try decoder.decode(OrderhistoryModel.self, from: data)
                    self.historyData = jsonData.histories
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    if let HData = self.historyData{
                        for x in HData{
                            if let date = dateFormatter.date(from: x.datetime), let priceData = Double(x.total_price){
                                self.orders.append(Order(dateTime: date, price: priceData))
                            }
                        }
                        print("orders Data : \(self.orders)")
                        
                        let hourlyTotalPrices = self.calculateHourlyTotalPrices(orders: self.orders)
                        
                        let sortedHourlyTotalPrices = hourlyTotalPrices.sorted { (entry1, entry2) -> Bool in
                            return entry1.key < entry2.key
                        }
                        print("Sorted hourlyTotalPrices : \(sortedHourlyTotalPrices)")
                        self.yValues.removeAll()
                        for x in sortedHourlyTotalPrices {
                            let inputDateString = x.key
                            if let hour = self.getHourFromDateString(inputDateString) {
                                print(hour) // Output: 3
                                self.yValues.append(ChartDataEntry(x: hour, y: x.value))
                            } else {
                                print("Invalid date string")
                            }
                        }
                        if self.yValues.count > 0 {
                            print(self.yValues)
                            self.SetData()
                        }
                    }
                
                    self.loadingProtocol(with: self.loading! ,false)
                }
                catch{
                    print(response.result)
                    self.loadingProtocol(with: self.loading! ,false)
                    print("decoder error")
                }

            case .failure(let error):
                self.loadingProtocol(with: self.loading! ,false)
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
    }
    
    func SetData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Total Sales")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(UIColor(named: "GreenColor") ?? .green)
        set1.drawCirclesEnabled = false
        set1.fill = ColorFill(color: UIColor(named: "GreenColor") ?? .green)
        set1.fillAlpha = 0.15
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
//        data.setDrawValues(false)
        lineChartView.data = data
    }


}

extension StaticsViewController : ChartViewDelegate {
    
}

struct Order {
    let dateTime: Date
    let price: Double
}

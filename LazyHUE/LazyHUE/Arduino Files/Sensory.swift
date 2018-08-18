//
//  Sensory.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 18..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import Alamofire

class Sensory: NSObject {
    
    // MARK: - Enum
    internal enum jsonName: String {
        case date = "insertDate"
        case temputure = "AVG(temperature)"
        case cds = "AVG(cds)"
        case noise = "AVG(noize)"
        case humidity = "AVG(humidity)"
        case gas = "AVG(gas)"
        case clientIP = "ClientIP"
    }
    
    // MARK: - Variable
    internal static let sensoryInstance: Sensory = Sensory()
    internal var temputuerList: [Double]    = [Double]()
    internal var cdsList: [Double]          = [Double]()
    internal var noiseList: [Double]        = [Double]()
    internal var gasList: [Double]          = [Double]()
    internal var humidityList: [Double]     = [Double]()
    internal var dateList: [String]         = [String]()
    
    // MARK: - get Instance Method
    private override init() {}
    
    // MARK: - Parsor JSON Method
    internal func parsorSensorDataJSON(url: String, group: DispatchGroup) {
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async(group: group, execute: {
            Alamofire.request(url).responseJSON(completionHandler: { [unowned self] response in
                
                guard response.result.isSuccess else {
                    group.leave()
                    fatalError("Error, Not Receive Data From NRP Server.")
                }
                
                switch response.response?.statusCode {
                    case .none:
                        group.leave()
                        fatalError("Error, Not Receive Data From NRP Server.")
                    case .some(_):
                        guard let result = response.result.value, let json = result as? NSDictionary else { break }
                        guard let sensory = json["SensorDatas"] as? [[String:Any]] else { break }
                        
                        for item in sensory {
                            // MARK: Processing Save Json
                            self.temputuerList.append( Double(item[jsonName.temputure.rawValue] as! String)! )
                            self.humidityList.append( Double(item[jsonName.humidity.rawValue] as! String)! )
                            self.noiseList.append( Double(item[jsonName.noise.rawValue] as! String)! )
                            self.gasList.append( Double(item[jsonName.gas.rawValue] as! String)! )
                            self.cdsList.append( Double(item[jsonName.cds.rawValue] as! String)! )
                            
                            // MARK: Processing Dateformatter
                            let formatter: DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let insertDT: Date = formatter.date(from: item[jsonName.date.rawValue] as! String) {
                                let hour = Calendar.current.component(.month, from: insertDT)
                                let minute = Calendar.current.component(.day, from: insertDT)
                                self.dateList.append("\(hour)월\(minute)일")
                            }
                        }
                        group.leave()
                }
            })
        })
    }
}

//
//  WeatherModel.swift
//  Clima
//
//  Created by Alicia Windsor on 13/02/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct WeatherModel {
    let weatherId : Int
    let cityName : String
    let temperature : Double
    
    var tempString : String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName : String { //computed property that provides output to be set as value
  
        switch weatherId {
            case 200...232: //thunderstorm
                return "cloud.bolt.rain"
            case 300...321: //drizzle
                return "cloud.drizzle"
            case 500...531: //rain
                return "cloud.rain"
            case 600...622: //snow
                return "cloud.snow"
            case 701...781: //atmostphere
                return "cloud.fog"
            case 800: //clear
                return "sun.max"
            case 801...804: //cloudy
                return "cloud.sun"
            default:
                return "cloud"
        }
    }
    
}

//
//  Data.swift
//  Weather
//
//  Created by Alexey on 21.09.2021.
//

import Foundation

struct Weather: Codable {
    var id:Int
    var main:String
    var description:String
    var icon:String
}
struct Main: Codable {
    var temp:Double = 0.0
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var name: String = ""
    
}

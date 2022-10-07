//
//  DataManager.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/07.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    private var weatherDataArray: [WeatherData] = []
    
    func makeWeatherData() {
        weatherDataArray = [
            WeatherData(latitude: 36.44667, longitude: 127.11972, cityName: "공주"),
            WeatherData(latitude: 35.15972, longitude: 126.85306, cityName: "광주"),
            WeatherData(latitude: 36.11944, longitude: 128.34472, cityName: "구미"),
            WeatherData(latitude: 35.96833, longitude: 126.73722, cityName: "군산"),
            WeatherData(latitude: 35.87222, longitude: 128.60250, cityName: "대구"),
            WeatherData(latitude: 36.35111, longitude: 127.38500, cityName: "대전"),
            WeatherData(latitude: 35.00975, longitude: 126.71219, cityName: "목포"),
            WeatherData(latitude: 35.17944, longitude: 129.07556, cityName: "부산"),
            WeatherData(latitude: 36.78500, longitude: 126.45056, cityName: "서산"),
            WeatherData(latitude: 37.56667, longitude: 126.97806, cityName: "서울"),
            WeatherData(latitude: 38.20694, longitude: 128.59194, cityName: "속초"),
            WeatherData(latitude: 37.26389, longitude: 127.02861, cityName: "수원"),
            WeatherData(latitude: 34.95583, longitude: 127.49028, cityName: "순천"),
            WeatherData(latitude: 35.53889, longitude: 129.31667, cityName: "울산"),
            WeatherData(latitude: 35.95000, longitude: 126.95833, cityName: "익산"),
            WeatherData(latitude: 35.82500, longitude: 127.15000, cityName: "전주"),
            WeatherData(latitude: 33.50000, longitude: 126.51667, cityName: "제주"),
            WeatherData(latitude: 36.81528, longitude: 127.11389, cityName: "천안"),
            WeatherData(latitude: 36.64389, longitude: 127.48944, cityName: "청주"),
            WeatherData(latitude: 37.75769, longitude: 128.87375, cityName: "춘천")
        ]
    }
    
    func getWeatherData() -> [WeatherData] {
        return weatherDataArray
    }
    
    
}

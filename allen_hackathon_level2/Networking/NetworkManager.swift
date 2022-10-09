//
//  NetworkManager.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/07.
//

import UIKit

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

class NetworkManager {
    
    // 싱글톤 패턴 사용
    static let shared = NetworkManager()
    private init() {}
    
    let config = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: config)
    
    // API 호출을 통해 날씨 데이터 가져오기
    func getWeatherJsonData(latitude lat: Double, longitude lon: Double, completionHandler: @escaping (DetailData?, Error?) -> Void) {
        guard let url = URL(string: "\(WeatherApi.requestURL)&lat=\(lat)&lon=\(lon)&appid=\(Storage.ApiKey)") else {
            print("Error: url 생성 실패")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error: url로부터 GET 실패")
                print(error!)
                return
            }
            
            guard let safeData = data else {
                print("Error: data 수신 실패")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request 실패")
                print(response.debugDescription)
                return
            }

            completionHandler(self.parseJSON(safeData), error)
        }.resume()
    }
    
    func parseJSON(_ detailData: Data) -> DetailData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(DetailData.self, from: detailData)
            return decodedData
        } catch {
            print("Error: JSON 파일 파싱 실패")
            print(error)
            return nil
        }
    }
}

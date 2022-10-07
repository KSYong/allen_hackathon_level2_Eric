//
//  ViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/05.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var currentCityNameLabel: UILabel!   // 현재 위치(도시 이름) 알려주는 라벨
    
    @IBOutlet weak var grantLocationPermissionButton: UIButton! // 위치 권한 획득 버튼
    @IBOutlet weak var searchLocationButton: UIButton! // 지역 탐색 버튼
    
    @IBOutlet weak var locationMapView: MKMapView! // 지역 지도를 보여주는 맵 뷰
    
    @IBOutlet weak var weatherIcon: UIImageView!    // 날씨 아이콘을 띄우는 이미지뷰
    
    @IBOutlet weak var currentTempLabel: UILabel!   // 현재 온도를 표시하는 라벨
    @IBOutlet weak var dailyMinimumTempLabel: UILabel!  // 오늘의 최저기온
    @IBOutlet weak var dailyMaximumTempLabel: UILabel!  // 오늘의 최고기온
    @IBOutlet weak var humidityLabel: UILabel!  // 습도
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!    // 날씨 설명
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    let networkManager = NetworkManager.shared
    let dataManager = DataManager.shared
    
    var weatherData: [Weather] = []
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerSetup()
        setupCurrentLocationLabel()

        setupMapView()
    }
    
    func locationManagerSetup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if hasLocationPermission() {
            currentLocation = locationManager.location
            setupWeatherDetails()
        }
    }
    
    /// 사용자가 위치 서비스 이용에 동의했을 경우, 현재 위치 정보를 기반으로 도시 이름 표시하기
    func setupCurrentLocationLabel() {
        lookUpCurrentLocation { placemark in
            DispatchQueue.main.async {
                guard let placemark = placemark else {
                    print("placemark가 nil입니다")
                    return
                }
                self.currentCityNameLabel.text = placemark.locality
            }
        }
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion( center: locationManager.location!.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        locationMapView.setRegion(locationMapView.regionThatFits(region), animated: true)
        locationMapView.showsUserLocation = true
    }
    
    func setupWeatherDetails() {
        networkManager.getWeatherJsonData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { detailData, error in
            let weatherIconName = detailData!.weather![0].icon
            var weatherIcon: UIImage?
            
            switch weatherIconName {
            case "01d":
                weatherIcon = UIImage(systemName: "sun.max")
            case "02d":
                weatherIcon = UIImage(systemName: "cloud.sun")
            case "03d":
                weatherIcon = UIImage(systemName: "cloud")
            case "04d":
                weatherIcon = UIImage(systemName: "smoke")
            case "09d":
                weatherIcon = UIImage(systemName: "cloud.sun.rain")
            case "10d":
                weatherIcon = UIImage(systemName: "cloud.heavyrain")
            case "11d":
                weatherIcon = UIImage(systemName: "cloud.sun.bolt")
            case "13d":
                weatherIcon = UIImage(systemName: "snowflake")
            case "50d":
                weatherIcon = UIImage(systemName: "cloud.fog")
                
            case "01n":
                weatherIcon = UIImage(systemName: "moon.stars")
            case "02n":
                weatherIcon = UIImage(systemName: "cloud.moon")
            case "03n":
                weatherIcon = UIImage(systemName: "cloud")
            case "04n":
                weatherIcon = UIImage(systemName: "smoke")
            case "09n":
                weatherIcon = UIImage(systemName: "cloud.moon.rain")
            case "10n":
                weatherIcon = UIImage(systemName: "cloud.heavyrain")
            case "11n":
                weatherIcon = UIImage(systemName: "cloud.moon.bolt")
            case "13n":
                weatherIcon = UIImage(systemName: "snowflake")
            case "50n":
                weatherIcon = UIImage(systemName: "cloud.fog")
                
            default:
                weatherIcon = UIImage(systemName: "questionmark")
            }
            
            DispatchQueue.main.async {
                self.weatherIcon.image = weatherIcon
                self.currentTempLabel.text = String(detailData!.main!.temp!) + "°C"
                self.dailyMinimumTempLabel.text = String(detailData!.main!.tempMin!) + "°C"
                self.dailyMaximumTempLabel.text = String(detailData!.main!.tempMax!) + "°C"
                self.humidityLabel.text = String(detailData!.main!.humidity!) + "%"
                self.weatherDescriptionLabel.text = detailData!.weather![0].weatherDescription
            }
        }
    }
    
    
    /// 위치 정보 사용 권한 획득 버튼 눌렀을 때 실행되는 함수
    @IBAction func grantLocationButtonTapped(_ sender: UIButton) {
        // 앱의 위치 정보 사용 권한은 앱이 처음 실행될 때 한 번만 물어본다.
        // 따라서 이후에는 alert를 이용해 디바이스의 설정 화면으로 이동해서 사용권한을 획득할 수 있도록 안내해야 한다.
        
        if !hasLocationPermission(){
            let alertController = UIAlertController(title: "위치 권한이 필요합니다", message: "설정에서 권한을 획득할 수 있습니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "설정으로!", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "싫어요", style: .destructive)
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            let alertController = UIAlertController(title: "이미 GPS 권한을 획득하셨습니다!", message: "설정에서 권한을 제거할 수 있습니다.", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "알겠어요!", style: .default)
            let cancelAction = UIAlertAction(title: "설정으로", style: .destructive) { cAlertAction in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchLocationButtonTapped(_ sender: UIButton) {
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    /// 현재 앱에서 위치 권한을 획득하고 있는가?
    /// - Returns: 참 또는 거짓 반환
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        
        switch self.locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            hasPermission = false
        case .authorizedAlways, .authorizedWhenInUse:
            hasPermission = true
        @unknown default:
            break
        }
        
        return hasPermission
    }
    
    /// GPS 권한 획득 요청
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /// 권한 변경이 일어났을 때 동작 구현
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // GPS 권한 획득
            grantLocationPermissionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        case .restricted, .notDetermined:
            // GPS 권한 설정되지 않음
            grantLocationPermissionButton.setImage(UIImage(systemName: "location"), for: .normal)
        case .denied:
            // GPS 권한 거부됨
            grantLocationPermissionButton.setImage(UIImage(systemName: "location"), for: .normal)
            
        @unknown default:
            // 그 외의 경우
            print("Unknown default")
        }
    }
    
    
}

//
//  ViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/05.
//

import UIKit
import MapKit
import CoreLocation

protocol SendWeatherDataDelegate {
    func sendWeatherData(data: WeatherData)
}

protocol SendLocationPermissionDelegate {
    func sendLocationPermission(isGranted: Bool)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentCityNameLabel: UILabel!   // 현재 위치(도시 이름) 알려주는 라벨
    @IBOutlet weak var grantLocationPermissionButton: UIButton! // 위치 권한 획득 버튼
    @IBOutlet weak var searchCitiesButton: UIButton!    // 다른 지역을 찾는 뷰로 넘어가는 버튼
    @IBOutlet weak var locationMapView: MKMapView! // 지역 지도를 보여주는 맵 뷰
    
    @IBOutlet weak var weatherIcon: UIImageView!    // 날씨 아이콘을 띄우는 이미지뷰
    
    @IBOutlet weak var currentTempLabel: UILabel!   // 현재 온도를 표시하는 라벨
    @IBOutlet weak var dailyMinimumTempLabel: UILabel!  // 오늘의 최저기온
    @IBOutlet weak var dailyMaximumTempLabel: UILabel!  // 오늘의 최고기온
    @IBOutlet weak var humidityLabel: UILabel!  // 습도
    @IBOutlet weak var weatherDescriptionLabel: UILabel!    // 날씨 설명
    @IBOutlet weak var currentLocationIndicatorLabel: UILabel!  // 현재 위치 사용중인지 알려주는 라벨
    
    var currentLocation: CLLocation!
    
    let networkManager = NetworkManager.shared
    let dataManager = DataManager.shared
    var locationManager: CLLocationManager!
    
    var weatherData: [WeatherData] = []
    
    var isCurrentLocation: Bool = false
    var gpsPermission: Bool = false
    var didSelectCity: Bool = false
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        print("뷰디드로드")
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        self.navigationController?.overrideUserInterfaceStyle = .dark
        
        locationManagerSetup()
    }
    
    // 네비게이션 바 숨기기
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// 위치권한 업데이트
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !gpsPermission && !didSelectCity {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showSearchVC", sender: self)
            }
        }

        if isCurrentLocation == true {
            grantLocationPermissionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            currentLocationIndicatorLabel.text = "현재 위치 사용 중"
        } else {
            grantLocationPermissionButton.setImage(UIImage(systemName: "location"), for: .normal)
            currentLocationIndicatorLabel.text = ""
        }
        
        if hasLocationPermission() {
            gpsPermission = true
        } else {
            gpsPermission = false
        }
    }
    
    /// 위치 권한 획득을 위한 locationManager 설정
    func locationManagerSetup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if hasLocationPermission() {
            gpsPermission = true
            isCurrentLocation = true
            currentLocation = locationManager.location
            setupWeatherDetails(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
            setupCurrentLocationLabel()
            setupMapView(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
        } else {
            gpsPermission = false
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
    
    // 맵뷰 설정하기
    func setupMapView(center: CLLocationCoordinate2D ) {
        let region = MKCoordinateRegion( center: center, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        locationMapView.setRegion(locationMapView.regionThatFits(region), animated: true)
        locationMapView.showsUserLocation = true
    }
    
    // 날씨 정보 라벨 채우기
    func setupWeatherDetails(lat: Double, lon: Double) {
        networkManager.getWeatherJsonData(latitude: lat, longitude: lon) { detailData, error in
            let weatherIconName = detailData!.weather![0].icon
            var weatherIcon: UIImage?
            let config = UIImage.SymbolConfiguration.preferringMulticolor()
            
            switch weatherIconName {
            case "01d":
                weatherIcon = UIImage(systemName: "sun.max.fill")
            case "02d":
                weatherIcon = UIImage(systemName: "cloud.sun.fill")
            case "03d":
                weatherIcon = UIImage(systemName: "cloud.fill")
            case "04d":
                weatherIcon = UIImage(systemName: "smoke.fill")
            case "09d":
                weatherIcon = UIImage(systemName: "cloud.sun.rain.fill")
            case "10d":
                weatherIcon = UIImage(systemName: "cloud.heavyrain.fill")
            case "11d":
                weatherIcon = UIImage(systemName: "cloud.sun.bolt.fill")
            case "13d":
                weatherIcon = UIImage(systemName: "snowflake")
            case "50d":
                weatherIcon = UIImage(systemName: "cloud.fog.fill")
                
            case "01n":
                weatherIcon = UIImage(systemName: "moon.stars.fill")
            case "02n":
                weatherIcon = UIImage(systemName: "cloud.moon.fill")
            case "03n":
                weatherIcon = UIImage(systemName: "cloud.fill")
            case "04n":
                weatherIcon = UIImage(systemName: "smoke.fill")
            case "09n":
                weatherIcon = UIImage(systemName: "cloud.moon.rain.fill")
            case "10n":
                weatherIcon = UIImage(systemName: "cloud.heavyrain.fill")
            case "11n":
                weatherIcon = UIImage(systemName: "cloud.moon.bolt.fill")
            case "13n":
                weatherIcon = UIImage(systemName: "snowflake")
            case "50n":
                weatherIcon = UIImage(systemName: "cloud.fog.fill")

            default:
                weatherIcon = UIImage(systemName: "exclamationmark.triangle.fill")
            }
            
            DispatchQueue.main.async {
                self.weatherIcon.image = weatherIcon
                self.weatherIcon.preferredSymbolConfiguration = config
                
                self.currentTempLabel.text = String(Int(round(detailData!.main!.temp!))) + "°"
                self.dailyMinimumTempLabel.text = "최저 : " + String(Int(round(detailData!.main!.tempMin!))) + "°"
                self.dailyMaximumTempLabel.text = "최고 : " + String(Int(round(detailData!.main!.tempMax!))) + "°"
                self.humidityLabel.text = "습도 : " + String(detailData!.main!.humidity!) + "%"
                self.weatherDescriptionLabel.text = detailData!.weather![0].weatherDescription
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchVC" {
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        } else if segue.identifier == "showSettingsVC" {
            let settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.delegate = self
        }
    }
    
    /// 위치 정보 사용 권한 획득 버튼 눌렀을 때 실행되는 함수
    @IBAction func grantLocationButtonTapped(_ sender: UIButton) {
        // 앱의 위치 정보 사용 권한은 앱이 처음 실행될 때 한 번만 물어본다.
        // 따라서 이후에는 alert를 이용해 디바이스의 설정 화면으로 이동해서 사용권한을 획득할 수 있도록 안내해야 한다.
        
        // 현재 위치의 날씨 정보를 볼 것인지 물어본다
        
        // 위치 정보 사용 권한이 없다면 설정 탭에서 위치 권한 획득하도록 안내
        if !hasLocationPermission(){
            let alertController = UIAlertController(title: "위치 권한이 필요합니다", message: "설정 탭에서 위치 권한 설정이 가능합니다.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "알겠어요!", style: .destructive)
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // 위치 정보 사용 권한이 있다면...
            // 현재 위치를 사용중이지 않다면
            if !isCurrentLocation {
                // 탭했을 때 현재 위치를 상용하겠다는 의미
                // 아이콘 변경 및 현재 위치 내용으로 ui 변경
                currentLocation = locationManager.location
                setupCurrentLocationLabel()
                setupWeatherDetails(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
                setupMapView(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
                grantLocationPermissionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
                currentLocationIndicatorLabel.text = "현재 위치 사용 중"
                isCurrentLocation = true
            }
            // 현재 위치를 사용중이라면
            // 탭했을 때에는 현재 위치를 사용하지 않겠다는 뜻이고
            // 이는 지역 검색을 통해 해결할 수 있기 때문에
            // 따로 아무런 반응이 없도록 해서 지역 검색 하도록 유도
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .notDetermined, .restricted:
            gpsPermission = false
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            gpsPermission = true
        @unknown default:
            print("Error: unknown")
        }
    }
    
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
}

extension MainViewController: SendWeatherDataDelegate {
    
    func sendWeatherData(data: WeatherData) {
        currentCityNameLabel.text = data.cityName
        setupWeatherDetails(lat: data.latitude, lon: data.longitude)
        setupMapView(center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude))
        didSelectCity = true
        isCurrentLocation = false
        grantLocationPermissionButton.setImage(UIImage(systemName: "location"), for: .normal)
    }
    
}

extension MainViewController: SendLocationPermissionDelegate {
    func sendLocationPermission(isGranted: Bool) {
        if gpsPermission != isGranted {
            // gpsPermission이 설정 뷰컨에서 넘어온 값과 다르다면
            if hasLocationPermission() {
                gpsPermission = true
            } else {
                gpsPermission = false
            }
        }
    }
}

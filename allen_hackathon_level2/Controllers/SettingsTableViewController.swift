//
//  SettingsTableViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/10.
//

import UIKit
import CoreLocation

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var gpsGrantedSwitch: UISwitch!
    
    var delegate: SendLocationPermissionDelegate?
    
    private var observer: NSObjectProtocol?
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        gpsGrantedSwitch.setOn(false, animated: true)
        
        locationManager = CLLocationManager()
        /// NotificationCenter를 활용해 현재 위치 사용 설정을 완료 후 되돌아왔음을 알고, 스위치 정보를 업데이트한다.
        NotificationCenter.default.addObserver(self, selector: #selector(activateSwitch), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasLocationPermission() {
            gpsGrantedSwitch.setOn(true, animated: true)
        } else {
            gpsGrantedSwitch.setOn(false, animated: true)
        }
        print(gpsGrantedSwitch.isOn)
    }
    
    @objc func activateSwitch() {
        if hasLocationPermission() {
            gpsGrantedSwitch.setOn(true, animated: true)
        } else {
            gpsGrantedSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func gpsGrantedSwitchTapped(_ sender: UISwitch) {
        if gpsGrantedSwitch.isOn {
            let alertController = UIAlertController(title: "위치 권한을 허용하시겠습니까?", message: "설정에서 권한을 허용할 수 있습니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "설정으로!", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "싫어요", style: .destructive)
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "위치 권한을 제한하시겠습니까?", message: "설정에서 권한을 제한할 수 있습니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "설정으로!", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "싫어요", style: .destructive)
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        if hasLocationPermission() {
            gpsGrantedSwitch.setOn(true, animated: true)
        } else {
            gpsGrantedSwitch.setOn(false, animated: true)
        }
        
        //        gpsPermission?.toggle()
        //        gpsGrantedSwitch.isOn.toggle()
        delegate?.sendLocationPermission(isGranted: gpsGrantedSwitch.isOn)
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
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "ericyong95@naver.com", message: "010-5011-2052", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "돌아가기", style: .destructive)
                
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            case 1:
                performSegue(withIdentifier: "showPIVC", sender: self)
                break
            case 2:
                let alertController = UIAlertController(title: "개발자: 권승용", message: "승용이가 개발했습니다!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "돌아가기", style: .destructive)
                
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            default:
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

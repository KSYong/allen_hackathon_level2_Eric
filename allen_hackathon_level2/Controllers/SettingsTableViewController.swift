//
//  SettingsTableViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/10.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var gpsGrantedSwitch: UISwitch!
    
    var gpsPermission: Bool?
    
    var delegate: SendLocationPermissionDelegate?
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        // NotificationCenter를 활용해
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { notification in
            if self.gpsPermission! {
                self.gpsGrantedSwitch.isOn = true
            } else {
                self.gpsGrantedSwitch.isOn = false
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gpsPermission! {
            gpsGrantedSwitch.isOn = true
        } else {
            gpsGrantedSwitch.isOn = false
        }
    }

    @IBAction func gpsGrantedSwitchTapped(_ sender: UISwitch) {
        if !gpsGrantedSwitch.isOn {
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
        gpsPermission?.toggle()
        gpsGrantedSwitch.isOn.toggle()
        delegate?.sendLocationPermission(isGranted: gpsGrantedSwitch.isOn)
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

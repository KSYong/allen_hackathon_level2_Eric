//
//  SearchViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/09.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!

    let dataManager = DataManager.shared
        
    var weatherData: [WeatherData]?

    var delegate: SendWeatherDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        dataManager.makeWeatherData()
        weatherData = dataManager.getWeatherData()
        cityTableView.dataSource = self
        cityTableView.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! SearchTableViewCell
        cell.cityNameLabel.text = weatherData?[indexPath.row].cityName
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendWeatherData(data: weatherData![indexPath.row])
        print("\(weatherData![indexPath.row].cityName) 선택됨")
        self.navigationController?.popViewController(animated: true)
    }
}


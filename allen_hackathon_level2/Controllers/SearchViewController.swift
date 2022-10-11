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
    
    var filteredWeatherData: [WeatherData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        dataManager.makeWeatherData()
        weatherData = dataManager.getWeatherData()
        
        cityTableView.dataSource = self
        cityTableView.delegate = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "도시 이름을 검색하세요"
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! SearchTableViewCell
        if self.isFiltering {
            if(indexPath.row > filteredWeatherData.count-1){
                    return UITableViewCell()
            } else {
                cell.cityNameLabel.text = filteredWeatherData[indexPath.row].cityName
            }
        } else {
            cell.cityNameLabel.text = weatherData?[indexPath.row].cityName
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFiltering {
            delegate?.sendWeatherData(data: weatherData![indexPath.row])
        } else {
            delegate?.sendWeatherData(data: filteredWeatherData[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)

    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredWeatherData = (self.weatherData?.filter { (weatherData: WeatherData) -> Bool in
            weatherData.cityName.contains(text)
        })!
        
        dump(filteredWeatherData)
        
        self.cityTableView.reloadData()
    }
    
}

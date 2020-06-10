//
//  StatsController.swift
//  COVID-19 Tracker
//
//  Created by SCG on 6/7/20.
//  Copyright © 2020 SCG. All rights reserved.
//

import UIKit
import Alamofire
import Charts

class StatsController: UIViewController {
    
    var items: Display?
    var summaries: Data?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalChangeLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeChangeLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var deathsChangeLabel: UILabel!
    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var recChangeLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var criticalChangeLabel: UILabel!
    @IBOutlet weak var testedLabel: UILabel!
    @IBOutlet weak var testedChangeLabel: UILabel!
    @IBOutlet weak var dRatioLabel: UILabel!
    @IBOutlet weak var dRatioChangeLabel: UILabel!
    @IBOutlet weak var recRatioLabel: UILabel!
    @IBOutlet weak var recRatioChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .black
            textField.textColor = .gray
            
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.black
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
        
        print("To the global summary!")
        fetchSummary()
    }
}

//MARK: - Search Bar

extension StatsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var countryName = searchBar.text else { return }
        self.navigationItem.title = "\(countryName) Stats"
        countryName = countryName.lowercased()
        
        if countryName == "us" || countryName == "united states" || countryName == "united states of america" {
            countryName = "usa"
        } else if countryName == "united kingdom" || countryName == "united kingdom of great britain" || countryName == "great britain" {
            countryName = "uk"
        }
        
        searchBar.endEditing(true)
        
        searchCountry(for: countryName)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        items = summaries as? Display
        searchBar.endEditing(true)
    }
}

//MARK: - Alamofire

extension StatsController {
    
    func fetchSummary() {
        
        self.navigationItem.title = "Global Stats"
        let request = AF.request("https://api.quarantine.country/api/v1/summary/latest")
        request.responseDecodable(of: All.self) { (response) in
            guard let summary = response.value else { return }
            self.summaries = summary.data
            self.items = summary.data as? Display
            self.enterLabels(summary: summary.data.summary, change: summary.data.change)
        }
    }
    
    func searchCountry(for countryName: String) {
        
        let url = "https://api.quarantine.country/api/v1/summary/region"
        let parameters: [String: String] = ["region": countryName]
        AF.request(url, parameters: parameters).validate()
            .responseDecodable(of: All.self) { response in
                guard let country = response.value else { return }
                self.summaries = country.data
                self.items = country.data as? Display
                self.enterLabels(summary: country.data.summary, change: country.data.change)
        }
    }
}

//MARK: - Labels

extension StatsController {
    
    func enterLabels(summary: Summary, change: Summary) {
        
        totalLabel.text = formatNum(num: summary.total_cases)
        totalChangeLabel.text = formatChange(num: change.total_cases)
        
        activeLabel.text = formatNum(num: summary.active_cases)
        activeChangeLabel.text = formatChange(num: change.active_cases)
        
        deathsLabel.text = formatNum(num: summary.deaths)
        deathsChangeLabel.text = formatChange(num: change.deaths)
        
        recLabel.text = formatNum(num: summary.recovered)
        recChangeLabel.text = formatChange(num: change.recovered)
        
        criticalLabel.text = formatNum(num: summary.critical)
        criticalChangeLabel.text = formatChange(num: change.critical)
        
        testedLabel.text = formatNum(num: summary.tested)
        testedChangeLabel.text = formatChange(num: change.tested)
        
        dRatioLabel.text = formatRatio(num: summary.death_ratio)
        dRatioChangeLabel.text = formatRatio(num: change.death_ratio)
        
        recRatioLabel.text = formatRatio(num: summary.recovery_ratio)
        recRatioChangeLabel.text = formatRatio(num: change.recovery_ratio)
    }
    
    func formatNum(num: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numString = String (numberFormatter.string(from: NSNumber(value: num)) ?? "")
        return numString
    }
    
    func formatChange(num: Int) -> String {
        
        var numString: String
        numString = formatNum(num: num)
        
        if num >= 0 {
            numString = "+\(numString)"
        }
        
        return numString
    }
    
    func formatRatio(num: Float) -> String {
        
        var numString: String
        
        if num >= 0 {
            numString = "+\(String(format: "%.2f", num*100))%"
        } else {
            numString = "\(String(format: "%.2f", num*100))%"
        }
        
        return numString
    }
}

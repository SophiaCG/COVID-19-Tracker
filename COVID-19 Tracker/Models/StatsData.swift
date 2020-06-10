//
//  StatsData.swift
//  COVID-19 Tracker
//
//  Created by SCG on 6/7/20.
//  Copyright © 2020 SCG. All rights reserved.
//

import Foundation

//MARK: - Display Protocol
protocol Display {
    var item: String { get }
}


//MARK: - Data

struct All: Decodable {
    var data: Data
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Data: Decodable {
    var summary: Summary
    var change: Summary
    
    enum CodingKeys: String, CodingKey {
        case summary
        case change
    }
}

struct Summary: Decodable {
    var total_cases: Int
    var active_cases: Int
    var deaths: Int
    var recovered: Int
    var critical: Int
    var tested: Int
    var death_ratio: Float
    var recovery_ratio: Float
    
    enum CodingKeys: String, CodingKey {
        case total_cases
        case active_cases
        case deaths
        case recovered
        case critical
        case tested
        case death_ratio
        case recovery_ratio
    }
}

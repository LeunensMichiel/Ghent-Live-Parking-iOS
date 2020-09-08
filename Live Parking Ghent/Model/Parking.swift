//
//  Parking.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import Foundation

struct ParkingList: Codable {
    let records: [Records]?
}

struct Records: Codable {
    let fields: Parking?
}

struct Parking: Codable {
    let name: String?
    let description: String?
    let totalcapacity: Int?
    let availablecapacity: Int?
}

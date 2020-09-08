//
//  ViewController.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import UIKit

class ParkingListViewController: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var parkingList: [Parking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        
        setupTableView()
        
        let fetchParkings = { (fetchedParkings: [Parking]) in
            DispatchQueue.main.async {
                self.parkingList = fetchedParkings
                self.tableView.reloadData()
            }
        }
        
        ParkingAPI.parkingAPI.fetchParkingList(onComplete: fetchParkings)
    }
    
    // MARK: - Setup View
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(ParkingCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

// MARK: - UITableView DataSource

extension ParkingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let parkingCell = cell as? ParkingCell else {
            return cell
        }
        
        parkingCell.nameLabel.text = parkingList[indexPath.row].name
        parkingCell.availabilityLabel.text = "Availability: \(parkingList[indexPath.row].availablecapacity!)/\(parkingList[indexPath.row].totalcapacity!)"
        
        let percentage = Double(parkingList[indexPath.row].availablecapacity!) / Double(parkingList[indexPath.row].totalcapacity!)
        switch percentage {
        case 0.25..<0.5:
            parkingCell.availabilityLabel.textColor = .orange
        case 0.5..<0.9:
            parkingCell.availabilityLabel.textColor = .brown
        case 0.9...1:
            parkingCell.availabilityLabel.textColor = .red
        default:
            parkingCell.availabilityLabel.textColor = .green
        }
        
        return parkingCell
    }
}

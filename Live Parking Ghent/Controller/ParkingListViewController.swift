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
    let segmentedControl = UISegmentedControl(items: ["Alphabetically", "Location", "Availability"])
    var safeArea: UILayoutGuide!
    var parkingList: [Parking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        
        setupSegmentedControlView()
        setupTableView()
        
        let fetchParkings = { (fetchedParkings: [Parking]) in
            DispatchQueue.main.async {
                self.parkingList = fetchedParkings
                self.sortParkings()
                self.tableView.reloadData()
            }
        }
        
        ParkingAPI.parkingAPI.fetchParkingList(onComplete: fetchParkings)
    }
    
    // MARK: - Setup View
    
    func setupSegmentedControlView() {
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.sortParkings()
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(ParkingCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    fileprivate func sortParkings() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 1: break
        case 2:
            self.parkingList = self.parkingList.sorted {
                $0.availablecapacity! > $1.availablecapacity!
            }
            break
        default:
            self.parkingList = self.parkingList.sorted {
                $0.name! < $1.name!
            }
            break
        }
    }
}

// MARK: - UITableView DataSource

extension ParkingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let parking = parkingList[indexPath.row]
        let used = parking.totalcapacity! - parking.availablecapacity!
        
        guard let parkingCell = cell as? ParkingCell else {
            return cell
        }
        
        parkingCell.nameLabel.text = parking.name
        parkingCell.availabilityLabel.text = "Availability: \(used)/\(parking.totalcapacity!)"
        
        let percentage = Double(used) / Double(parking.totalcapacity!)
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

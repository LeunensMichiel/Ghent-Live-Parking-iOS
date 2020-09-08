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
    var parkingList : [Parking] = []
    

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

// MARK: - UITableView DataSource

extension ParkingListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = parkingList[indexPath.row].name
        return cell
    }
    
    
}

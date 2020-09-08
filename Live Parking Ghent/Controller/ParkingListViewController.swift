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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        tableView.dataSource = self
        setupView()
    }
    // MARK: - Setup View
    func setupView() {
        view.addSubview(tableView)
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Parking Ghent"
        return cell
    }
    
    
}

//
//  ViewController.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import CoreLocation
import UIKit

class ParkingListViewController: UIViewController {
    let tableView = UITableView()
    let segmentedControl = UISegmentedControl(items: ["Alphabetically", "Location", "Availability"])
    let refreshControl = UIRefreshControl()
    var safeArea: UILayoutGuide!
    var parkingList: [Parking] = []
    let locationManager = CLLocationManager()
    
    fileprivate func fetchParkings() {
        let fetchParkings = { (fetchedParkings: [Parking]) in
            DispatchQueue.main.async {
                self.parkingList = fetchedParkings
                self.sortParkings()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        ParkingAPI.parkingAPI.fetchParkingList(onComplete: fetchParkings)
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "parkingFetched"),
            object: nil,
            queue: nil) { notification in
            print("notification received")
            if let uInfo = notification.userInfo, let fetchedParkings = uInfo["parkings"] as? [Parking] {
                self.parkingList = fetchedParkings
                self.sortParkings()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Ghent Parking"
        view.backgroundColor = UIColor.white
        safeArea = view.layoutMarginsGuide
        
        setupSegmentedControlView()
        setupTableView()
        checkLocationServices()
        
        fetchParkings()
    }
    
    // MARK: - Setup Views
    
    func setupSegmentedControlView() {
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(refreshParkings(_:)), for: .valueChanged)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ParkingCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = 64
    }
    
    // MARK: - Actions
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        sortParkings()
        tableView.reloadData()
    }
    
    @objc func refreshParkings(_ sender: Any) {
        fetchParkings()
    }
    
    // MARK: - Setup Sorting
    
    fileprivate func sortParkings() {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            checkLocationServices()
        case 2:
            parkingList = parkingList.sorted {
                $0.availablecapacity! > $1.availablecapacity!
            }
        default:
            parkingList = parkingList.sorted {
                $0.name! < $1.name!
            }
        }
    }
    
    // MARK: - Location
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorisation()
        } else {
            let alert = UIAlertController(title: "Location Denied", message: "For location functionality to work, enable location for this app in system permissions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "Location Restricted", message: "For location functionality to work, enable location for this app in system permissions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            break
        case .denied:
            let alert = UIAlertController(title: "Location Denied", message: "For location functionality to work, enable location for this app in system permissions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            if let location = locationManager.location {
                sortOnLocation(userLocation: location)
            }
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    func sortOnLocation(userLocation: CLLocation) {
        parkingList = parkingList.sortedByDistance(to: userLocation)
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

extension ParkingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ParkingDetailViewController()
        vc.selectedParking = parkingList[indexPath.row]
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITableView LocationManager

extension ParkingListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        sortOnLocation(userLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
}

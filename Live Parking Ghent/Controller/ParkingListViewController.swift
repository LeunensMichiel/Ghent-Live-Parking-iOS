import CoreData
import MapKit
import UIKit

class ParkingListViewController: UIViewController {
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let mapView = MKMapView()
    let segmentedControl = UISegmentedControl(items: ["Alphabetically", "Location", "Availability"])
    let parkingLabel = UILabel()
    let noParkingsLabel = UILabel()
    
    let scrollView = UIScrollView()
    let contentView = UIStackView()
    var safeArea: UILayoutGuide!
    
    var parkingList: [Parking] = []
    var savedParking: ParkingDM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ghent Parking"
        view.backgroundColor = UIColor.white
        
        safeArea = view.layoutMarginsGuide
        setupScrollView()
        setupSegmentedControlView()
        setupTableView()
        setupParkingLabel()
        setupPlaceholderLabel()
        
        checkLocationServices()
        fetchParkings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedParking = CoreDataManager.sharedCoreData.fetchParkings()?.first
        guard let localParking = savedParking else {
            return
        }
        if localParking.isParked {
            noParkingsLabel.removeFromSuperview()
            setupMapView()
        } else {
            mapView.removeFromSuperview()
            setupPlaceholderLabel()
        }
    }
    
    // MARK: - Setup Views
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.distribution = .equalCentering
        contentView.alignment = .fill
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // constrain width of stack view to width of self.view, NOT scroll view
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setupSegmentedControlView() {
        contentView.addArrangedSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(named: "AccentDark")
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(refreshParkings(_:)), for: .valueChanged)
    }
    
    func setupTableView() {
        contentView.addArrangedSubview(tableView)
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = 64
        
        tableView.addSubview(refreshControl)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ParkingCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func setupMapView() {
        contentView.addArrangedSubview(mapView)
        let initialLocation = CLLocation(latitude: savedParking!.latitude, longitude: savedParking!.longitude)
        mapView.centerToLocation(initialLocation)
        let parkingAnnotation = MKPointAnnotation()
        parkingAnnotation.title = savedParking!.name
        parkingAnnotation.coordinate = CLLocationCoordinate2D(latitude: savedParking!.latitude, longitude: savedParking!.longitude)
        mapView.addAnnotation(parkingAnnotation)
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 8).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(30)).isActive = true
    }
    
    func setupParkingLabel() {
        contentView.addArrangedSubview(parkingLabel)
        parkingLabel.text = "Jouw Parking"
        parkingLabel.font = UIFont(name: "Nunito-Bold", size: 17)
        
        parkingLabel.translatesAutoresizingMaskIntoConstraints = false
        parkingLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32).isActive = true
        parkingLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        parkingLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    func setupPlaceholderLabel() {
        contentView.addArrangedSubview(noParkingsLabel)
        noParkingsLabel.text = "Je staat momenteel nergens geparkeerd."
        noParkingsLabel.font = UIFont(name: "Nunito-Regular", size: 12)
        
        noParkingsLabel.translatesAutoresizingMaskIntoConstraints = false
        noParkingsLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 32).isActive = true
        noParkingsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        noParkingsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        noParkingsLabel.textColor = .systemGray
    }
    
    // MARK: - Actions
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        sortParkings()
        tableView.reloadData()
    }
    
    @objc func refreshParkings(_ sender: Any) {
        fetchParkings()
    }
    
    // MARK: - Sorting
    
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
    
    func checkLocationServices() {
        if LocationService.shardedLocationService.checkLocationServices() {
            LocationService.locationManager.delegate = self
            checkLocationAuthorisation()
        } else {
            ShowLocationDeniedAlert()
        }
    }
    
    func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
        case .restricted:
            ShowLocationDeniedAlert()
        case .denied:
            ShowLocationDeniedAlert()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            if let location = LocationService.locationManager.location {
                if segmentedControl.selectedSegmentIndex == 1 {
                    sortOnLocation(userLocation: location)
                }
            }
            LocationService.locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    func sortOnLocation(userLocation: CLLocation) {
        parkingList = parkingList.sortedByDistance(to: userLocation)
    }
    
    fileprivate func ShowLocationDeniedAlert() {
        let alert = UIAlertController(title: "Location Denied", message: "For location functionality to work, enable location for this app in system permissions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - ParkingAPI
    
    fileprivate func fetchParkings() {
        let fetchParkings = { (fetchedParkings: [Parking]) in
            DispatchQueue.main.async {
                self.parkingList = fetchedParkings
                self.sortParkings()
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height).isActive = true
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
            if let uInfo = notification.userInfo, let fetchedParkings = uInfo["parkings"] as? [Parking] {
                self.parkingList = fetchedParkings
                self.sortParkings()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Controller Extensions

// MARK: - UITableView DataSource and Delegation

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
        case 0.66..<0.9:
            parkingCell.status.backgroundColor = UIColor(named: "StatusOrange")
        case 0.9...1:
            parkingCell.status.backgroundColor = UIColor(named: "StatusRed")
        default:
            parkingCell.status.backgroundColor = UIColor(named: "StatusGreen")
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
        if segmentedControl.selectedSegmentIndex == 1 {
            sortOnLocation(userLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
}

extension ParkingListViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "parking")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "parking")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}

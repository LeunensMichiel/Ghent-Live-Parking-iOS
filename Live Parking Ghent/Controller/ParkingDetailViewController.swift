import CoreData
import MapKit
import UIKit

class ParkingDetailViewController: UIViewController {
    var selectedParking: Parking?
    var savedParking: ParkingDM?
    weak var delegate: ParkingListViewController!

    var safeArea: UILayoutGuide!

    let mapView = MKMapView()
    let nameLabel = UILabel()
    let availabilityLabel = UILabel()
    let contactTitle = UILabel()
    let locationTitle = UILabel()
    let addressLabel = UILabel()
    let contactLabel = UILabel()
    let parkButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 64))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        savedParking = CoreDataManager.sharedCoreData.fetchParkings()?.first
        safeArea = view.layoutMarginsGuide

        setupNameLabel()
        setupAvailabilityLabel()
        setupContactTitleLabel()
        setupAddressLabel()
        setupContactLabel()
        setupLocationTitleLabel()
        setupParkButton()
        setupMapView()
    }

    func setupNameLabel() {
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 24)
        nameLabel.text = selectedParking?.name
    }

    func setupAvailabilityLabel() {
        view.addSubview(availabilityLabel)
        let used = selectedParking!.totalcapacity! - selectedParking!.availablecapacity!

        availabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        availabilityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        availabilityLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        availabilityLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        availabilityLabel.textColor = .systemGray
        availabilityLabel.text = "Availability: \(used)/\(selectedParking!.totalcapacity!)"
    }

    func setupContactTitleLabel() {
        view.addSubview(contactTitle)

        contactTitle.translatesAutoresizingMaskIntoConstraints = false
        contactTitle.topAnchor.constraint(equalTo: availabilityLabel.bottomAnchor, constant: 16).isActive = true
        contactTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        contactTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        contactTitle.textColor = UIColor(named: "AccentDark")
        contactTitle.text = "Contactgegevens"
        contactTitle.font = UIFont(name: "Nunito-Bold", size: 14)
    }

    func setupAddressLabel() {
        view.addSubview(addressLabel)
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: contactTitle.bottomAnchor, constant: 4).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        addressLabel.text = selectedParking?.address
        addressLabel.textColor = .systemGray
    }

    func setupContactLabel() {
        view.addSubview(contactLabel)
        
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4).isActive = true
        contactLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        contactLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        contactLabel.text = selectedParking?.contactinfo
        contactLabel.textColor = .systemGray
    }

    func setupLocationTitleLabel() {
        view.addSubview(locationTitle)

        locationTitle.translatesAutoresizingMaskIntoConstraints = false
        locationTitle.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 16).isActive = true
        locationTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        locationTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        locationTitle.textColor = UIColor(named: "AccentDark")
        locationTitle.text = "Locatie"
        locationTitle.font = UIFont(name: "Nunito-Bold", size: 14)
    }

    func setupParkButton() {
        view.addSubview(parkButton)

        parkButton.translatesAutoresizingMaskIntoConstraints = false
        parkButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8).isActive = true
        parkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        parkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

        parkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        guard let localParking = savedParking else {
            parkButton.setTitle("Park Here", for: .normal)
            return
        }
        parkButton.layer.cornerRadius = 8
        parkButton.contentEdgeInsets = UIEdgeInsets(top: 16,left: 0,bottom: 16,right: 0)
        parkButton.setTitle(localParking.isParked && localParking.id == selectedParking?.id ? "Drive Away" : "Park Here", for: .normal)
        parkButton.backgroundColor = UIColor(named: localParking.isParked && localParking.id == selectedParking?.id ? "StatusRed" : "AccentDark")
    }

    func setupMapView() {
        view.addSubview(mapView)

        let initialLocation = CLLocation(latitude: (selectedParking?.geo_location?[0])!, longitude: (selectedParking?.geo_location?[1])!)
        mapView.centerToLocation(initialLocation)
        let parkingAnnotation = MKPointAnnotation()
        parkingAnnotation.title = selectedParking?.name
        parkingAnnotation.coordinate = CLLocationCoordinate2D(latitude: (selectedParking?.geo_location?[0])!, longitude: (selectedParking?.geo_location?[1])!)
        mapView.addAnnotation(parkingAnnotation)
        mapView.showsUserLocation = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 8).isActive = true
        mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: parkButton.topAnchor, constant: -16).isActive = true
    }

    @objc func buttonTapped(sender: UIButton) {
//        DispatchQueue.main.async {}
        if savedParking == nil {
            CoreDataManager.sharedCoreData.createParking(parking: selectedParking!)
            savedParking = CoreDataManager.sharedCoreData.fetchParkings()?.first
        }

        if savedParking?.id == selectedParking?.id {
            savedParking?.isParked = !savedParking!.isParked
            CoreDataManager.sharedCoreData.updateParking(parking: savedParking!)
        } else {
            CoreDataManager.sharedCoreData.deleteParking(parking: savedParking!)
            CoreDataManager.sharedCoreData.createParking(parking: selectedParking!)
        }
        savedParking = CoreDataManager.sharedCoreData.fetchParking(withId: selectedParking!.id!)!
        parkButton.setTitle(savedParking!.isParked ? "Drive Away" : "Park Here", for: .normal)
        parkButton.backgroundColor = UIColor(named: savedParking!.isParked && savedParking!.id == selectedParking?.id ? "StatusRed" : "AccentDark")
    }
}

// MARK: - Controller Extensions
// MARK: - Mapview


extension ParkingDetailViewController: MKMapViewDelegate {
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

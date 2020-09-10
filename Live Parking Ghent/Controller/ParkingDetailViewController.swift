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
    let addressLabel = UILabel()
    let contactLabel = UILabel()
    let parkButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 64))

    override func viewDidLoad() {
        super.viewDidLoad()
        savedParking = CoreDataManager.sharedCoreData.fetchParkings()?.first

        safeArea = view.layoutMarginsGuide
        view.backgroundColor = UIColor.white

        setupNameLabel()
        setupAddressLabel()
        setupContactLabel()
        setupParkButton()
        setupMapView()

    }

    func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        nameLabel.text = selectedParking?.name
    }

    func setupAddressLabel() {
        view.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        addressLabel.text = selectedParking?.address
    }

    func setupContactLabel() {
        view.addSubview(contactLabel)
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        contactLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        contactLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        contactLabel.text = selectedParking?.contactinfo
    }

    func setupParkButton() {
        view.addSubview(parkButton)

        parkButton.setTitleColor(.systemBlue, for: .normal)
        parkButton.translatesAutoresizingMaskIntoConstraints = false
        parkButton.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 8).isActive = true
        parkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true

        parkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        guard let localParking = savedParking else {
            parkButton.setTitle("Park Here", for: .normal)
            return
        }
        parkButton.setTitle(localParking.isParked && localParking.id == selectedParking?.id ? "Parked" : "Park Here", for: .normal)
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
        mapView.topAnchor.constraint(equalTo: parkButton.bottomAnchor, constant: 8).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc func buttonTapped(sender: UIButton) {
//        DispatchQueue.main.async {
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
        parkButton.setTitle(savedParking!.isParked ? "Parked" : "Park Here", for: .normal)
//        }
    }
}

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

//
//  ParkingDetailViewController.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import UIKit

class ParkingDetailViewController: UIViewController {
    var selectedParking: Parking?
    weak var delegate: ParkingListViewController!
    var safeArea: UILayoutGuide!

    let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = UIColor.white

        setupNameLabel()
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
}

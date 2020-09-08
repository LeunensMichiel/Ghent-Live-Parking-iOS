//
//  ParkingCell.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import UIKit

class ParkingCell: UITableViewCell {
    let nameLabel = UILabel()
    let availabilityLabel = UILabel()
    var safeArea: UILayoutGuide!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func setupView() {
        safeArea = layoutMarginsGuide
        setupNameLabel()
        setupAvailabilityLabel()
    }

    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 16)
    }

    func setupAvailabilityLabel() {
        addSubview(availabilityLabel)
        availabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        availabilityLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        availabilityLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        availabilityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        availabilityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true

        availabilityLabel.font = availabilityLabel.font.withSize(12)
    }
}

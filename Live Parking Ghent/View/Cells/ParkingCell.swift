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
    let wrapper = UIStackView()
    let stackView = UIStackView()
    let status = UIImageView()
    
    var safeArea: UILayoutGuide!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    func setupView() {
        safeArea = layoutMarginsGuide
        
        accessoryType = .disclosureIndicator
        
        setupNameLabel()
        setupAvailabilityLabel()
        setupWrapper()
        setupStatus()
        setupStackView()
    }
    
    func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 17)
    }
    
    func setupAvailabilityLabel() {
        availabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        availabilityLabel.font = availabilityLabel.font.withSize(14)
        availabilityLabel.textColor = .systemGray
    }
    
    func setupStackView() {
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(availabilityLabel)
    }
    
    func setupStatus() {
        addSubview(status)
        
        status.widthAnchor.constraint(equalToConstant: CGFloat(8)).isActive = true
        status.heightAnchor.constraint(equalToConstant: CGFloat(48)).isActive = true
        status.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor).isActive = true
    }
    
    func setupWrapper() {
        addSubview(wrapper)
        wrapper.axis = .horizontal
        wrapper.alignment = .leading
        
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        wrapper.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 32).isActive = true
        wrapper.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wrapper.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        wrapper.addArrangedSubview(status)
        wrapper.addArrangedSubview(stackView)
    }
}

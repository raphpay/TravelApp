//
//  WeatherCollectionViewCell.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let localCellID = "localCellID"
    static let destinationCellID = "destinationCellID"
    
    // MARK: - Views
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: WeatherIcons.cloud.rawValue)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.text = "12°C"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func configure(icon: UIImage, degrees: Double, time: String) {
        weatherImage.image = icon
        degreesLabel.text = "\(degrees)°C"
        if let intTime = Int(time) {
            dateLabel.text = "\(intTime)H"
        } else {
            dateLabel.text = time
        }
    }
    
    private func configureCellUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(weatherImage)
        contentView.addSubview(degreesLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            
            degreesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            degreesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            degreesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: degreesLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

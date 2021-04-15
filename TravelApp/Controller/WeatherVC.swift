//
//  WeatherVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width

class WeatherVC : UIViewController {
    
    private let destinationCellID = "destinationCellID"
    
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationToggleButton: UIButton!
    @IBAction func destinationButtonTapped(_ sender: UIButton) {
        print("Tapped 1")
    }
    
    @IBOutlet weak var localImageView: UIImageView!
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localCityLabel: UILabel!
    @IBOutlet weak var localToggleButton: UIButton!
    @IBAction func localButtonTapped(_ sender: UIButton) {
        print("Tapped 2")
    }
    
    private var destinationCollectionView: UICollectionView! = nil
    private var localCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        title = "Weather"
        configureCollectionViews()
    }
    
    private func configureCollectionViews() {
        let destinationLayout = UICollectionViewFlowLayout()
        destinationLayout.scrollDirection = .horizontal
        destinationLayout.itemSize = CGSize(width: 80, height: 138)
        destinationLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let localLayout = UICollectionViewFlowLayout()
        localLayout.scrollDirection = .horizontal
        localLayout.itemSize = CGSize(width: 80, height: 138)
        localLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        destinationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: destinationLayout)
        localCollectionView = UICollectionView(frame: .zero, collectionViewLayout: localLayout)
        
        self.view.addSubview(localCollectionView)
        self.view.addSubview(destinationCollectionView)
        
        destinationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        localCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            destinationCollectionView.topAnchor.constraint(equalTo: destinationToggleButton.bottomAnchor, constant: 5),
            destinationCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            destinationCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            destinationCollectionView.heightAnchor.constraint(equalToConstant: 138),
            
            localCollectionView.topAnchor.constraint(equalTo: localToggleButton.bottomAnchor, constant: 5),
            localCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            localCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            localCollectionView.heightAnchor.constraint(equalToConstant: 138)
        ])
        
        destinationCollectionView.showsHorizontalScrollIndicator = false
        destinationCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.localCellID)
        destinationCollectionView.backgroundColor = .clear
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        
        localCollectionView.showsHorizontalScrollIndicator = false
        localCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.localCellID)
        localCollectionView.backgroundColor = .clear
        localCollectionView.delegate = self
        localCollectionView.dataSource = self
    }
}

extension WeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == destinationCollectionView {
            let destinationCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.localCellID, for: indexPath) as! WeatherCollectionViewCell
            destinationCell.configure(icon: UIImage(named: "cloud.rain.fill")!, degrees: "\(indexPath.item)", time: "dest")
            return destinationCell
        } else {
            let localCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.localCellID, for: indexPath) as! WeatherCollectionViewCell
            localCell.configure(icon: UIImage(named: "cloud.rain.fill")!, degrees: "\(indexPath.item)", time: "Local")
            return localCell
        }
    }
}


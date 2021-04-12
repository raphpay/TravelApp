//
//  WeatherVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width

class WeatherVC : UIViewController {
    
    private let localCellID = "localCellID"
    private let destinationCellID = "destinationCellID"
    
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationToggleButton: UIButton!
    @IBAction func destinationButtonTapped(_ sender: UIButton) {
        print("Tapped 1")
    }
    @IBOutlet weak var destinationCollectionView: UICollectionView!
    
    @IBOutlet weak var localImageView: UIImageView!
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localCityLabel: UILabel!
    @IBOutlet weak var localToggleButton: UIButton!
    @IBAction func localButtonTapped(_ sender: UIButton) {
        print("Tapped 2")
    }
    @IBOutlet weak var localCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        title = "Weather App"
        localCollectionView.delegate = self
        localCollectionView.dataSource = self
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
    }
}

extension WeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == localCollectionView {
            // remplissage de cellule du haut
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: localCellID, for: indexPath) as! WeatherCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: destinationCellID, for: indexPath) as! WeatherCollectionViewCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 128)
    }
}


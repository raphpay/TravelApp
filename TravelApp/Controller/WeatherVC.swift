//
//  WeatherVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

class WeatherVC : UIViewController {
    
    let screenWidth = UIScreen.main.bounds.size.width
    @IBOutlet weak var cloudImage: UIImageView!
    @IBOutlet weak var localCollectionView: UICollectionView!
    @IBOutlet weak var destinationCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        cloudImage.tintColor = .orange
        localCollectionView.delegate = self
        localCollectionView.dataSource = self
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
    }
}

extension WeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == localCollectionView {
            // remplissage de cellule du haut
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localCell", for: indexPath) as! WeatherCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "destinationCell", for: indexPath) as! WeatherCollectionViewCell
            return cell
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
}


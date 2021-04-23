//
//  WeatherVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width

enum ButtonTitle: String {
    case week = "Week"
    case today = "Today"
}

class WeatherVC : UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationToggleButton: UIButton!
    
    
    @IBOutlet weak var localImageView: UIImageView!
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localCityLabel: UILabel!
    @IBOutlet weak var localToggleButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func destinationButtonTapped(_ sender: UIButton) {
        if destinationDisplay == .week {
            destinationDisplay = .today
            destinationToggleButton.setTitle(ButtonTitle.today.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .newYork, for: .hour) { (success, _objects) in
                guard success,
                      let objects = _objects else { return }
                self.destinationWeatherObjects = objects
                self.destinationCollectionView.reloadData()
            }
        } else {
            destinationDisplay = .week
            destinationToggleButton.setTitle(ButtonTitle.week.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .newYork, for: .day) { (success, _objects) in
                guard success,
                      let objects = _objects else { return }
                self.destinationWeatherObjects = objects
                self.destinationCollectionView.reloadData()
            }
        }
    }
    @IBAction func localButtonTapped(_ sender: UIButton) {
        if localDisplay == .week {
            localDisplay = .today
            localToggleButton.setTitle(ButtonTitle.today.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .local, for: .hour) { (success, _objects) in
                guard success,
                      let objects = _objects else { return }
                self.localWeatherObjects = objects
                self.localCollectionView.reloadData()
            }
        } else {
            localDisplay = .week
            localToggleButton.setTitle(ButtonTitle.week.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .local, for: .day) { (success, _objects) in
                guard success,
                      let objects = _objects else { return }
                self.localWeatherObjects = objects
                self.localCollectionView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - Properties
    private var destinationCollectionView: UICollectionView! = nil
    private var localCollectionView: UICollectionView! = nil
    private var destinationDisplay : ButtonTitle = .week
    private var localDisplay : ButtonTitle = .week
    
    private let thunderstormRange = 200...232
    private let drizzleRange = 300...321
    private let rainRange = 500...531
    private let snowRange = 600...622
    private let smokeRange = 711
    private let fogRange = 741
    private let clearRange = 800
    private let cloudRange = 801...804
    
    var destinationWeatherObjects: [WeatherCardObject] = []
    var localWeatherObjects: [WeatherCardObject] = []
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        title = "Weather"
        configureCollectionViews()
        // Big weather
        WeatherService.shared.getWeather(in: .newYork, for: .current) { (success, _objects) in
            guard success,
                  let objects = _objects else { return }
            self.destinationImageView.image =  WeatherService.shared.convertIcon(id: objects[0].iconId)
            self.destinationTemperatureLabel.text = "\(objects[0].temperature)°C"
        }
        WeatherService.shared.getWeather(in: .local, for: .current) { (success, _objects) in
            guard success,
                  let objects = _objects else { return }
            self.localImageView.image =  WeatherService.shared.convertIcon(id: objects[0].iconId)
            self.localTemperatureLabel.text = "\(objects[0].temperature)°C"
        }
        
        // Collection views
        WeatherService.shared.getWeather(in: .newYork, for: .day) { (success, _objects) in
            guard success,
                let objects = _objects else { return }
            self.destinationWeatherObjects = objects
            self.destinationCollectionView.reloadData()
        }
        WeatherService.shared.getWeather(in: .local, for: .day) { (success, _objects) in
            guard success,
                let objects = _objects else { return }
            self.localWeatherObjects = objects
            self.localCollectionView.reloadData()
        }
    }
    
    
    // MARK: - Private methods
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


// MARK: - Collection View
extension WeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == destinationCollectionView {
            return destinationWeatherObjects.count
        } else {
            return localWeatherObjects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == destinationCollectionView {
            let destinationCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.localCellID, for: indexPath) as! WeatherCollectionViewCell
            let object = destinationWeatherObjects[indexPath.item]
            destinationCell.configure(icon: WeatherService.shared.convertIcon(id: object.iconId), degrees: object.temperature, time: object.date)
            return destinationCell
        } else {
            let localCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.localCellID, for: indexPath) as! WeatherCollectionViewCell
            let object = localWeatherObjects[indexPath.item]
            localCell.configure(icon: WeatherService.shared.convertIcon(id: object.iconId), degrees: object.temperature, time: object.date)
            return localCell
        }
    }
}


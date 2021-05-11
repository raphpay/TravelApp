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

enum ViewType {
    case bigView, collectionView
}


class WeatherVC : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationToggleButton: UIButton!
    @IBOutlet weak var destinationActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var localImageView: UIImageView!
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localCityLabel: UILabel!
    @IBOutlet weak var localToggleButton: UIButton!
    @IBOutlet weak var localActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    @IBAction func destinationButtonTapped(_ sender: UIButton) {
        if destinationDisplay == .week {
            destinationDisplay = .today
            destinationToggleButton.setTitle(ButtonTitle.today.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .newYork, for: .hour) { (success, _objects) in
                guard success,
                      let objects = _objects else {
                    self.presentAlert(message: TimePeriod.hour.errorMessage)
                    return
                }
                self.destinationWeatherObjects = []
                self.destinationWeatherObjects = objects
                self.destinationCollectionView.reloadData()
            }
        } else {
            destinationDisplay = .week
            destinationToggleButton.setTitle(ButtonTitle.week.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .newYork, for: .day) { (success, _objects) in
                guard success,
                      let objects = _objects else {
                    self.presentAlert(message: TimePeriod.day.errorMessage)
                    return
                }
                self.destinationWeatherObjects = []
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
                      let objects = _objects else {
                    self.presentAlert(message: TimePeriod.hour.errorMessage)
                    return
                }
                self.localWeatherObjects = []
                self.localWeatherObjects = objects
                self.localCollectionView.reloadData()
            }
        } else {
            localDisplay = .week
            localToggleButton.setTitle(ButtonTitle.week.rawValue, for: .normal)
            WeatherService.shared.getWeather(in: .local, for: .day) { (success, _objects) in
                guard success,
                      let objects = _objects else {
                    self.presentAlert(message: TimePeriod.day.errorMessage)
                    return
                }
                self.localWeatherObjects = []
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
    private let weatherService = WeatherService.shared
    
    var destinationWeatherObjects: [WeatherCardObject] = []
    var localWeatherObjects: [WeatherCardObject] = []
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        title = "Weather"
        configureCollectionViews()
        // Big weather
        self.toggleActivityIndicator(show: true, for: .newYork)
        weatherService.getWeather(in: .newYork, for: .current) { (success, _objects) in
            guard success,
                  let objects = _objects else {
                self.presentAlert(message: TimePeriod.current.errorMessage)
                return
            }
            self.toggleActivityIndicator(show: false, for: .newYork)
            self.destinationImageView.image =  WeatherService.shared.convertIcon(id: objects[0].iconId)
            self.destinationTemperatureLabel.text = "\(objects[0].temperature)°C"
        }
        
        self.toggleActivityIndicator(show: true, for: .local)
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            guard success,
                  let objects = _objects else {
                self.presentAlert(message: TimePeriod.current.errorMessage)
                return
            }
            self.toggleActivityIndicator(show: false, for: .local)
            self.localImageView.image =  WeatherService.shared.convertIcon(id: objects[0].iconId)
            self.localTemperatureLabel.text = "\(objects[0].temperature)°C"
        }
        
        // Collection views
        weatherService.getWeather(in: .newYork, for: .day) { (success, _objects) in
            guard success,
                let objects = _objects else {
                self.presentAlert(message: TimePeriod.day.errorMessage)
                return
            }
            self.destinationWeatherObjects = objects
            self.destinationCollectionView.reloadData()
        }
        
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            guard success,
                let objects = _objects else {
                self.presentAlert(message: TimePeriod.day.errorMessage)
                return
            }
            self.localWeatherObjects = objects
            self.localCollectionView.reloadData()
        }
    }
    
    
    // MARK: - Private methods
    private func configureCollectionViews() {
        // Create layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 138)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        // Create Collection views
        destinationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        localCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Add collection Views
        self.view.addSubview(localCollectionView)
        self.view.addSubview(destinationCollectionView)
        
        // Place constraints on collection views
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
        
        // Configure collection views
        destinationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        destinationCollectionView.showsHorizontalScrollIndicator = false
        destinationCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.localCellID)
        destinationCollectionView.backgroundColor = .clear
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        
        localCollectionView.translatesAutoresizingMaskIntoConstraints = false
        localCollectionView.showsHorizontalScrollIndicator = false
        localCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.localCellID)
        localCollectionView.backgroundColor = .clear
        localCollectionView.delegate = self
        localCollectionView.dataSource = self
    }
    
    private func toggleActivityIndicator(show : Bool, for city: City) {
        if city == .newYork {
            destinationActivityIndicator.isHidden = !show
            destinationImageView.isHidden = show
            destinationTemperatureLabel.alpha = show ? 0 : 1
            show ? destinationActivityIndicator.startAnimating() : destinationActivityIndicator.stopAnimating()
        } else {
            localActivityIndicator.isHidden = !show
            localImageView.isHidden = show
            localTemperatureLabel.isHidden = show
            show ? localActivityIndicator.startAnimating() : localActivityIndicator.stopAnimating()
        }
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
            guard let image = WeatherService.shared.convertIcon(id: object.iconId) else { return UICollectionViewCell() }
            destinationCell.configure(icon: image, degrees: object.temperature, time: object.date)
            return destinationCell
        } else {
            let localCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.localCellID, for: indexPath) as! WeatherCollectionViewCell
            let object = localWeatherObjects[indexPath.item]
            guard let image = WeatherService.shared.convertIcon(id: object.iconId) else { return UICollectionViewCell() }
            localCell.configure(icon: image, degrees: object.temperature, time: object.date)
            return localCell
        }
    }
}


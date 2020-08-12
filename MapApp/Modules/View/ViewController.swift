//
//  ViewController.swift
//  MapApp
//
//  Created by Alan Silva on 10/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let coreLocationManager = CLLocationManager()
    private var localizedPlaces: Places?
    
    let mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }()
    
    let mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCV()
        setUpViewAndConstraints()
        //setUpCoreLocation()
        checkLocationServices()
        
        getPlaces()
        
    }
    
    private func getPlaces() {
        
        let coordinates = Coordinates(latitude: -23.609900, longitude: -46.601150)
        
        NetWorkService.shared.getPlacesNearMe(for: coordinates) { result in
            
            switch result {
                
            case .success(let places):
                
                self.localizedPlaces = places
                self.setPinsForAddresses()
    
            case .failure(let error):
                print(error.rawValue)
                self.showAlert()
            }
            
        }
        
    }
    
    private func setUpCV() {
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.cellID)
    }
    
    private func setUpViewAndConstraints() {
        
        view.addSubview(mapView)
        view.addSubview(mainCollectionView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 120.0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25.0),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.0)
        ])
        
    }
    
    private func setPinsForAddresses() {
        
        var annotations = [MKAnnotation]()
        
        localizedPlaces?.businesses?.forEach({ place in
            
            guard let latitude = place.coordinates?.latitude else { return }
            guard let langitude = place.coordinates?.longitude else { return }
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: langitude)
            
            ///Create Pin
            let pin = MKPointAnnotation()
            pin.coordinate = center
            pin.title = place.name
            pin.subtitle = place.alias
            annotations.append(pin)
            
            mainCollectionView.reloadData()
            
        })
        
        
        mapView.addAnnotations(annotations)
        
    }
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setUpCoreLocation()
            checkLocationAuthorization()
            
        } else {
            showAlert()
        }
        
        
    }
    
    private func setUpCoreLocation() {
        
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.startUpdatingLocation()
        
    }
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            break
        case .restricted:
            showAlert()
        case .denied:
            showAlert()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        @unknown default:
            break
        }
        
    }
    
    private func showCurrentLocation(_ location: CLLocation) {
        
        let latitude = location.coordinate.latitude
        let langitude = location.coordinate.longitude
        
        let centerCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: langitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: centerCoordinates, span: span)
        
        mapView.setRegion(region, animated: true)
        
//        ///Pin
//        let pin = MKPointAnnotation()
//        pin.coordinate = centerCoordinates
//        pin.title = "You ara here!"
//        pin.subtitle = "Look around."
//
//        //mapView.addAnnotation(pin)
        
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "Precisamos de sua localização", message: "Notamos que não autorizou sua localização. Para continuar a usar o aplicativo precisaremos que vá em configurações > Privacidade > Habilitar nosso app.", preferredStyle: .alert)
        
        let btnOk = UIAlertAction(title: "Aceitar", style: .default) { ( _ ) in
            self.setUpCoreLocation()
        }
        
        alert.addAction(btnOk)
        
        self.present(alert, animated: true)
        
    }
    
}

//MARK: - CollectionView Methods
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return localizedPlaces?.businesses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.cellID, for: indexPath) as! DetailCollectionViewCell
        
        let place = localizedPlaces?.businesses?[indexPath.row]
        
        cell.setupView()
        cell.nameLabel.text = place?.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 5, height: view.frame.height - 10)
    }
    
}

//MARK: - CoreLocation Methods
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            coreLocationManager.stopUpdatingLocation()
            
            showCurrentLocation(location)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

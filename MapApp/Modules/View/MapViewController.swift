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
import SDWebImage

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
    
    lazy var mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var locationImgPin: UIButton = {
        let buttom = UIButton(frame: .zero)
        buttom.setImage(UIImage(systemName: "location.fill"), for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(pointToActualLocation), for: .touchUpInside)
        
        return buttom
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9768511653, green: 0.9615669847, blue: 0.9277536869, alpha: 1)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCV()
        setUpViewAndConstraints()
        //getPlaces()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
        
    }
    
    private func getPlaces(coordinates: Coordinates) {
        
        //let coordinates = Coordinates(latitude: -23.609900, longitude: -46.601150)
        
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
        mapView.delegate = self
        
        mainCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.cellID)
    }
    
    private func setUpViewAndConstraints() {
        
        view.addSubview(mapView)
        mapView.addSubview(locationImgPin)
        view.addSubview(mainCollectionView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            locationImgPin.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 60.0),
            locationImgPin.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20.0),
            locationImgPin.heightAnchor.constraint(equalToConstant: 20.0),
            locationImgPin.widthAnchor.constraint(equalToConstant: 20.0),
            
            mainCollectionView.heightAnchor.constraint(equalToConstant: 120.0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25.0),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
        
    }
    
    private func setPinsForAddresses() {
        
        var annotations = [MKAnnotation]()
        
        localizedPlaces?.businesses?.forEach({ place in
            
            guard let latitude = place.coordinates?.latitude else { return }
            guard let langitude = place.coordinates?.longitude else { return }
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: langitude)
            
            //Create Pin
            let pin = MKPointAnnotation()
            pin.coordinate = center
            pin.title = place.name
            pin.subtitle = place.phone
            annotations.append(pin)
            
        })
        
        mainCollectionView.reloadData()
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
        
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.startUpdatingLocation()
        
    }
    
    @objc private func pointToActualLocation() {
        
        mapView.showsUserLocation = true
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
        locationImgPin.setImage(UIImage(systemName: "location.fill"), for: .normal)
        
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
        cell.detailabel.text = place?.phone
        cell.image.sd_setImage(with: URL(string: place?.imageURL ?? ""), completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return .init(0.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width, height: 100.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let place = localizedPlaces?.businesses?[indexPath.row]
        
        guard let latitude = place?.coordinates?.latitude else { return }
        guard let langitude = place?.coordinates?.longitude else { return }
        
        let centerCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: langitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.100, longitudeDelta: 0.100)
        
        let region = MKCoordinateRegion(center: centerCoordinates, span: span)
        
        if indexPath.item != 0 {
            mapView.setRegion(region, animated: true)
        }
        
    }
    
}

//MARK: - CoreLocation Methods
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            coreLocationManager.stopUpdatingLocation()
            
            showCurrentLocation(location)
            
            let coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            getPlaces(coordinates: coordinates)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
        
    }
    
}

//MARK: - Mapkit delegate Methods

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        ///Clear pin when location changes
            locationImgPin.setImage(UIImage(systemName: "location"), for: .normal)
            
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        print("didUpdate userLocation")
        coreLocationManager.stopUpdatingLocation()
        print("Parou de atualizar user location")
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        print("Terminou de carregar o mapa")
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        print("ChangeVisibleRegion mapa")
        
    }
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //
    //    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        var seq = 0
        var index = 0
        
        localizedPlaces?.businesses?.forEach({ place in
            
            if place.name == view.annotation?.title {
                index = seq
            }
            
            seq += 1
                
        })
        
        UIView.animate(withDuration: 10.5) {
        
            self.mainCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
    
}

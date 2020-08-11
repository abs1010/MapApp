//
//  ViewController.swift
//  MapApp
//
//  Created by Alan Silva on 10/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
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
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCV()
        setUpViewAndConstraints()
        
        getPlaces()
    }
    
   private func getPlaces() {
        
        let coordinates = Coordinates(latitude: -23.609900, longitude: -46.601150)
        
        NetWorkService.shared.getPlacesNearMe(for: coordinates) { result in
            
            switch result {
                
            case .success(let places):
                print(places)
                print("#Total de Registros -> #\(places.total)")
                
            case .failure(let error):
                print(error.rawValue)
            }
            
        }
        
    }
    
    private func setUpCV() {
    
        mainCollectionView.delegate = self
        mainCollectionView.delegate = self
    }
    
    private func setUpViewAndConstraints() {
        
        view.addSubview(mapView)
        view.addSubview(mainCollectionView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 180.0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
}

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell(frame: .zero)
        cell.backgroundColor = .green
        
        return cell
    }
    
    
}

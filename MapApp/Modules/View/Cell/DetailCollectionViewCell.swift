//
//  DetailCollectionViewCell.swift
//  MapApp
//
//  Created by Alan Silva on 11/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "DetailCollectionViewCellID"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nome"
        label.textColor = .darkGray
        
        return label
    }()
    
    let detailabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Detalhe"
        label.textColor = .systemBlue
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.backgroundColor = .cyan
        self.layer.cornerRadius = 6.0
        
        self.addSubview(nameLabel)
        self.addSubview(detailabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
}

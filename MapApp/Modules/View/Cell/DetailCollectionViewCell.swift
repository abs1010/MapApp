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
    
    lazy var mainView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9768511653, green: 0.9615669847, blue: 0.9277536869, alpha: 1)
        
        return view
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nome"
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    let detailabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Detalhe"
        label.textColor = .label
        
        return label
    }()
    
    let ratinglabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "⭐️"
        label.sizeToFit()
        label.textColor = .label
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        mainView.layer.cornerRadius = 8.0
        mainView.backgroundColor = UIColor(white: 1, alpha: 0.8)

        image.clipsToBounds = true
        image.layer.cornerRadius = 40.0
        
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.addSubview(mainView)
        mainView.addSubview(image)
        mainView.addSubview(nameLabel)
        mainView.addSubview(detailabel)
        mainView.addSubview(ratinglabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10.0),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            image.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10.0),
            image.heightAnchor.constraint(equalToConstant: 80.0),
            image.widthAnchor.constraint(equalToConstant: 80.0),            
            nameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20.0),
            nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20.0),
            nameLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10.0),
            detailabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20.0),
            detailabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
            ratinglabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20.0),
            ratinglabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20.0)
        ])
        
    }
    
    func setupCell(_ business: Business) {
        
        nameLabel.text = business.name
        detailabel.text = business.displayPhone
        
        if let rate = business.rating {
            ratinglabel.text = "\(rate) ⭐️"
        }
        
        if !(business.imageURL?.isEmpty ?? false) {
            image.sd_setImage(with: URL(string: business.imageURL ?? ""), completed: nil)
        } else {
            image.image = UIImage(named: "map")
        }
        
    }
    
}

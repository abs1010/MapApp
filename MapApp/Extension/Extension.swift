//
//  Extension.swift
//  MapApp
//
//  Created by Alan Silva on 14/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import MapKit

class ALPointAnnotation: MKPointAnnotation {
    
    let name: String
    let detail: String
    let index: Int
    let center: CLLocationCoordinate2D
    
    init(name: String, detail: String, index: Int, center: CLLocationCoordinate2D) {
        self.name = name
        self.detail = detail
        self.index = index
        self.center = center
        super.init()
    }
    
    convenience override init() {
        self.init(name: "", detail: "", index: 0, center: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
    
}

public enum AnimationFade {
    case fadeIn, fadeOut
}

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    /// Adds a bottom border line with a specific width and color.
    ///
    /// - Parameters:
    ///   - color: The color of the border.
    ///   - width: The width of the border.
    func addBottomBorder(withColor color: UIColor, andWidth width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    /// Animates the view with with fade in or fade out using the `alpha` variable.
    ///
    /// - Parameters:
    ///   - fade: Fade in or fade out.
    ///   - duration: The duration of the animation in seconds.
    func animate(_ fade: AnimationFade, withDuration duration: TimeInterval) {
        let newAlpha: CGFloat
        switch fade {
        case .fadeIn:
            newAlpha = 1.0
        case .fadeOut:
            newAlpha = 0.0
        }
        UIView.animate(withDuration: duration) {
            self.alpha = newAlpha
        }
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }
    
    func addDashedBorder(color:UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [2,3]
        
        let percent:CGFloat = self.frame.width * 15/100
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width + percent, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Inspectable variables

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return UIColor.clear
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        }
    }
}

extension UIScrollView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.endEditing(true)
    }
    
}


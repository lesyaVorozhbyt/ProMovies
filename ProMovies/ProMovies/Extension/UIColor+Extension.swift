//
//  UIColor+Extension.swift
//  ProMovies
//
//  Created by Антон Яценко on 16.03.2023.
//

import UIKit

extension UIColor {
    class var primaryBackgroundColor: UIColor {
        get {
            UIColor(named: "primaryBackgroundColor") ?? .green
        }
    }
    
    class var solidTextColor: UIColor {
        get {
            UIColor(ciColor: .white)
        }
    }
    
    class var opacity50TextColor: UIColor {
        get {
            UIColor(ciColor: .white).withAlphaComponent(0.5)
        }
    }
    
    class var opacity70TextColor: UIColor {
        get {
            UIColor(ciColor: .white).withAlphaComponent(0.7)
        }
    }
    
    class var tintColor: UIColor {
        get {
            UIColor(named: "tintColor") ?? .blue
        }
    }
    
    class var starsColor: UIColor {
        get {
            UIColor(named: "starsColor") ?? .yellow
        }
    }
}

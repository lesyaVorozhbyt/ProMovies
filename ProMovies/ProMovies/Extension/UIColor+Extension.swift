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
    
    class var header2TextColor: UIColor {
        get {
            UIColor(ciColor: .white)
        }
    }
    
    class var tintColor: UIColor {
        get {
            UIColor(named: "tintColor") ?? .blue
        }
    }
}

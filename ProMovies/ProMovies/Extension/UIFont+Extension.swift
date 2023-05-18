//
//  UIFont+Extension.swift
//  ProMovies
//
//  Created by Антон Яценко on 16.03.2023.
//

import UIKit

extension UIFont {
    class func header1(weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: 24, weight: weight)
    }
    
    class func header2(weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: 18, weight: weight)
    }
    
    class func header3(weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: 16, weight: weight)
    }
    
    class func bodyParagrapgh(weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: 14, weight: weight)
    }
    
    class func smallBodyParagraph(weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: 12, weight: weight)
    }
}

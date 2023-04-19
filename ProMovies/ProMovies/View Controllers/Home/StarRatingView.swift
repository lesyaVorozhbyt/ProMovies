//
//  StarRatingView.swift
//  ProMovies
//
//  Created by Lera Cuk on 19.04.2023.
//

import UIKit

class StarRatingView: UIView{
    
    private let starSize: CGSize = CGSize(width: 20, height: 20)

    private func createStarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: starSize.width),
            imageView.heightAnchor.constraint(equalToConstant: starSize.height)
        ])
        return imageView
    }

    func update(rating1: Double) {
        var rat1: Double = rating1 / 20.0
        let starCount = Int(rat1.rounded())
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        for _ in 1...5 {
            let starImageView = createStarImageView()
            stackView.addArrangedSubview(starImageView)
        }
        for i in 0..<starCount {
            if let starImageView = stackView.arrangedSubviews[i] as? UIImageView {
                starImageView.image = UIImage(named: "star-filled")
            }
        }
        self.subviews.forEach { $0.removeFromSuperview() }
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}

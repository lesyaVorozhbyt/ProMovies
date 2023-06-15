//
//  MovieDetailsExtension.swift
//  ProMovies
//
//  Created by Jane Strashok on 04.04.2023.
//

import UIKit

extension MovieDetailsViewController: UITableViewDelegate {
    
}

extension MovieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell, let castAndCrew = castAndCrew else { return UITableViewCell() }
        
        let castMember = castAndCrew.cast[indexPath.row]
        cell.realName.text = castMember.name
        cell.filmName.text = castMember.character
        
        guard let profilePicture = URL(string: "https://www.themoviedb.org/t/p/w66_and_h66_face\(castMember.profilePath!)") else { return UITableViewCell() }
        let queue = DispatchQueue(label: "com.download.image")
        queue.async {
            if let data = try? Data(contentsOf: profilePicture) {
                DispatchQueue.main.async { [weak self] in
                    guard let _ = self else { return }
                    cell.photo.image = UIImage(data: data) ?? UIImage(systemName: "")
                }
            }
        }
        
        cell.photo.layer.masksToBounds = false
        cell.photo.layer.cornerRadius = 49/2
        cell.photo.layer.borderWidth = 1
        cell.photo.layer.borderColor = UIColor.clear.cgColor
        cell.photo.clipsToBounds = true
        cell.photo.contentMode = .scaleAspectFit
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 42))
        
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: 120, height: 18))
        label.text = "Cast & Crew"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        
        let button = UIButton(frame: CGRect(x: 290, y: 2, width: 70, height: 18))
        button.setTitle("View All", for: .normal)
        button.setTitleColor(UIColor(named: "tintColor"), for: .normal)
        button.tag = 1
        
        view.addSubview(label)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
        
        return view
    }
    
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    
}

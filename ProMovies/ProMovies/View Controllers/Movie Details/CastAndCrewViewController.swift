//
//  CastAndCrewViewController.swift
//  ProMovies
//
//  Created by Jane Strashok on 06.04.2023.
//

import UIKit

class CastAndCrewViewController: UIViewController {
    
    var castAndCrew: CastAndCrewMembers?
    var sections: [SectionType]?
    var photosUrls: [[URL]] {
        castAndCrew?.getAllMembers().map({
            $0.map {
                URL(string: "https://www.themoviedb.org/t/p/w66_and_h66_face\($0.profilePath ?? "")" )!
            }
        }) ?? [[URL]]()
    }
    
    var profilePhotos = [[UIImage]]()

    @IBOutlet weak var tableView: UITableView!
    
    enum SectionType {
        case cast([CastAndCrewMembers.CastMember])
        case crew([CastAndCrewMembers.CrewMember])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        // Do any additional setup after loading the view.
    }
    
    private func configTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        guard let castAndCrew = castAndCrew else { return }
        sections = [.cast(castAndCrew.cast), .crew(castAndCrew.crew)]
        downloadImages()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CastAndCrewViewController: UITableViewDelegate {
    
}

extension CastAndCrewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections?[section] {
        case let .cast(cast):
            return cast.count
        case let .crew(crew):
            return crew.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell, let castAndCrew = castAndCrew else { return UITableViewCell() }
        
        let currentMember = castAndCrew.getAllMembers()[indexPath.section][indexPath.row]
        cell.realName.text = currentMember.name
        
        switch sections?[indexPath.section] {
        case let .cast(cast):
            let member = cast[indexPath.row]
            cell.realName.text = member.name
            cell.filmName.text = member.character
            cell.photo.image = profilePhotos[0][indexPath.row]
        case let .crew(crew):
            let member = crew[indexPath.row]
            cell.realName.text = member.name
            cell.filmName.text = member.job
            cell.photo.image = profilePhotos[1][indexPath.row]
        default:
            break
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 67))
        let label = UILabel(frame: CGRect(x: 0, y: 4, width: 120, height: 18))
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        switch sections?[section] {
        case .cast:
            label.text = "Cast"
        case .crew:
            label.text = "Crew"
        default:
            break
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor(named: "primaryBackgroundColor")
        return view
    }
    
    private func downloadImages() {
        let queue = DispatchQueue(label: "com.download.images")
        for i in 0..<photosUrls.count {
            self.profilePhotos.append([UIImage]())
            for j in 0..<photosUrls[i].count {
                self.profilePhotos[i].append(UIImage())
                //TODO: -add placeholder image
                queue.async {
                    if let data = try? Data(contentsOf: self.photosUrls[i][j]) {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.profilePhotos[i][j] = UIImage(data: data) ?? UIImage()
                            self.tableView.reloadRows(at: [IndexPath(row: j, section: i)], with: .none)
                        }
                    }
                }
            }
        }
    }
}

//
//  CastMember.swift
//  ProMovies
//
//  Created by Jane Strashok on 04.04.2023.
//

import Foundation

struct CastAndCrewMembers: Codable {
    var cast: [CastMember]
    var crew: [CrewMember]
    
    func getPost(_ section: Int, _ row: Int) -> String {
        switch section {
        case 0:
            return cast[row].character
        case 1:
            return crew[row].job
        default:
            return ""
        }
    }
    
    func getAllMembers() -> [[Member]] {
        return [cast, crew]
    }
    
    struct CastMember: Codable, Member {
        var name: String
        var profilePath: String?
        let character: String
    }

    struct CrewMember: Codable, Member {
        var name: String
        var profilePath: String?
        let job: String
    }
}



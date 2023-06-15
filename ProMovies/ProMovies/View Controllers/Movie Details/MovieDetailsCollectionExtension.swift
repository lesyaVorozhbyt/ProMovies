//
//  MovieDetailsCollectionExtension.swift
//  ProMovies
//
//  Created by Jane Strashok on 09.06.2023.
//

import Foundation
import UIKit

extension MovieDetailsViewController: UICollectionViewDelegate {
    
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.key = videos[indexPath.row].key
        cell.playVideo()
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//       switch kind {
//                    
//       case UICollectionView.elementKindSectionHeader:
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath)
//                return headerView
//                
//         default:
//                assert(false, "Unexpected element kind")
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: videosCollectionView.frame.width, height: 50)
//    }
    
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 104
         let cellHeight: CGFloat = 72

         return CGSize(width: cellWidth, height: cellHeight)
     }
}

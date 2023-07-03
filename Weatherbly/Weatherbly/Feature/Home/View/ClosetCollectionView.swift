//
//  ClosetCollectionView.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/07/03.
//

import UIKit

private let reuseIdentifier = "Cell"

class ClosetCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: ClosetCollectionViewCell.self, for: indexPath)
        cell.attribute()
        return cell
    }
    

}

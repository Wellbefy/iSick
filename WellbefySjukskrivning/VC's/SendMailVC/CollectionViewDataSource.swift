//
//  CollectionViewDataSource.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-18.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, MailCellDelegate {
    var texts = [String]()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mailCell", for: indexPath) as! MailCell
        cell.text = texts[indexPath.item]
        cell.cellNumber = indexPath.item
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width - CGFloat(10), height: collectionView.frame.size.height)
        return size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        NotificationCenter.default.post(name: NSNotification.Name("newpage"), object: value)
    }
    
    func didChangeText(_ sender: MailCell) {
        guard let index = sender.cellNumber else { return }
        guard let text = sender.text else { return }
        texts[index] = text
    }
}

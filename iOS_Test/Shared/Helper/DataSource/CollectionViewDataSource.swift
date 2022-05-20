//
//  CollectionViewDataSource.swift
//  Raffek
//
//  Created by Asraful Alam on 23/1/21.
//

import Foundation

import UIKit


class CollectionViewDataSource<CellType,ViewModel>:NSObject, UICollectionViewDataSource where CellType: UICollectionViewCell {
    
    let cellIdentifier: String
    var items: [ViewModel]
    
    typealias  ConfigureCell = (CellType,ViewModel) -> ()
    
    let configureCell: ConfigureCell?
    
     init(cellIdentifier: String,items: [ViewModel],configureCell: @escaping ConfigureCell) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func updateItems(_ viewModel: [ViewModel])  {
        self.items = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("\(cellIdentifier) not found")
        }
        let vm = self.items[indexPath.row]
        self.configureCell?(cell,vm)
        return cell
        
    }
    
}

//
//  BattleListCollectionViewControllerDataSource.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 2/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

class BattleListCollectionViewControllerDataSource: NSObject, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let items = sections[indexPath.section].items
        let item = items[indexPath.item]
        
        return item
    }
    
    var sections: [CollectionViewSection]
    
    override init() {
        sections = []
        super.init()
    }
    
    
}

extension BattleListCollectionViewControllerDataSource: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 87)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsetsZero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct CollectionViewSection {
    let title: String
    let items: [NSCollectionViewItem]
}

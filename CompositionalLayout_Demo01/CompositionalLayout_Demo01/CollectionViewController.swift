//
//  CollectionViewController.swift
//  CompositionalLayout_Demo01
//
//  Created by ankit bharti on 12/10/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    private var numbers = [String]()
    
    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid3, grid5
        
        private var columnCount: Int {
            switch self {
            case .list:
                return 1
                
            case .grid3:
                return 3
                
            case .grid5:
                return 5
            }
        }
        
        func columnCount(for layoutEnvironment: NSCollectionLayoutEnvironment) -> Int {
            let wide = layoutEnvironment.container.contentSize.width > 800
            let column = columnCount
            return wide ? column * 2 : column
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...20 {
            numbers.append("\(i)")
        }
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.collectionViewLayout = createLayout3()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CollectionViewController -> \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CollectionViewController -> \(#function)")
    }
    
    private func createLayout1() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createLayout2() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    /// will manage more than one section
    private func createLayout3() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let columnCount = sectionLayoutKind.columnCount(for: layoutEnvironment)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupHeight: NSCollectionLayoutDimension = columnCount == 1 ? .absolute(60.0) : .fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
            group.interItemSpacing = .fixed(10.0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10.0
            section.contentInsets = NSDirectionalEdgeInsets(top: 20.0, leading: 10.0, bottom: 20.0, trailing: 10.0)
            
            return section
        }
        
        return layout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.configure(by: numbers[indexPath.row])
        return cell
    }
}

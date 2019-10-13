//
//  CollectionViewController.swift
//  CompositionalLayout_Demo01
//
//  Created by ankit bharti on 12/10/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.collectionViewLayout = createLayout3()
        self.collectionView.dataSource = dataSource
        configureModel()
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
        let badgeItem = self.createBadgeItem()
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badgeItem])
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createLayout2() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let badgeItem = self.createBadgeItem()
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badgeItem])
                
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
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
            let columnCount = sectionLayoutKind.columnCount(for: layoutEnvironment.container.contentSize.width)
            
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
    
    /// create supplementry item
    private func createBadgeItem() -> NSCollectionLayoutSupplementaryItem {
        let badgeAchor = NSCollectionLayoutAnchor(edges: [.top, .trailing],
                                                  fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                               heightDimension: .absolute(20))
        
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: "badge",
                                                        containerAnchor: badgeAchor)
        return badge
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<SectionLayoutKind, Model> {
        let dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Model>(collectionView: collectionView) { (cv, indexpath, model) -> UICollectionViewCell? in
            
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexpath) as? CollectionViewCell else {
                fatalError("cell couldn't find")
            }
                
            cell.configure(by: model.value)
            return cell
        }
        
        return dataSource
    }
    
    private func configureModel() {
        var listData = [Model]()
        var grid3Data = [Model]()
        var grid5Data = [Model]()
        
        for i in 1...10 {
            let listModel = Model(value: "\(i)")
            let grid3Model = Model(value: "\(i)")
            let grid5Model = Model(value: "\(i)")

            listData.append(listModel)
            grid3Data.append(grid3Model)
            grid5Data.append(grid5Model)
        }
        
        let dataList = DataList(list: listData, grid3: grid3Data, grid5: grid5Data)
        update(dataList: dataList)
    }
    
    private func update(dataList: DataList, animation: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Model>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        snapshot.appendItems(dataList.list, toSection: .list)
        snapshot.appendItems(dataList.grid3, toSection: .grid3)
        snapshot.appendItems(dataList.grid5, toSection: .grid5)
     
        self.dataSource.apply(snapshot, animatingDifferences: animation)
    }
}

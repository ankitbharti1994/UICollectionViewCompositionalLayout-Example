//
//  DataModel.swift
//  CompositionalLayout_Demo01
//
//  Created by ankit bharti on 13/10/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import Foundation
import QuartzCore

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
    
    func columnCount(for width: CGFloat) -> Int {
        let wide = width > 414
        let column = columnCount
        return wide ? column * 2 : column
    }
}

struct Model: Hashable {
    let value: String
    let uuid = UUID()
}

struct DataList {
    let list: [Model]
    let grid3: [Model]
    let grid5: [Model]
}

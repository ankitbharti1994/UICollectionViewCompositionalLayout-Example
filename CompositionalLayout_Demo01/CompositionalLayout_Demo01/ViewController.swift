//
//  ViewController.swift
//  CompositionalLayout_Demo01
//
//  Created by ankit bharti on 12/10/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController -> \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController -> \(#function)")
    }
}

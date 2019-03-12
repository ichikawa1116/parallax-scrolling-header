//
//  ThirdViewController.swift
//  parallax-scrolling-header
//
//  Created by Manami Ichikawa on 2019/03/11.
//  Copyright © 2019 Manami Ichikawa. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ThirdViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Third: \(String(indexPath.row))"
        return cell
    }
    
    
}




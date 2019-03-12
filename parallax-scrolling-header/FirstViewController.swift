//
//  FirstViewController.swift
//  parallax-scrolling-header
//
//  Created by Manami Ichikawa on 2019/03/11.
//  Copyright © 2019 Manami Ichikawa. All rights reserved.
//

import UIKit

protocol FirstViewProtocol: class {
    func didScroll(offsetY: CGFloat)
}

class FirstViewController: UIViewController {

    weak var delegate: FirstViewProtocol?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "First: \(String(indexPath.row))"
        return cell
    }
    
}

extension FirstViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(offsetY: scrollView.contentOffset.y)
    }
}

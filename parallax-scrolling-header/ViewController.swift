//
//  ViewController.swift
//  parallax-scrolling-header
//
//  Created by Manami Ichikawa on 2019/03/11.
//  Copyright © 2019 Manami Ichikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var menuView: UIView!
    @IBOutlet weak private var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    // スクロールできる範囲 maxHeaderHeight + maxMenuHeight
    private var maxHeaderHeight: CGFloat! // 動的
    private let minHeaderHeight: CGFloat = 0
    private let maxMenuHeight: CGFloat = 70
    private let minMenuHeight: CGFloat = 35
    private let previousScrollOffset: CGFloat = 0
    
    var pageViewController: SamplePageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        switch segueId {
        case "segue":
            let pageVC = segue.destination as! SamplePageViewController
            pageViewController = pageVC
            break
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        maxHeaderHeight = headerView.frame.height // ここでセットしていいか要検討
        pageViewController.firstViewController.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
//        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
        
        // 子ビューに対して
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
//        self.titleTopConstraint.constant = -openAmount + 10
//        self.logoImageView.alpha = percentage
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension ViewController: FirstViewProtocol {
    func didScroll(offsetY: CGFloat) {
        
        let scrollDiff = offsetY - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && offsetY > absoluteTop
        let isScrollingUp = scrollDiff < 0 && offsetY < absoluteBottom
        
        var newHeight = self.headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
        }
        
        // Header needs to animate
        if newHeight != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeight
            self.updateHeader()
            self.setScrollPosition(self.previousScrollOffset)
        }
        
        if offsetY <= maxHeaderHeight {
            scrollView.contentOffset.y = offsetY
            print(offsetY)
        }
        //pageViewController.firstViewController.tableView.contentOffset.y = 0
    }
}




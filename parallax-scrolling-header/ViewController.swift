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
    private var maxHeaderY: CGFloat! // 動的
    private let minHeaderY: CGFloat = 0
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
        maxHeaderY = headerView.frame.height // ここでセットしていいか要検討
        pageViewController.firstViewController.delegate = self
    }
    
    // タブの途中でスクロールが止まった時は出すか閉じるかどちらかにする
    func scrollViewDidStopScrolling() {
        // TODO: 計算がおかしい
//        let range = maxMenuHeight - minMenuHeight
//        let midPoint = minMenuHeight + (range / 2)
//
//        if self.headerHeightConstraint.constant > midPoint + maxHeaderY {
//            self.expandHeader()
//        } else {
//            self.collapseHeader()
//        }
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minMenuHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxMenuHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func updateHeader() {
        // タブのUIを変更する場合はここで
        let range = self.maxMenuHeight - self.minMenuHeight
        let openAmount = self.headerHeightConstraint.constant - self.minMenuHeight
        let percentage = openAmount / range
        
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }

}

extension ViewController: FirstViewProtocol {
    func didScroll(offsetY: CGFloat) {
        
        let scrollDiff = offsetY - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && offsetY > absoluteTop
        let isScrollingUp = scrollDiff < 0 && offsetY < absoluteBottom
        
        var newTabHeight = self.headerHeightConstraint.constant
        var newHaderY = CGFloat()
        if isScrollingDown {
            newHaderY = max(self.minHeaderY, offsetY - abs(scrollDiff))
            // 上のヘッダーが最小値の時(スクロールで画面から消えた時)に下のヘッダーが動き出す
            if newHaderY == minHeaderY {
                newTabHeight = max(self.minMenuHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            }
            
            if offsetY <= maxHeaderY {
                scrollView.contentOffset.y = offsetY
            }
        } else if isScrollingUp {
            
            // ヘッダーセクションが高さ最大の間、ヘッダーが動き出す
            newTabHeight = min(maxMenuHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            if newTabHeight == maxMenuHeight {
                newHaderY = min(self.maxHeaderY, offsetY + abs(scrollDiff))
            }
            newTabHeight = min(maxMenuHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
        }
        
        if newTabHeight != self.headerHeightConstraint.constant {
            // タブの高さが変更される
            headerHeightConstraint.constant = newTabHeight
            updateHeader()
            /* 子の動きを止める
            (高さが変更されている最中にTableViewもスクロールもすると、2倍速で動いているように見える) */
            pageViewController.firstViewController.setScrollPosition(previousScrollOffset)
        }
    }
}




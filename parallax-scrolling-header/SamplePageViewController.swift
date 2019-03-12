//
//  SamplePageViewController.swift
//  parallax-scrolling-header
//
//  Created by Manami Ichikawa on 2019/03/11.
//  Copyright © 2019 Manami Ichikawa. All rights reserved.
//

import UIKit

class SamplePageViewController: UIPageViewController {
    
    var firstViewController: FirstViewController!
    var secondViewController: SecondViewController!
    var thirdViewController: ThirdViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        firstViewController = getFirst()
        secondViewController = getSecond()
        thirdViewController = getThird()

        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func getFirst() -> FirstViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
    }
    
    private func getSecond() -> SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    private func getThird() -> ThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
    }

}

extension SamplePageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: FirstViewController.self) {
            // 1 -> 2
            return secondViewController
        } else if viewController.isKind(of: SecondViewController.self) {
            // 2 -> 3
            return thirdViewController
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ThirdViewController.self) {
            // 3 -> 2
            return secondViewController
        } else if viewController.isKind(of: SecondViewController.self) {
            // 2 -> 1
            return firstViewController
        } else {
            // 1 -> end of the road
            return nil
        }
    }
}

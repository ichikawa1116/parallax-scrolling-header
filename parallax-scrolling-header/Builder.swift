//
//  Builder.swift
//  parallax-scrolling-header
//
//  Created by Manami Ichikawa on 2019/03/12.
//  Copyright © 2019 Manami Ichikawa. All rights reserved.
//

import Foundation
import UIKit

struct Builder {
    static func build() -> ViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        return viewController
    }
}


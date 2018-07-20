//
//  LcStoryboard.swift
//  UniversalLinksSample
//
//  Created by makoto.kaneko on 2018/06/27.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard : StoryboardNameable {

    enum StoryboardName : String {
        case Main
    }

    convenience init(_ name: StoryboardName, bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }

}


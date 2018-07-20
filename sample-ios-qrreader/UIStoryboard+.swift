//
//  UIStoryboard+.swift
//  UniversalLinksSample
//
//  Created by makoto.kaneko on 2018/06/29.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardNameable where StoryboardName.RawValue == String {
    associatedtype StoryboardName : RawRepresentable
}

protocol StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}

extension UIStoryboard {
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIViewController : StoryboardIdentifiable {
}

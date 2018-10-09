//
//  UITableView+.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellIdentifiable where Self: UITableViewCell {
  static var tableViewCellIdentifier: String { get }
}

protocol TableViewHeaderFooterViewIdentifiable where Self: UITableViewHeaderFooterView {
  static var tableViewHeaderFooterViewIdentifier: String { get }
}

extension UITableView {

  func dequeueReusableCell<T: TableViewCellIdentifiable>(for indexPath: IndexPath) -> T {
    return dequeueReusableCell(withIdentifier: T.tableViewCellIdentifier, for: indexPath) as! T
  }

  func dequeueReusableHeaderFooterView<T: TableViewHeaderFooterViewIdentifiable>() -> T? {
    return dequeueReusableHeaderFooterView(withIdentifier: T.tableViewHeaderFooterViewIdentifier) as? T
  }
}

extension UITableViewCell: TableViewCellIdentifiable {
  static var tableViewCellIdentifier: String {
    get {
      return String(describing: self)
    }
  }
}

extension UITableViewHeaderFooterView: TableViewHeaderFooterViewIdentifiable {
  static var tableViewHeaderFooterViewIdentifier: String {
    get {
      return String(describing: self)
    }
  }
}

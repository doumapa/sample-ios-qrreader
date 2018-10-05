//
//  SearchViewModel.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import ReactiveSwift

struct SearchViewModel {

  var numberOfSections: ((in tableView: UITableView) -> Int)?
  var numberOfRowsInSection: ((_ section: Int) -> Int)?

  var heightForHeaderInSection: ((_ tableView: UITableView, section: Int) -> CGFloat)?
  var viewForHeaderInSection: ((_ tableView: UITableView, section: Int) -> UIView?)?

  var heightForRowAt: ((indexPath: IndexPath) -> CGFloat)?
  var cellForRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?

}

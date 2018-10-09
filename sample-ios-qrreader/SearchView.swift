//
//  SearchView.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

class SearchView: UIView {

  @IBOutlet weak var tableView: UITableView!
  
  // MARK: -

  var viewModel: SearchViewModel? {
    didSet {
      bind()
    }
  }

  var searchController: UISearchController!
  
  // MARK: -

  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }

  // MARK: -

  fileprivate func configure() {
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "キャンセル"
    
    searchController = UISearchController(searchResultsController: nil)
    searchController.hidesNavigationBarDuringPresentation = true
    searchController.dimsBackgroundDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false

    let searchBar = searchController.searchBar
    searchBar.placeholder = "お店を検索する"

    tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderView.tableViewHeaderFooterViewIdentifier)
    if #available(iOS 11.0, *) {
    } else {
      tableView.tableHeaderView = searchBar
      //searchBar.sizeToFit()
    }
  }
  
  fileprivate func bind() {
    
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SearchView: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let viewModel = viewModel, let numberOfSections = viewModel.numberOfSections else { return 0 }
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel, let numberOfRowsInSection = viewModel.numberOfRowsInSection else { return 0 }
    return numberOfRowsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel, let cellForRowAtIndexPath = viewModel.cellForRowAtIndexPath else { return UITableViewCell() }
    return cellForRowAtIndexPath(tableView, indexPath)
  }

}

extension SearchView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let viewModel = viewModel, let heightForHeaderInSection = viewModel.heightForHeaderInSection else { return 0 }
    return heightForHeaderInSection(section)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let viewModel = viewModel, let viewForHeaderInSection = viewModel.viewForHeaderInSection else { return nil }
    return viewForHeaderInSection(tableView, section)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let viewModel = viewModel, let heightForRowAtIndexPath = viewModel.heightForRowAtIndexPath else { return 0 }
    return heightForRowAtIndexPath(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let viewModel = viewModel, let didSelectRowAtIndexPathAction = viewModel.didSelectRowAtIndexPathAction else { return }
    didSelectRowAtIndexPathAction.apply(indexPath).start()
  }
  
}

struct SearchViewModel {

  var didSelectRowAtIndexPathAction: Action<IndexPath, Void, NoError>?
  
  var numberOfSections: (() -> Int)?
  var numberOfRowsInSection: ((_ section: Int) -> Int)?
  
  var heightForHeaderInSection: ((_ section: Int) -> CGFloat)?
  var viewForHeaderInSection: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
  
  var heightForRowAtIndexPath: ((_ indexPath: IndexPath) -> CGFloat)?
  var cellForRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?

}

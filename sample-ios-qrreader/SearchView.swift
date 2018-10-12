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

class SearchView: UIView, ViewModelable {
  
  typealias T = SearchViewModel

  @IBOutlet weak var tableView: UITableView!
  
  // MARK: -

  var viewModel: SearchViewModel? {
    didSet {
      bind()
    }
  }

  var searchController: UISearchController!
  
  fileprivate var heightForCells: [IndexPath:CGFloat] = [:]

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

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    print("Cell height: \(cell.frame.height)")
    if !heightForCells.keys.contains(indexPath) {
      heightForCells[indexPath] = cell.frame.height
    }
  }
  
//  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
////    guard let height = heightForCells[indexPath] else {
////      return UITableView.automaticDimension
////    }
//    return SearchViewCell.height
//  }
  
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
  
  var heightForRowAtIndexPath: ((_ indexPath: IndexPath) -> CGFloat)?
  var cellForRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?

}

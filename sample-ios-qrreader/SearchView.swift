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
  
  //fileprivate var heightForCells: [IndexPath:CGFloat] = [:]

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
    guard let viewModel = viewModel, let numberOfSectionsAction = viewModel.numberOfSectionsAction else { return 0 }
    var number = 0
    numberOfSectionsAction.apply().startWithResult { (result: Result<Int, ActionError<NoError>>) in
      guard let value = result.value else { return }
      number = value
    }
    return number
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel, let numberOfRowsInSectionAction = viewModel.numberOfRowsInSectionAction else { return 0 }
    var number = 0
    numberOfRowsInSectionAction.apply(section).startWithResult { (result: Result<Int, ActionError<NoError>>) in
      guard let value = result.value else { return }
      number = value
    }
    return number
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel, let cellForRowAtIndexPathAction = viewModel.cellForRowAtIndexPathAction else { return UITableViewCell() }
    var cell = UITableViewCell()
    cellForRowAtIndexPathAction.apply((tableView, indexPath)).startWithResult { (result: Result<UITableViewCell, ActionError<NoError>>) in
      guard let value = result.value else { return }
      cell = value
    }
    return cell
  }

}

extension SearchView: UITableViewDelegate {

//  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    print("Cell height: \(cell.frame.height)")
//    if !heightForCells.keys.contains(indexPath) {
//      heightForCells[indexPath] = cell.frame.height
//    }
//  }
  
//  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
////    guard let height = heightForCells[indexPath] else {
////      return UITableView.automaticDimension
////    }
//    return SearchViewCell.height
//  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let viewModel = viewModel, let heightForRowAtIndexPathAction = viewModel.heightForRowAtIndexPathAction else { return 0 }
    var height = CGFloat(0.0)
    heightForRowAtIndexPathAction.apply(indexPath).startWithResult { (result: Result<CGFloat, ActionError<NoError>>) in
      guard let value = result.value else { return }
      height = value
    }
    return height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel, let didSelectRowAtIndexPathAction = viewModel.didSelectRowAtIndexPathAction else { return }
    didSelectRowAtIndexPathAction.apply(tableView).start()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

struct SearchViewModel {

  var numberOfSectionsAction: Action<Void, Int, NoError>?
  var numberOfRowsInSectionAction: Action<Int, Int, NoError>?

  var cellForRowAtIndexPathAction: Action<(UITableView, IndexPath), UITableViewCell, NoError>?

  var heightForRowAtIndexPathAction: Action<IndexPath, CGFloat, NoError>?

  var didSelectRowAtIndexPathAction: Action<UITableView, Void, NoError>?
  
}

//
//  SearchView.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit

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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

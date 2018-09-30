//
//  SearchViewController.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  fileprivate let data = [
    "本日は晴天なり 0",
    "本日は晴天なり 1",
    "本日は晴天なり 2",
    "本日は晴天なり 3",
    "本日は晴天なり 4",
    "本日は晴天なり 5",
    "本日は晴天なり 6",
    "本日は晴天なり 7",
    "本日は晴天なり 8",
    "本日は晴天なり 9",
    "本日は晴天なり 10",
    "本日は晴天なり 11",
    "本日は晴天なり 12",
    "本日は晴天なり 13",
    "本日は晴天なり 14",
    "本日は晴天なり 15",
    "本日は晴天なり 16",
    "本日は晴天なり 17",
    "本日は晴天なり 18",
    "本日は晴天なり 19",
  ]
  
  fileprivate func configure() {
    definesPresentationContext = true
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.hidesSearchBarWhenScrolling = false
      navigationItem.searchController = (view as! SearchView).searchController
    }
    
    var viewModel = SearchViewModel()
    viewModel.numberOfRowsInSection = { [weak self] (_ section: Int) -> Int in
      return (self?.data.count)!
    }
    viewModel.cellForRowAtIndexPath = { [weak self] (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell in
      let cell: SearchViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.cellModel = SearchViewCellModel(titleText: (self?.data[indexPath.row])!)
      return cell
    }
    
    (view as! SearchView).viewModel = viewModel
  }

}

class SearchNavigationController: UINavigationController {}

//
//  SearchViewController.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

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

  fileprivate let rows = [
    [
      "新規店舗",
      "本日は晴天なり 0",
      "本日は晴天なり 1",
      "本日は晴天なり 2",
      "本日は晴天なり 3",
      "本日は晴天なり 4",
      ],
    [
      "入金する",
      "本日は晴天なり 5",
      "本日は晴天なり 6",
      "本日は晴天なり 7",
      "本日は晴天なり 8",
      "本日は晴天なり 9",
      ],
    [
      "食べる",
      "本日は晴天なり 10",
      "本日は晴天なり 11",
      "本日は晴天なり 12",
      "本日は晴天なり 13",
      "本日は晴天なり 14",
      ],
    [
      "遊ぶ",
      "本日は晴天なり 15",
      "本日は晴天なり 16",
      "本日は晴天なり 17",
      "本日は晴天なり 18",
      "本日は晴天なり 19",
      ],
    [
      "暮らす",
      "本日は晴天なり 15",
      "本日は晴天なり 16",
      "本日は晴天なり 17",
      "本日は晴天なり 18",
      "本日は晴天なり 19",
      ],
    ]
  
  fileprivate func configure() {
    definesPresentationContext = true
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.hidesSearchBarWhenScrolling = false
      navigationItem.searchController = (view as! SearchView).searchController
    }

    var viewModel = SearchViewModel()
    viewModel.numberOfSections = { [weak self] () -> Int in
      return (self?.rows.count)!
    }
    viewModel.numberOfRowsInSection = { [weak self] (_ section: Int) -> Int in
      return (self?.rows[section].count)!
    }

    viewModel.heightForRowAtIndexPath = { (_ indexPath: IndexPath) -> CGFloat in
      return indexPath.row > 0 ? SearchViewCell.height : SearchViewSectionCell.height
    }
    viewModel.cellForRowAtIndexPath = { [weak self] (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell in
      let cell: SearchViewCell = tableView.dequeueReusableCell(for: indexPath)
      (cell as CellModelable).cellModel = indexPath.row > 0 ? SearchViewCellModel(titleText: (self?.rows[indexPath.section][indexPath.row])!)
      : SearchViewSectionCellModel(titleText: (self?.rows[indexPath.section][indexPath.row])!)
      return cell
    }
    
    (view as! ViewModelable).viewModel = viewModel
  }

}

class SearchNavigationController: UINavigationController {}

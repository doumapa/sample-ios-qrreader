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

  fileprivate let sections = [
    "新規店舗",
    "入金する",
    "食べる",
    "遊ぶ",
    "暮らす",
  ]
  
  fileprivate let rows = [
    [
      "本日は晴天なり 0",
      "本日は晴天なり 1",
      "本日は晴天なり 2",
      "本日は晴天なり 3",
      "本日は晴天なり 4",
      ],
    [
      "本日は晴天なり 5",
      "本日は晴天なり 6",
      "本日は晴天なり 7",
      "本日は晴天なり 8",
      "本日は晴天なり 9",
      ],
    [
      "本日は晴天なり 10",
      "本日は晴天なり 11",
      "本日は晴天なり 12",
      "本日は晴天なり 13",
      "本日は晴天なり 14",
      ],
    [
      "本日は晴天なり 15",
      "本日は晴天なり 16",
      "本日は晴天なり 17",
      "本日は晴天なり 18",
      "本日は晴天なり 19",
      ],
    [
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
      return (self?.sections.count)!
    }
    viewModel.numberOfRowsInSection = { [weak self] (_ section: Int) -> Int in
      return (self?.rows[section].count)!
    }

    viewModel.heightForHeaderInSection = { (_ section: Int) -> CGFloat in
      print("Header height: \(TableViewHeaderView.height)")
      return TableViewHeaderView.height
    }
    viewModel.viewForHeaderInSection = { [weak self] (_ tableView: UITableView, section: Int) -> UIView? in
      guard let headerView: TableViewHeaderView = tableView.dequeueReusableHeaderFooterView() else { return nil }
      headerView.viewModel = TableViewHeaderViewModel(text: self?.sections[section] ?? "", tapped: Action<Void, Void, NoError> {
        Debug.trace()
        return SignalProducer.empty
      })
      return headerView
    }

    viewModel.heightForRowAtIndexPath = { (_ indexPath: IndexPath) -> CGFloat in
      print("Cell height: \(SearchViewCell.height)")
      return SearchViewCell.height
    }
    viewModel.cellForRowAtIndexPath = { [weak self] (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell in
      let cell: SearchViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.cellModel = SearchViewCellModel(titleText: (self?.rows[indexPath.section][indexPath.row])!)
      return cell
    }
    
    (view as! SearchView).viewModel = viewModel
  }

}

class SearchNavigationController: UINavigationController {}

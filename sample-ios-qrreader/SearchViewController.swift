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

  // MARK: -
  
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
  
  fileprivate var sectionCellModels: [SearchViewSectionCellModel] = []

  // MARK: -

  fileprivate func configure() {
    definesPresentationContext = true
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.hidesSearchBarWhenScrolling = false
      navigationItem.searchController = (view as! SearchView).searchController
    }
    
    (view as! SearchView).viewModel = searchViewModelBuilder()

    sectionCellModels = rows.map { (items: [String]) -> SearchViewSectionCellModel in
      return SearchViewSectionCellModel(titleText: items[0])
    }
  }

  fileprivate func searchViewModelBuilder() -> SearchViewModel {
    var viewModel = SearchViewModel()
    viewModel.numberOfSectionsAction = Action<Void, Int, NoError> { () -> SignalProducer<Int, NoError> in
      return SignalProducer<Int, NoError> { [weak self] observable, _ in
        defer {
          observable.sendCompleted()
        }
        guard let me = self else {
          observable.send(value: 0)
          return
        }
        observable.send(value: me.rows.count)
      }
    }
    viewModel.numberOfRowsInSectionAction = Action<Int, Int, NoError> { (section: Int) -> SignalProducer<Int, NoError> in
      return SignalProducer<Int, NoError> { [weak self] observable, _ in
        defer {
          observable.sendCompleted()
        }
        guard let me = self else {
          observable.send(value: 0)
          return
        }
        observable.send(value: me.sectionCellModels[section].isExpand ? me.rows[section].count : 1)
      }
    }
    
    viewModel.heightForRowAtIndexPathAction = Action<IndexPath, CGFloat, NoError> { (indexPath: IndexPath) -> SignalProducer<CGFloat, NoError> in
      return SignalProducer<CGFloat, NoError> { [weak self] observable, _ in
        defer {
          observable.sendCompleted()
        }
        guard let me = self else {
          observable.send(value: UITableView.automaticDimension)
          return
        }
        observable.send(value: indexPath.row == 0 ? SearchViewSectionCell.height : SearchViewCell.height)
      }
    }

    viewModel.cellForRowAtIndexPathAction = Action<(UITableView, IndexPath), UITableViewCell, NoError> { (tableView: UITableView,  indexPath: IndexPath) -> SignalProducer<UITableViewCell, NoError> in
      return SignalProducer<UITableViewCell, NoError> { [weak self] observable, _ in
        defer {
          observable.sendCompleted()
        }
        guard let me = self else {
          observable.send(value: UITableViewCell())
          return
        }
        if indexPath.row == 0 {
          let cell: SearchViewSectionCell = tableView.dequeueReusableCell(for: indexPath)
          cell.cellModel = me.sectionCellModels[indexPath.section]
          observable.send(value: cell)
        } else {
          let cell: SearchViewCell = tableView.dequeueReusableCell(for: indexPath)
          cell.cellModel = SearchViewCellModel(titleText: me.rows[indexPath.section][indexPath.row])
          observable.send(value: cell)
        }
      }
    }

    viewModel.didSelectRowAtIndexPathAction = Action<UITableView, Void, NoError> { (tableView: UITableView) -> SignalProducer<Void, NoError> in
      return SignalProducer<Void, NoError> { [weak self] observable, _ in
        defer {
          observable.sendCompleted()
        }
        guard let me = self,
          let indexPath = tableView.indexPathForSelectedRow else { return }
        me.sectionCellModels[indexPath.section].isExpand = !me.sectionCellModels[indexPath.section].isExpand
        if me.sectionCellModels[indexPath.section].isExpand {
          tableView.beginUpdates()
          tableView.insertRows(at: (1..<me.rows[indexPath.section].count).map { (n: Int) -> IndexPath in
            return IndexPath(row: n, section: indexPath.section)
            },
                               with: UITableView.RowAnimation.fade)
          tableView.endUpdates()
        } else {
          tableView.beginUpdates()
          tableView.deleteRows(at: (1..<me.rows[indexPath.section].count).map { (n: Int) -> IndexPath in
            return IndexPath(row: n, section: indexPath.section)
            },
                               with: UITableView.RowAnimation.fade)
          tableView.endUpdates()
        }
      }
    }
    
    return viewModel
  }
  
}

class SearchNavigationController: UINavigationController {}

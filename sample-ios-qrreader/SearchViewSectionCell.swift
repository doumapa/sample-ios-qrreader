//
//  SearchViewSectionCell.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/10/12.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class SearchViewSectionCell: UITableViewCell, CellModelable {

  typealias T = SearchViewSectionCellModel

  // MARK: - Class properties
  
  static let estimateSize: CGSize = CGSize(width: 375, height: 44)
  class var height: CGFloat {
    get {
      return estimateSize.height * (UIScreen.main.bounds.width / estimateSize.width)
    }
  }
  
  var cellModel: SearchViewSectionCellModel? {
    didSet {
      bind()
    }
  }

  // MARK: -

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

  // MARK: -
  
  fileprivate func bind() {
    guard let cellModel = cellModel else { return }
    textLabel?.reactive.text <~ cellModel.titleText
  }
  
}

struct SearchViewSectionCellModel {
  
  let titleText: MutableProperty<String> = MutableProperty("")
  var isExpand: Bool = false
  
  init(titleText: String) {
    self.titleText.value = titleText
  }
  
}

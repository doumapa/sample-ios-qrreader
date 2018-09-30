//
//  SearchViewCell.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class SearchViewCell: UITableViewCell {

  var cellModel: SearchViewCellModel? {
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

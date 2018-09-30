//
//  SearchViewCellModel.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/30.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import Foundation
import ReactiveSwift

struct SearchViewCellModel {

  let titleText: MutableProperty<String> = MutableProperty("")

  init(titleText: String) {
    self.titleText.value = titleText
  }

}

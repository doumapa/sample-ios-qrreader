//
//  Protocols.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/10/12.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import Foundation

protocol ViewModelable {
  associatedtype T
  var viewModel: T? { get set }
}

protocol CellModelable {
  associatedtype T
  var cellModel: T? { get set }
}

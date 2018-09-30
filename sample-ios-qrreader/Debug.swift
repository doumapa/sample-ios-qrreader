//
//  Debug.swift
//  sample-ios-qrreader
//
//  Created by makoto kaneko on 2018/09/21.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import Foundation

struct Debug {

  static func trace(file: String = #file, line: Int = #line, function: String = #function, message: Any? = nil) {
    var filename = file
    if let match = filename.range(of: "[^/]*$", options: .regularExpression) {
      filename = String(filename[match])
    }
    Swift.print("[Debug] \(filename)(\(line)) \(function) \((message ?? ""))")
  }
  
}

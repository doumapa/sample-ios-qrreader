//
//  TableViewHeaderView.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/10/09.
//  Copyright © 2018 makoto.kaneko. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class TableViewHeaderView: UITableViewHeaderFooterView {

  // MARK: - Class properties
  
  static let estimateSize: CGSize = CGSize(width: 375, height: 40)
  class var height: CGFloat {
    get {
      return estimateSize.height * (UIScreen.main.bounds.width / estimateSize.width)
    }
  }
  
  // MARK: - Outlet properties
  
  @IBOutlet var _contentView: UIView!
  @IBOutlet weak var _textLabel: UILabel!

  // MARK: -

  override var contentView: UIView {
    get {
      return _contentView
    }
  }
  
  override var textLabel: UILabel? {
    get {
      return _textLabel
    }
  }

  // MARK: -

  var viewModel: TableViewHeaderViewModel? {
    didSet {
      bind()
    }
  }
  
  // MARK: -
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNib()
  }
  
  deinit {
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("bounds: \(bounds)")
    print("contentView.bounds: \(contentView.bounds)")
    _contentView.frame = bounds
  }
  
  // MARK: -

  fileprivate func bind() {
    guard let viewModel = viewModel else { return }
    if let textLabel = textLabel {
      textLabel.reactive.text <~ viewModel.textString
    }
    
    let gesture = UITapGestureRecognizer()
    gesture.reactive.stateChanged
      .take(duringLifetimeOf: self)
      .observeValues { [weak self] _ in
        guard let viewModel = self?.viewModel, let tapped = viewModel.tapped else { return }
        tapped.apply().start()
    }
    addGestureRecognizer(gesture)
    reactive.prepareForReuse
      .take(duringLifetimeOf: self)
      .observeCompleted {
        //
    }
  }
  
  fileprivate func setupNib() {
    loadNib()
  }
  
  fileprivate func loadNib() {
    Bundle(for: type(of: self)).loadNibNamed(TableViewHeaderView.tableViewHeaderFooterViewIdentifier, owner: self, options: nil)
    guard let contentView = _contentView else { return }
    addSubview(contentView)
    //contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let views = ["contentView" : contentView]
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: views))
  }
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

struct TableViewHeaderViewModel {

  let textString: MutableProperty<String> = MutableProperty("")

  var tapped: Action<Void, Void, NoError>?

  // MARK: -
  
  init(text: String, tapped: Action<Void, Void, NoError>) {
    textString.value = text
    self.tapped = tapped
  }

}

//
//  ViewController.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/07/20.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

  @IBOutlet weak var qrCodeReadButton: UIButton!
  @IBOutlet weak var customViewButton: UIButton!
  @IBOutlet weak var searchViewButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  fileprivate func bind() {
    qrCodeReadButton.reactive.pressed = CocoaAction(Action<Void, Void, NoError> { [weak self] in
      self?.presentQRReader()
      return SignalProducer.empty
      }, { (sender: UIButton) in
    })
    customViewButton.reactive.pressed = CocoaAction(Action<Void, Void, NoError> { [weak self] in
      self?.presentCustomView()
      return SignalProducer.empty
      }, { (sender: UIButton) in
    })
    searchViewButton.reactive.pressed = CocoaAction(Action<Void, Void, NoError> { [weak self] in
      self?.presentSearchView()
      return SignalProducer.empty
      }, { (sender: UIButton) in
    })
  }

  fileprivate func presentQRReader() {
    guard let navigationController: QRReaderNavigationController = UIStoryboard(.QRReader).instantiateViewController() else { return }
    present(navigationController, animated: true, completion: { [weak navigationController] in
      guard let qrReaderViewController = navigationController?.topViewController as? QRReaderViewController else { return }
      qrReaderViewController.qrString.signal
        .take(during: qrReaderViewController.reactive.lifetime)
        .observeValues { (qrString: String) in
          print("qrString:\(qrString)")
          navigationController?.dismiss(animated: true, completion: nil)
      }
    })
  }
  
  fileprivate func presentCustomView() {
    guard let navigationController: UINavigationController = UIStoryboard(.CustomField).instantiateViewController() else { return }
    present(navigationController, animated: true, completion: nil)
  }
 
  fileprivate func presentSearchView() {
    guard let navigationController: SearchNavigationController = UIStoryboard(.Main).instantiateViewController() else { return }
    present(navigationController, animated: true)
  }
  
}


//
//  QRReaderViewController.swift
//  MoneyEasy
//
//  Created by makoto.kaneko on 2018/07/20.
//  Copyright © 2018年 iRidge,Inc. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class QRReaderViewController: UIViewController {

  @IBOutlet weak var qrReaderView: QRReaderView!
  @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
  
//  var qrString: MutableProperty<String> {
//    get {
//      return qrReaderView.qrString
//    }
//  }

  deinit {
    print("QRReaderViewController deinit")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    qrReaderView.startCaptureSession()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  fileprivate func bind() {
    doneBarButtonItem.reactive.pressed = CocoaAction(Action<Void, Void, NoError> { [weak self] in
      guard let navigationController = self?.navigationController else { return SignalProducer.empty }
      navigationController.dismiss(animated: true, completion: nil)
      return SignalProducer.empty
      }, { (sender: UIBarButtonItem) in
    })
  }

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}

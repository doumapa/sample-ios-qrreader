//
//  QRReaderView.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/07/20.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift

class QRReaderView: UIView {

  //MARK: - Class properties
  
  class var nibName: String {
    return String(describing: self)
  }
  
  //MARK: - Outlet properties
    
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var previewView: UIView!
  @IBOutlet weak var finderView: UIView!

  //MARK: -
  
  var qrString: MutableProperty<String> = MutableProperty<String>("")
  
  //MARK: -
  
  fileprivate let captureSession = AVCaptureSession()
  fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
  fileprivate var rectangleView: UIView!

  fileprivate var isVideoEnabled: Bool {
    get {
      switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
      case .restricted: return false
      case .denied: return false
      case .authorized: return true
      case .notDetermined: return true
      }
    }
  }

  fileprivate let sessionQueue = DispatchQueue(label: "capture session queue")
  
  //MARK: -
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNib()
  }

  deinit {
    print("QRReaderView deinit")
  }
  
  override func layoutSubviews() {
    rectangleView.frame = convert(finderView.frame, from: finderView.superview)
  }

  //MARK: -

  func startCaptureSession() {
    guard isVideoEnabled,
      let video = AVCaptureDevice.default(for: .video),
      let input = try? AVCaptureDeviceInput(device: video) else { return }
    captureSession.addInput(input)
    
    let metadataOutput = AVCaptureMetadataOutput()
    captureSession.addOutput(metadataOutput)
    metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
    metadataOutput.metadataObjectTypes = [.qr]
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    guard let previewLayer = previewLayer else { return }
    previewLayer.frame = previewView.bounds
    previewLayer.videoGravity = .resizeAspectFill
    previewView.layer.addSublayer(previewLayer)
    
    startRunning()
  }
  
  func restartCaptureSession() {
    guard !captureSession.isRunning else { return }
    rectangleView.alpha = 0
    rectangleView.frame = convert(finderView.frame, from: finderView.superview)
    startRunning()
  }
  
  func stopCaptureSession() {
    guard captureSession.isRunning else { return }
    stopRunning()
  }
  
  //MARK: -

  fileprivate func startRunning() {
    sessionQueue.async { [weak self] in
      self?.captureSession.startRunning()
    }
  }
  
  fileprivate func stopRunning() {
    sessionQueue.async { [weak self] in
      self?.captureSession.stopRunning()
    }
  }

  fileprivate func configureForViews() {
    rectangleView = UIView()
    rectangleView.frame = .zero
    rectangleView.alpha = 0
    rectangleView.layer.borderWidth = 3.0
    rectangleView.layer.borderColor = UIColor.red.cgColor
    addSubview(rectangleView)
    
    NotificationCenter.default.reactive.notifications(forName: .AVCaptureSessionDidStartRunning)
      .take(duringLifetimeOf: self)
      .observeValues { [weak self] _ in
        DispatchQueue.main.async {
          self?.displayPreview()
        }
    }
  }
  
  fileprivate func displayPreview() {
    guard let previewView = previewView else { return }
    let effectView = UIVisualEffectView()
    effectView.effect = UIBlurEffect(style: .dark)
    effectView.frame = previewView.frame
    previewView.addSubview(effectView)
    UIView.animate(withDuration: 0.8,
                   delay: 0,
                   options: [UIView.AnimationOptions.curveEaseInOut],
                   animations: {
                    effectView.alpha = 0
    },
                   completion: { _ in
                    effectView.removeFromSuperview()
    })
  }
  
  fileprivate func setupNib() {
    loadNib()
    configureForViews()
  }
  
  fileprivate func loadNib() {
    Bundle(for: type(of: self)).loadNibNamed(QRReaderView.nibName, owner: self, options: nil)
    guard let contentView = contentView else { return }
    addSubview(contentView)
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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

extension QRReaderView : AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject],
      let qrMetadata = metadataObjects.filter({ $0.type == .qr && $0.stringValue != nil }).first,
      let qrStringValue = qrMetadata.stringValue,
      let qrCodeBounds = (previewLayer?.transformedMetadataObject(for: qrMetadata) as? AVMetadataMachineReadableCodeObject)?.bounds else { return }
    stopRunning()
    UIView.animate(withDuration: 0.275,
                   animations: { [weak self] in
                    self?.rectangleView.alpha = 1.0
                    self?.rectangleView.frame = qrCodeBounds
    }) { [weak self] (b: Bool) in
      self?.qrString.value = qrStringValue
    }
  }
}

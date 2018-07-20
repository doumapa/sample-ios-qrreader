//
//  QRReaderView.swift
//  sample-ios-qrreader
//
//  Created by makoto.kaneko on 2018/07/20.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import UIKit
import AVFoundation
import Result
import ReactiveSwift

class QRReaderView: UIView {

    //MARK: - Class properties
    
    class var nibName: String {
        return String(describing: self)
    }
    
    //MARK: - Outlet properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var captureView: UIView!

    //MARK: -

    var qrString: MutableProperty<String?> = MutableProperty<String?>(nil)

    //MARK: -

    fileprivate let captureSession = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var rectangleView: UIView?

    //MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    //MARK: -

    func startCapture() {
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
        previewLayer.frame = captureView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        captureView.layer.addSublayer(previewLayer)
    }

    func restartCaptureSession() {
        guard !captureSession.isRunning else { return }
        rectangleView?.frame = .zero
        captureSession.startRunning()
    }

    //MARK: -

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
    
    fileprivate func configureForViews() {
        rectangleView = UIView()
        guard let rectangleView = rectangleView else { return }
        rectangleView.layer.borderWidth = 3.0
        rectangleView.layer.borderColor = UIColor.red.cgColor
        rectangleView.frame = .zero
        captureView.addSubview(rectangleView)
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
        captureSession.stopRunning()
        rectangleView?.frame = qrCodeBounds
        qrString.value = qrStringValue
    }
}

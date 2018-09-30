//
//  CustomView.swift
//  sample-ios-form
//
//  Created by makoto.kaneko on 2018/07/06.
//  Copyright © 2018年 makoto.kaneko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

@IBDesignable
class CustomView: UIView {

    //MARK: - Outlet properties

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    //MARK: - Inspectable properties

    @IBInspectable var errorColor: UIColor = .red {
        didSet {
            messageLabel.textColor = errorColor
        }
    }
    
    // Hide / Show Error message
    @IBInspectable var hideError: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.175,
                           delay: 0.0,
                           options: [UIView.AnimationOptions.curveEaseInOut],
                           animations: {
                            self.messageLabel.isHidden = self.hideError
            },
                           completion: { _ in
                            //
            })
            
        }
    }
    
    // The error message to appear if validation fails
    @IBInspectable var errorMessage: String = "Error Message" {
        didSet {
            messageLabel.text = errorMessage
            //contentView.layoutIfNeeded()
        }
    }

    // The textField Placeholder
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    // Default UI
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            textField.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            textField.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.darkGray {
        didSet {
            textField.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.white {
        didSet {
            textField.backgroundColor = bgColor
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    // UI Changes when value is valid
    @IBInspectable var validBorderColor: UIColor = UIColor.green
    @IBInspectable var validBgColor: UIColor = UIColor.green
    @IBInspectable var validTextColor: UIColor = UIColor.green
    @IBInspectable var validImage: UIImage? = nil
    
    // UI Changes when value is invalid
    @IBInspectable var invalidBorderColor: UIColor = UIColor.red
    @IBInspectable var invalidBgColor: UIColor = UIColor.red
    @IBInspectable var invalidTextColor: UIColor = UIColor.red
    @IBInspectable var invalidImage: UIImage? = UIImage(named: "form_validation_error")
    
    //MARK: - Public properties

    var validationRule: ((_ textField: UITextField) -> Bool?)?
    var continuousValidationRule: ((_ textField: UITextField) -> Bool?)?
    
    let isValid: MutableProperty<Bool?> = MutableProperty(nil)

    //MARK: -

    // The view and it's image used to show validation indicators
    private var rightView: UIView!
    private var rightImageView: UIImageView!
    
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
    print("CustomView deinit")
  }
  
    fileprivate func setupNib() {
        loadNib()
        configureForTextField()
        bindSignal()
    }
    
    fileprivate func loadNib() {
        Bundle(for: type(of: self)).loadNibNamed("CustomView", owner: self, options: nil)
        guard let contentView = contentView else { return }
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["contentView" : contentView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: views))
    }
    
    fileprivate func configureForTextField() {
        textField.rightViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        rightImageView.contentMode = .scaleAspectFit
        rightView.addSubview(rightImageView)
        textField.rightView = rightView
    }

    fileprivate func bindSignal() {
        textField.reactive.continuousTextValues
            .take(duringLifetimeOf: self)
            .skipNil()
            .skip(while: { (text: String) -> Bool in
                text.isEmpty
            })
            .observeValues { [weak self] (text: String) in
                guard let continuousValidationRule = self?.continuousValidationRule else { return }
                self?.validating(valid: continuousValidationRule((self?.textField)!))
        }
        textField.reactive.textValues
            .take(duringLifetimeOf: self)
            .skipNil()
            .skip(while: { (text: String) -> Bool in
                text.isEmpty
            })
            .observeValues { [weak self] (text: String) in
                guard let validationRule = self?.validationRule else { return }
                self?.validating(valid: validationRule((self?.textField)!))
        }
    }

    fileprivate func validating(valid: Bool?) {
        guard isValid.value != valid else { return }
        isValid.swap(valid)
        switch valid {
        case true?:
            hideError = true
            rightImageView.image = validImage
        case false?:
            hideError = false
            rightImageView.image = invalidImage
        case nil:
            hideError = true
            rightImageView.image = nil
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

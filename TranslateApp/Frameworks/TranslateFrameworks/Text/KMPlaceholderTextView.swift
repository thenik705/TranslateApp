//
//  KMPlaceholderTextView.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

protocol PlaceholderTextViewDelegate: class {
    func updateStatusKeyboard(_ isShow: Bool)
    func translateText(_ text: String)
    func isClearText(_ isClear: Bool)
    func nowTextCharsCount(_ count: Int)
}

@IBDesignable
class KMPlaceholderTextView: UITextView {
    
    weak var textDelegate: PlaceholderTextViewDelegate?
    var textTimer: Timer?

    private struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    public let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor = KMPlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textPlaceholderDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textPlaceholderDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(placeholderLabel)
        delegate = self

        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }

    func textPlaceholderDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        textDelegate?.isClearText(text.isEmpty)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
}

extension KMPlaceholderTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textPlaceholderDidChange()

        if textTimer != nil {
            textTimer?.invalidate()
            textTimer = nil
        }

        textTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(translateForKeyword(_:)), userInfo: textView.text ?? "", repeats: false)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        textDelegate?.nowTextCharsCount(numberOfChars)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textDelegate?.updateStatusKeyboard(true)
        textView.becomeFirstResponder()
    }
    
    @objc func translateForKeyword(_ timer: Timer) {
        let text = timer.userInfo!
        textDelegate?.translateText(text as? String ?? "")
    }
}



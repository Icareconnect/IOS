//
//  ChatAccessory.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 21/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView

class ChatTable: UITableView {
    lazy var chatAccessory: ChatAccessory = {
        let rect = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 64)
        let inputAccessory = ChatAccessory(frame: rect)
        return inputAccessory
    }()
        
    override var inputAccessoryView: UIView? {
        return chatAccessory
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        keyboardDismissMode = .interactive
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.top = keyboardHeight
            if keyboardHeight > 64 {
                scrollToTop()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.top = keyboardHeight
        }
    }
}


class ChatAccessory: UIView {
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var tfMessage: SZTextView!
    
    var thread: ChatThread?
    var sendAMessage: ((_ message: Message, _ image: UIImage?) -> Void)?
    private var mediaPicker = SKMediaPicker.init(type: .ImageCameraLibrary)
    public var localId = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK:- for iPhoneX Spacing bottom
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Attachment
            tfMessage.resignFirstResponder()
            mediaPicker.presentPicker({ [weak self] (image) in
                let message = Message.init(nil, nil, .IMAGE, self?.thread)
                self?.localId = /self?.localId - 1
                self?.sendAMessage?(message, image)
            }, { (url, data, image) in
                //Video
            }, nil)
        case 1: //Send
            if /tfMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let message = Message.init(nil, tfMessage.text.trimmingCharacters(in: .whitespacesAndNewlines), .TEXT, thread)
                localId = localId - 1
                SocketIOManager.shared.sendMessage(message: message)
                message.messageId = localId 
                sendAMessage?(message, nil)
                tfMessage.text = nil
            }
        default:
            break
        }
    }
    
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        // to dynamically increase height of text view
        // http://ticketmastermobilestudio.com/blog/translating-autoresizing-masks-into-constraints
        //if textView.translatesAutoresizingMaskIntoConstraints = true then height will not increase automatically
        // translatesAutoresizingMaskIntoConstraints default = true
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

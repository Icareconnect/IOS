//
//  ChatVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 03/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: ChatTable! {
        didSet {
            tableView.registerXIBForHeaderFooter(ChatTimeHeaderView.identfier)
        }
    }
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    public var thread: ChatThread?
    
    private var dataSource: TableDataSource<TimeStampProvider, MessageProvider, Message>?
    private var messages: [TimeStampProvider]?
    private var backendMessages = [Message]()
    private var timer: Timer?
    private var currentSeconds: Int?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.connect()
        initialSetUp()
        tableViewInit()
        getMessagesAPI()
        initializeSocketListers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SocketIOManager.shared.connect()
        readMessages()
        tableView.becomeFirstResponder()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            timer?.invalidate()
            SocketIOManager.shared.disconnect()
            popVC()
        case 1: //Options
            alertBoxOKCancel(title: VCLiteral.END_CHAT.localized, message: VCLiteral.END_CHAT_MESSAGE.localized, tapped: { [weak self] in
                self?.endChatAPI()
                }, cancelTapped: nil)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension ChatVC {
    private func initialSetUp() {
        lblTimer.text = nil
        lblName.text = /thread?.from_user?.name
    }
    
    private func startTimer() {
        if currentSeconds == nil {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            self?.currentSeconds = /self?.currentSeconds + 1
            let hours = /self?.currentSeconds / 3600
            let minutes = (/self?.currentSeconds % 3600) / 60
            let seconds = (/self?.currentSeconds % 3600) % 60
            self?.lblTimer.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        })
    }
    
    private func tableViewInit() {
        
        tableView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
        
        if thread?.status == .inProgress {
            tableView.becomeFirstResponder()
            tableView.chatAccessory.thread = thread
            btnMore.isHidden = false
        } else {
            btnMore.isHidden = true
        }
        
        
        tableView.chatAccessory.sendAMessage = { [weak self] (message, image) in
            switch message.messageType ?? .TEXT {
            case .TEXT:
                message.status = .SENT
                self?.insertANewMessage(message, image: nil)
            case .IMAGE:
                self?.insertANewMessage(message, image: image)
                self?.uploadImageAPI(message: message, image: image)
                self?.readMessages()
            }
            
        }
        
        dataSource = TableDataSource<TimeStampProvider, MessageProvider, Message>.init(.MultipleSection(items: messages ?? []), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            view.transform = CGAffineTransform.init(scaleX: 1, y: -1)
            (view as? ChatTimeHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            cell.contentView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
            (cell as? SenderTxtCell)?.item = item
            (cell as? SenderImgCell)?.item = item
            (cell as? SenderImgCell)?.didTapUploadImageRetry = { [weak self] (message, image) in
                self?.tableView.reloadData()
                self?.uploadImageAPI(message: message, image: image)
            }
            (cell as? RecieverTxtCell)?.item = item
            (cell as? RecieverImgCell)?.item = item
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getMessagesAPI()
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func uploadImageAPI(message: Message?, image: UIImage?) {
        guard let img = image else {
            return
        }
        EP_Home.uploadImage(image: img, type: MediaTypeUpload.image, doc: nil).request(success: { [weak self] (responseData) in
            let response = (responseData as? ImageUploadData)
            message?.imageUrl = response?.image_name
            message?.sentAt = Date().timeIntervalSince1970 * 1000
            message?.status = .SENT
            if let index: Int = self?.backendMessages.firstIndex(where: {$0.messageId == message?.messageId}) {
                self?.backendMessages[index] = message!
            }
            self?.messages?.first?.items?.first(where: {$0.property?.model?.messageId == message?.messageId})?.uploadStatus = .UploadingFinished
            self?.messages?.first?.items?.first(where: {$0.property?.model?.messageId == message?.messageId})?.property?.model = message
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .FullReload)
            SocketIOManager.shared.sendMessage(message: message!)
        }) { [weak self] (error) in
            self?.messages?.first?.items?.first(where: {$0.property?.model?.messageId == message?.messageId})?.uploadStatus = .Error(error: /error)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .FullReload)
        }
    }
    
    private func getMessagesAPI() {
        EP_Home.chatMessages(requestId: String(/thread?.id), after: after).request(success: { [weak self] (responseData) in
            let response = (responseData as? MessagesData)
            self?.after = response?.after
            if /self?.messages?.count == 0 {
                self?.backendMessages = response?.messages ?? []
                self?.currentSeconds = response?.currentTimer
                self?.startTimer()
                self?.messages = TimeStampProvider.getSectionalData((self?.backendMessages ?? []))
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .FullReload)
                self?.readMessages()
            } else {
                self?.backendMessages = (self?.backendMessages ?? []) + (response?.messages ?? [])
                self?.messages = TimeStampProvider.getSectionalData((self?.backendMessages ?? []))
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .FullReload)
            }
            self?.dataSource?.stopInfiniteLoading(self?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.sendFirstMessage()
        }) { [weak self] (error) in
            
        }
    }
    
    private func sendFirstMessage() {
        if backendMessages.count == 0 {
            let message = Message.init(nil, String.init(format: VCLiteral.CHAT_INITIAL_MESSAGE.localized, /thread?.from_user?.name?.capitalizingFirstLetter()), .TEXT, thread)
            tableView.chatAccessory.localId = /tableView.chatAccessory.localId - 1
            SocketIOManager.shared.sendMessage(message: message)
            message.messageId = tableView.chatAccessory.localId
            insertANewMessage(message, image: nil)
        }
    }
    
    private func endChatAPI() {
        EP_Home.endChat(requestId: String(/thread?.id)).request(success: { [weak self] (response) in
            self?.popVC()
        }) { (_) in
            
        }
    }
    
    private func readMessages() {
        if let message = backendMessages.first(where: {/$0.senderId != /UserPreference.shared.data?.id}) {
            SocketIOManager.shared.readMessage(message: message)
        }
    }
    
    private func initializeSocketListers() {
        SocketIOManager.shared.didRecieveMessage = { [weak self] (message) in
            self?.insertANewMessage(message, image: nil)
        }
        
        
        SocketIOManager.shared.didRequestCompleted = { [weak self] in
            self?.messages?.first?.items?.first?.property?.model?.status = .NOT_SENT
            self?.backendMessages.first?.status = .NOT_SENT
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .Reload(indexPaths: [IndexPath.init(row: 0, section: 0)], animation: .none))
            Toast.shared.showAlert(type: .apiFailure, message: VCLiteral.CANT_SEND_MESSAGE.localized)
        }
        
        SocketIOManager.shared.didReadMessageByOtherUser = { [weak self] in
            self?.backendMessages.forEach({ $0.status = .SEEN })
            self?.messages?.first?.items?.forEach({ $0.property?.model?.status = .SEEN })
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .ReloadSectionAt(indexSet: IndexSet(integer: 0), animation: .none))
        }
        
        SocketIOManager.shared.didDeliveredMessageByOtherUser = { [weak self] in
            self?.backendMessages.forEach({ (msg) in
                if (msg.status == .SEEN || msg.status == .NOT_SENT) {
                } else {
                    msg.status = .DELIVERED
                }
            })
            self?.messages?.first?.items?.forEach({ (provider) in
                if (provider.property?.model?.status == .SEEN || provider.property?.model?.status == .NOT_SENT) {
                } else {
                    provider.property?.model?.status = .DELIVERED
                }
            })
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.messages ?? []), .ReloadSectionAt(indexSet: IndexSet(integer: 0), animation: .none))
        }
    }
    
    private func insertANewMessage(_ message: Message, image: UIImage?) {
        backendMessages.insert(message, at: 0)
        let messageProvider = MessageProvider.init((/message.messageType?.getRelatedCellId(userID: /message.senderId), UITableView.automaticDimension, message), nil, nil)
        if let _ = image {
            messageProvider.uploadStatus = .Uploading
        }
        messageProvider.localImage = image
        messages?.first?.items?.insert(messageProvider, at: 0)
        dataSource?.updateAndReload(for: .MultipleSection(items: messages ?? []), .AddRowsAt(indexPaths: [IndexPath.init(row: 0, section: 0)], animation: .bottom, moveToLastIndex: true))
    }
}

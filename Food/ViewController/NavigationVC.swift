//
//  NavigationVC.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 21.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {
    
    func notificationViewHeight() -> CGFloat {
        return self.notificationViewCurrentHeight
}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubviews()
        
        let notificationName = NSNotification.Name.init(GoogleSheetNotificationName.error.rawValue)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NavigationVC.didRecivedError(notification:)),
                                               name: notificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NavigationVC.didRecivedMessage(notification:)),
                                               name: NSNotification.Name.init(GoogleSheetNotificationName.message.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NavigationVC.didRecivedErrorMessage(notification:)),
                                               name: NSNotification.Name.init(GoogleSheetNotificationName.errorMessage.rawValue),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let notificationViewFrame = CGRect(x: 0,
                                           y: screenBounds.height - self.notificationViewCurrentHeight,
                                           width: screenBounds.width,
                                           height: notificationViewMaxHeight)
        self.notificationView?.frame = notificationViewFrame
        
        let WUI_offset1 : CGFloat = 14
        let WUI_offset2 : CGFloat = 4
        let notificationLabelFrame = CGRect(x: WUI_offset1,
                                            y: WUI_offset2,
                                            width: notificationViewFrame.size.width - WUI_offset1 - WUI_offset1,
                                            height: notificationViewFrame.size.height - WUI_offset2 - WUI_offset2)
        self.notificationLabel?.frame = notificationLabelFrame
        
        if let notificationLabel = self.notificationLabel, self.notificationViewCurrentHeight > 0 {
            self.view.bringSubview(toFront: notificationLabel)
        }
    }
    
    // MARK: -
    // MARK: - Private
    
    private let notificationViewMaxHeight: CGFloat = 50
    private var notificationViewCurrentHeight: CGFloat = 0
    
    private var notificationViewTimeout:  Double = 0
    private let notificationViewDuration: Double = 5
    private var notificationViewTimer:    Timer?
    
    private weak var notificationView:  UIView?
    private weak var notificationLabel: UILabel?


    private func addSubviews() {
        self.addNotificationView()
    }
    
    private func addNotificationView() {
        let notificationView = UIView()
        self.view.addSubview(notificationView)
        self.notificationView = notificationView
        self.notificationView?.backgroundColor = UIColor.black
        
        let notificationLabel = UILabel()
        notificationView.addSubview(notificationLabel)
        self.notificationLabel = notificationLabel
        self.notificationLabel?.backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(NavigationVC.didTappedNotificationView(tap:)))
        self.notificationView?.addGestureRecognizer(tap)
}
    
    private func showNotification(message: String) {
        self.showNotificationViewWith(message: message, color: UIColor.white)
    }
    
    private func showNotificationFor(error: NSError?) {
        var errorMessage = String("Unknow Error")
        if let err = error {
            errorMessage = err.localizedDescription
        }
        self.showNotificationViewWith(message: errorMessage, color: UIColor.red)
    }
    
    private func showNotificationViewWith(message: String?, color: UIColor) {
        guard let notificationMessage = message else {
            return
        }
        
        if notificationMessage.count <= 0 {
            return
        }
        
        self.notificationViewCurrentHeight = self.notificationViewMaxHeight
        
        self.notificationViewTimeout = self.notificationViewDuration
        if self.notificationViewTimer == nil {
            self.notificationViewTimer = Timer.scheduledTimer(timeInterval: 1,
                                                              target: self,
                                                              selector: #selector(NavigationVC.notificationViewTimerTick),
                                                              userInfo: nil,
                                                              repeats: true)
        }
    }
    
    private func hideNotificationView() {
        self.notificationViewTimeout = 0
        self.notificationViewCurrentHeight = 0
        
        if let notificationViewTimer = self.notificationViewTimer {
            if notificationViewTimer.isValid {
                notificationViewTimer.invalidate()
            }
        }
    }
    
    @objc private func notificationViewTimerTick() {
        self.notificationViewTimeout -= 1
        if self.notificationViewTimeout < 0 {
            self.hideNotificationView()
        }
    }
    
    @objc private func didTappedNotificationView(tap: UITapGestureRecognizer) {
        self.hideNotificationView()
    }
    
    // MARK: - Notifications
    
    @objc private func didRecivedErrorMessage(notification: Notification) {
        let userInfo = notification.userInfo
        let message: String? = userInfo?[GoogleSheetNotificationParameters.message.rawValue] as? String
        self.showNotificationViewWith(message: message ?? String("Unknow Massage"), color: UIColor.red)
    }
    
    @objc private func didRecivedError(notification: Notification) {
        let userInfo = notification.userInfo
        let error: NSError? = userInfo?[GoogleSheetNotificationParameters.error.rawValue] as? NSError
        self.showNotificationFor(error: error)
    }
    
    @objc private func didRecivedMessage(notification: Notification) {
        let userInfo = notification.userInfo
        if let message = userInfo?[GoogleSheetNotificationParameters.message.rawValue] as? String {
            self.showNotification(message: message)
        }
    }
}

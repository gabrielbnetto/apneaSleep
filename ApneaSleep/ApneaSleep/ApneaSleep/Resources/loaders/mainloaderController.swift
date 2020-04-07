//
//  SantanderLoadingView.swift
//  Novo Now
//
//  Created by Gabriel Boccia Netto on 05/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import Lottie

@objc open class mainLoaderController: UIView {
    
    @objc public enum LoadingStatus : Int {
        case stopped = 0
        case running
    }
    
    private var loadingStatus : LoadingStatus = .stopped
    @objc public static let shared = mainLoaderController()
    private var timeoutTimer: Timer?
    
    private var presenterView: UIView?
    
    private var viewContent: UIView = {
        let viewContent = UIView()
        viewContent.layer.masksToBounds = true
        viewContent.backgroundColor = .white
        viewContent.alpha = 0.85
        return viewContent
    }()
    
    private var activity: AnimationView = {
        
        let activity = AnimationView(name: "mainloader")
        activity.contentMode = .scaleAspectFill
        activity.loopMode = .loop
        return activity
    }()
    
    @objc public convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    @objc public convenience init(in view: UIView) {
        self.init(frame: view.bounds)
        self.presenterView = view
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(frame: UIScreen.main.bounds)
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = .clear
        viewContent.alpha = 0
        
        updateFrameViews()
        
        self.addSubview(self.viewContent)
        
        self.addSubview(activity)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onAppTimeout),
            name: Notification.Name("AppTimeOut"),
            object: nil)
        
        //accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = "Carregando"
    }
    
    @objc func onAppTimeout(notification: NSNotification){
        self.close()
    }
    
    @objc public func open() {
        scheduleTimeoutVerify()
        
        self.loadingStatus = .running
        self.activity.play(fromFrame: 0, toFrame: 250)
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self)
        
        updateFrameViews()
        
        UIView.animate(withDuration: 0.3) {
            self.viewContent.alpha = 0.85
        }
    }
    
    @objc public func close() {
        stopScheduledTimeoutVerify()
        
        self.loadingStatus = .stopped
        self.activity.stop()
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.superview?.layer.add(transition, forKey: CATransitionType.fade.rawValue)
        self.removeFromSuperview()
        
    }
    
    @objc public static func status() -> LoadingStatus {
        return self.shared.loadingStatus
    }
    
    @objc public static func start() {
        self.shared.open()
    }
    
    @objc public static func stop() {
        self.shared.close()
    }
    
    private func updateFrameViews() {
        let screenSize = UIScreen.main.bounds.size
        let activityFrame = self.activity.frame
        
        self.viewContent.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height)
        
        self.activity.frame = CGRect(x: screenSize.width / 2 - activityFrame.width / 2, y: screenSize.height / 2 - activityFrame.height / 2, width: 300, height: 300)
    }
    
    // MARK: - Timeout
    func scheduleTimeoutVerify() {
        timeoutTimer = Timer.scheduledTimer(timeInterval: 90,
                                            target: self,
                                            selector: #selector(timeoutVerify),
                                            userInfo: nil,
                                            repeats: false)
    }
    func stopScheduledTimeoutVerify() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    @objc func timeoutVerify() {
        if loadingStatus == .running {
            NotificationCenter.default.post(name: Notification.Name("AppTimeOut"),
                                            object: nil)
        }
    }
}

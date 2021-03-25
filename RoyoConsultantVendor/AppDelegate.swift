//
//  AppDelegate.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift
import FBSDKLoginKit
import Firebase
//import JitsiMeet
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    //    fileprivate var jitsiMeetView: JitsiMeetView?
    private var onGoingCallRequestId: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) //FBSDK Setup
        
        if #available(iOS 13.0, *) {
            //Code written in SceneDelegate
        } else {
            setRootVC()
        }
        
        IQ_KeyboardManagerSetup()
        
        registerRemoteNotifications(application)
        GMSServices.provideAPIKey(SDK.GooglePlaceKey.rawValue)
        GMSPlacesClient.provideAPIKey(SDK.GooglePlaceKey.rawValue)
        
        //        JitsiMeet.sharedInstance().defaultConferenceOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
        //            builder.serverURL = URL.init(string: BasePath.JitsiServerURL.rawValue)!
        //        }
        //
        //        return JitsiMeet.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appForegroundAction()
    }
}

//MARK:- Custom functions
extension AppDelegate {
    public func setRootVC() {
        if /UserPreference.shared.data?.token != "" && /UserPreference.shared.data?.master_preferences?.count != 0 && /UserPreference.shared.data?.additionals?.count != 0 {
            
            window?.rootViewController = Storyboard<NavigationTabVC>.TabBar.instantiateVC()
            window?.makeKeyAndVisible()
            UIView.transition(with: window!, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            }, completion: { _ in })
        } else {
            window?.rootViewController = Storyboard<LoginSignUpNavVC>.LoginSignUp.instantiateVC()
            window?.makeKeyAndVisible()
            UIView.transition(with: window!, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            }, completion: { _ in })
        }
    }
    
    public func appForegroundAction() {
        SocketIOManager.shared.connect()
        EP_Home.appversion(app: .VendorApp, version: Bundle.main.versionDecimalScrapped).request(success: { (responseData) in
            
        })
        
        EP_Home.pages.request(success: { (response) in
            UserPreference.shared.pages = response as? [Page]
        })
        
        EP_Home.getClientDetail(app: .VendorApp).request(success: { (responeData) in
            
        })
    }
    
    private func IQ_KeyboardManagerSetup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(IQView.self)
        IQKeyboardManager.shared.toolbarTintColor = ColorAsset.appTint.color
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(SignUpInterMediateVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginEmailVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginMobileVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(VerificationVC.self)
    }
    
    private func registerRemoteNotifications(_ app: UIApplication) {
        FirebaseApp.configure()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions,completionHandler: {_, _ in })
        app.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func handleAutomaticRefreshData(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN {
        case .chat:
            if /UIApplication.topVC()?.isKind(of: ChatVC.self) {
                return
            } else if /UIApplication.topVC()?.isKind(of: ChatListingVC.self) {
                Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
                (UIApplication.topVC() as? ChatListingVC)?.dataSource?.refreshProgrammatically()
                return
            } else {
                Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
                if let listingVC: ChatListingVC = (UIApplication.topVC()?.tabBarController?.viewControllers?.last as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: ChatListingVC.self)}) as? ChatListingVC {
                    listingVC.dataSource?.refreshProgrammatically()
                }
            }
        case .REQUEST_COMPLETED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC)?.dataSource?.refreshProgrammatically()
            
        case .NEW_REQUEST,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .RESCHEDULED_REQUEST,
             .UPCOMING_APPOINTMENT,
             .REACHED,
             .COMPLETED,
             .START,
             .START_SERVICE,
             .CANCEL_SERVICE:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0
            
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
            if /UIApplication.topVC()?.isKind(of: RequestDetailsVC.self) && /(UIApplication.topVC() as? RequestDetailsVC)?.item?.id == /Int(/model?.request_id) {
                (UIApplication.topVC() as? RequestDetailsVC)?.getDetails()
            } 
        case .AMOUNT_RECEIVED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            ((UIApplication.topVC()?.tabBarController?.viewControllers?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: WalletVC.self)}) as? WalletVC)?.dataSource?.refreshProgrammatically()
        case .ASSINGED_USER:
            if /UIApplication.topVC()?.isKind(of: ClassesVC.self) {
                (UIApplication.topVC() as? ClassesVC)?.dataSource?.refreshProgrammatically()
            } else if let vc = (UIApplication.topVC()?.tabBarController?.viewControllers?.last as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: ClassesVC.self)}) as? ClassesVC {
                vc.dataSource?.refreshProgrammatically()
            }
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .UNKNOWN:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            
        //        case .CALL_CANCELED:
        //            DispatchQueue.main.async {
        //                self.pipViewCoordinator?.hide() { _ in
        //                    self.cleanUp()
        //                }
        //            }
        //
        //            if let requestId = onGoingCallRequestId {
        //                EP_Home.callStatus(requestID: requestId, status: .CALL_CANCELED).request(success: { [weak self] (_) in
        //                    self?.onGoingCallRequestId = nil
        //                }) { (_) in
        //
        //                }
        //            }
        case .PROFILE_APPROVED:
            
            UserPreference.shared.data?.account_verified = true
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: UploadDocsVC.self)}) as? UploadDocsVC)?.popVC()
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: VerificationPendingVC.self)}) as? VerificationPendingVC)?.getVendorDetailAPI()
            
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC)?.dataSource?.refreshProgrammatically()
            
        case .CALL_ACCEPTED:
            (UIApplication.topVC() as? CallVC)?.callStatusUpdate(status: .CALL_ACCEPTED)
        case .CALL_RINGING:
            (UIApplication.topVC() as? CallVC)?.callStatusUpdate(status: .CALL_RINGING)
        case .PAYOUT_PROCESSED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        default:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            
        }
    }
    
    private func handleNotificationTap(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN {
        case .chat:
            if /UIApplication.topVC()?.isKind(of: ChatVC.self) {
                return
            } else if /UIApplication.topVC()?.isKind(of: ChatListingVC.self) {
                (UIApplication.topVC() as? ChatListingVC)?.dataSource?.refreshProgrammatically()
                return
            } else if let listingVC: ChatListingVC = (UIApplication.topVC()?.tabBarController?.viewControllers?.last as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: ChatListingVC.self)}) as? ChatListingVC {
                listingVC.dataSource?.refreshProgrammatically()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 3
            } else {
                UIApplication.topVC()?.pushVC(Storyboard<ChatListingVC>.Other.instantiateVC())
            }
        case .REQUEST_COMPLETED:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC)?.dataSource?.refreshProgrammatically()
            
        case .NEW_REQUEST,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .RESCHEDULED_REQUEST,
             .UPCOMING_APPOINTMENT,
             .REACHED,
             .COMPLETED,
             .START,
             .START_SERVICE,
             .CANCEL_SERVICE:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0
            
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
            if /UIApplication.topVC()?.isKind(of: RequestDetailsVC.self) && /(UIApplication.topVC() as? RequestDetailsVC)?.item?.id == /Int(/model?.request_id) {
                (UIApplication.topVC() as? RequestDetailsVC)?.getDetails()
            } else {
                let destVC = Storyboard<RequestDetailsVC>.Other.instantiateVC()
                destVC.requestID = /model?.request_id
                UIApplication.topVC()?.pushVC(destVC)
            }
        case .AMOUNT_RECEIVED:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            ((UIApplication.topVC()?.tabBarController?.viewControllers?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: WalletVC.self)}) as? WalletVC)?.dataSource?.refreshProgrammatically()
        case .ASSINGED_USER:
            if /UIApplication.topVC()?.isKind(of: ClassesVC.self) {
                (UIApplication.topVC() as? ClassesVC)?.dataSource?.refreshProgrammatically()
            } else {
                UIApplication.topVC()?.pushVC(Storyboard<ClassesVC>.Other.instantiateVC())
            }
        case .UNKNOWN:
            break
            
        case .PROFILE_APPROVED:
            UIApplication.topVC()?.tabBarController?.selectedIndex = 0
            UserPreference.shared.data?.account_verified = true
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: UploadDocsVC.self)}) as? UploadDocsVC)?.popVC()
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: VerificationPendingVC.self)}) as? VerificationPendingVC)?.getVendorDetailAPI()
            
            ((UIApplication.topVC()?.tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: RequestsVC.self)}) as? RequestsVC)?.dataSource?.refreshProgrammatically()
            
        case .PAYOUT_PROCESSED:
            break
        default:
            break
        }
    }
}

//MARK:- UNUserNotificationCenter Deelgates
extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK:- Notification Native UI Tapped
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleNotificationTap(notificationData)
    }
    
    //MARK:- Native notification just came up
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo = notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleAutomaticRefreshData(notificationData)
    }
}

//MARK:- Firebase messaging delegate
extension AppDelegate: MessagingDelegate {
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserPreference.shared.firebaseToken = fcmToken
        if /UserPreference.shared.data?.token != "" {
            EP_Home.updateFCMId.request(success: { (_) in
                
            })
        }
    }
}

//
//  HardwareServiceAuthorization.swift
//  DMRSwiftUtilityToolsComponentDemo
//
//  Created by Mac on 2018/11/28.
//  Copyright © 2018 Riven. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreLocation
import CoreTelephony
import CoreBluetooth
import EventKit
import Contacts

// MARK: - 服务类型
enum ServiceType: String {
    
    /// 相册
    case ServiceTypePhotoAlbum = "ServiceTypePhotoAlbum"
    /// 相机
    case ServiceTypeCamera = "ServiceTypeCamera"
    /// 麦克风
    case ServiceTypeMicrophone = "ServiceTypeMicrophone"
    /// 定位
    case ServiceTypeLocation = "ServiceTypeLocation"
    /// 推送
    case ServiceTypeNotification = "ServiceTypeNotification"
    /// 联网
    case ServiceTypeNetwork = "ServiceTypeNetwork"
    /// 日历
    case ServiceTypeCalendars = "ServiceTypeCalendars"
    /// 蓝牙
    case ServiceTypeBluetooth = "ServiceTypeBluetooth"
    /// 通讯录
    case ServiceTypeContacts = "ServiceTypeContacts"
    
}

// MARK: - ServiceAuthorizationManager
class ServiceAuthorizationManager: NSObject, CBCentralManagerDelegate {
    
    // 蓝牙权限获取回调
    private var completeBluetoothClourse: ((_ result: Bool) -> Void)?
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var ret = false
        if central.state.rawValue == 5  {
            ret = true
        }
        if self.completeBluetoothClourse != nil {
            self.completeBluetoothClourse!(ret)
        }
    }
    
}

// MARK: - 权限跳转
extension ServiceAuthorizationManager {
    
    // 开启权限
    func turnOnServiceAuthorization() -> () {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
        }
        else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    /// 权限服务
    /// - Parameter type: 类型
    /// - Returns: 返回结果
    func isAllowService(serviceType: ServiceType) -> Bool {
        var ret = false
        switch serviceType {
        /// 相册
        case .ServiceTypePhotoAlbum:
            ret = self.isAllowPhotoAlbumService()
        
        /// 相机
        case .ServiceTypeCamera:
            ret = self.isAllowCameraService()
        
        /// 麦克风
        case .ServiceTypeMicrophone:
            ret = self.isAllowMicrophone()
        
        /// 定位
        case .ServiceTypeLocation:
            ret = self.isAllowLocationService()
        
        /// 推送
        case .ServiceTypeNotification:
            ret = self.isAllowNotificationService()
        
        /// 联网
        case .ServiceTypeNetwork:
            ret = self.isAllowNetworkService()
            
        /// 日历
        case .ServiceTypeCalendars:
            ret = self.isAllowCalendarsService()
        
        /// 蓝牙
        case .ServiceTypeBluetooth:
            self.isAllowBluetoothService { (result) in
                ret = result
            }
        
        /// 通讯录
        case .ServiceTypeContacts:
            ret = self.isAllowContactsService()
        }
        
        return ret;
    }
}

// MARK: - 检测权限
private extension ServiceAuthorizationManager {
    /// 是否允许获取相册权限
    private func isAllowPhotoAlbumService() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.authorized  {
            return true
        }
        
        return false
    }
    
    /// 是否允许获取相机权限
    private func isAllowCameraService() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.authorized {
            return true
        }
        
        return false
    }
    
    /// 是否允许麦克风权限
    private func isAllowMicrophone() ->Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if status == AVAuthorizationStatus.authorized {
            return true
        }
        
        return false
    }
    
    /// 定位权限
    func isAllowLocationService() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.denied ||
            status == CLAuthorizationStatus.notDetermined ||
            status == CLAuthorizationStatus.restricted) {
            return false
        }

        return true
    }
    
    /// 推送
    func isAllowNotificationService() -> Bool {
        let types = UIApplication.shared.currentUserNotificationSettings
        if types?.types == UIUserNotificationType.sound {
            return false
        }
        
        return true
    }
    
    /// 联网
    func isAllowNetworkService() -> Bool {
        let state = CTCellularData().restrictedState
        if state == CTCellularDataRestrictedState.notRestricted {
            return true
        }
        
        return false
    }
    
    /// 日历权限
    func isAllowCalendarsService() -> Bool {
        let state = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if state == EKAuthorizationStatus.authorized {
            return true
        }
        
        return false
    }
    
    /// 蓝牙
    func isAllowBluetoothService(result: @escaping (Bool) -> ()) -> Void {
        let _ = CBCentralManager.init(delegate: self, queue: nil)
        completeBluetoothClourse = result
    }
    
    /// 通讯录
    func isAllowContactsService() -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized {
            return true
        }
        
        return false
    }
    
}

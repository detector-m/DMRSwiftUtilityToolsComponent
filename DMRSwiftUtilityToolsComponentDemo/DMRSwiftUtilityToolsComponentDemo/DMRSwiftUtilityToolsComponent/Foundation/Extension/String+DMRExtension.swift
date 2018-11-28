//
//  String+DMRExtension.swift
//  DMRSwiftUtilityToolsComponentDemo
//
//  Created by Mac on 2018/11/28.
//  Copyright © 2018 Riven. All rights reserved.
//

import Foundation

// MARK: - 将字符串替换成值类型
extension String {
    
    /// to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        }
        
        return nil
    }
    
    /// to Flot
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        }
        
        return nil
    }
    
    /// to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        }
        
        return nil
    }
    
    
}

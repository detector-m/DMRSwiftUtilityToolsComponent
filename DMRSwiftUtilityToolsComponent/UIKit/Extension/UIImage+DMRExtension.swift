//
//  UIImage+DMRExtension.swift
//  DMRSwiftUtilityToolsComponentDemo
//
//  Created by Mac on 2018/11/28.
//  Copyright © 2018 Riven. All rights reserved.
//

import UIKit

// MARK: -
extension UIImage {
    
    /// 将图片绘制成制定大小
    public class func scale(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let retImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return retImage
    }
    
    /// 将color变为图片
    public class func colorToImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let retImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return retImage
    }
    
    /// 裁剪图片
    public func crop(in rect: CGRect) -> UIImage {
        guard (rect.size.width < self.size.width &&
            rect.size.height < self.size.height) else {
            return self
        }
        guard let image: CGImage = self.cgImage?.cropping(to: rect) else {
            return self
        }
        
        return UIImage(cgImage: image)
    }
    
}

//
//  YUVA.swift
//  Throw
//
//  Created by Zakk Hoyt on 10/22/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit


public struct YUVA {
    
    var y: CGFloat // intensity
    var u: CGFloat // blue
    var v: CGFloat // red
    var alpha: CGFloat // alpha

    
    init(y: CGFloat, u: CGFloat, v: CGFloat, alpha: CGFloat) {
        self.y = y
        self.u = u
        self.v = v
        self.alpha = alpha
    }
    
    init(y: CGFloat, u: CGFloat, v: CGFloat) {
        self.y = y
        self.u = u
        self.v = v
        self.alpha = 1.0
    }
    
    public func description() -> String {
        return "y: " + String(format: "%.2f", y) +
            "u: " + String(format: "%.2f", u) +
            "v: " + String(format: "%.2f", v) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    public func color() -> UIColor {
        let rgba = UIColor.yuvaToRGBA(yuva: self)
        return rgba.color()
    }

    
    // MARK: Converstions
    public func rgba() -> RGBA {
        return UIColor.yuvaToRGBA(yuva: self)
    }
    
    
    public func hsba() -> HSBA {
        let rgba = UIColor.yuvaToRGBA(yuva: self)
        let hsba = UIColor.rgbaToHSBA(rgba: rgba)
        return hsba
    }
    
    public func hsla() -> HSLA {
        let rgba = UIColor.yuvaToRGBA(yuva: self)
        let hsla = UIColor.rgbaToHSLA(rgba: rgba)
        return hsla
    }

    
    public func cmyka() -> CMYKA {
        let rgba = UIColor.yuvaToRGBA(yuva: self)
        let cmyka = UIColor.rgbaToCMYKA(rgba: rgba)
        return cmyka
    }

    
    // MARK: Static functions
    static func colorWith(yuva: YUVA) -> UIColor {
        return yuva.color()
    }
}



extension UIColor {
    
    // MARK: self to struct
    
    public func yuva(alpha: CGFloat = 1.0) -> YUVA {
        let rgba = self.rgba()
        let yuva = UIColor.rgbaToYUVA(rgba: rgba)
        return yuva
    }
    
    
    // MARK: constructors
    
    public convenience init(yuva: YUVA, alpha: CGFloat = 1.0) {
        let rgba = UIColor.yuvaToRGBA(yuva: yuva)
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
    
    public class func colorWith(yuva: YUVA) -> UIColor {
        return yuva.color()
    }
    
    public class func colorWith(y: CGFloat, u: CGFloat, v: CGFloat, alpha: CGFloat) -> UIColor {
        let yuva = YUVA(y: y, u: u, v: v, alpha: alpha)
        let rgba = UIColor.yuvaToRGBA(yuva: yuva)
        return rgba.color()
    }
    
    // http://www.pcmag.com/encyclopedia/term/55166/yuv-rgb-conversion-formulas
    

    
    public class func yuvaToRGBA(yuva: YUVA) -> RGBA {
//        var red = yuva.y + 1.140 * yuva.v
//        var green = yuva.y - 0.395 * yuva.u - 0.581 * yuva.v
//        var blue = yuva.y + 2.032 * yuva.u
        
//        R  = Y +                       + (Cr - 128) *  1.40200
//        G  = Y + (Cb - 128) * -0.34414 + (Cr - 128) * -0.71414
//        B  = Y + (Cb - 128) *  1.77200
        
//        var red     = yuva.y +                             (yuva.u - 0.5) *  1.40200
//        var green   = yuva.y + (yuva.v - 0.5) * -0.34414 + (yuva.u - 0.5) * -0.71414
//        var blue    = yuva.y + (yuva.y - 0.5) *  1.77200
        
        
        
        // http://www.equasys.de/colorconversion.html
        var red = yuva.y * 1.0 + (yuva.u - 0.5) * 0.0 + (yuva.v - 0.5) * 1.140
        var green = yuva.y * 1.0 + (yuva.u - 0.5) * -0.395 + (yuva.v - 0.5) * -0.581
        var blue = yuva.y * 1.0 + (yuva.u - 0.5) * 2.032 + (yuva.v - 0.5) * 0
        
        
        // Experimenting with normalizing since RGB values go will above and below 0...1
//        (lldb) po redMin
//        -0.07
//        
//        
//        (lldb) po redMax
//        1.06724637681159
//        
//        
//        (lldb) po greenMin
//        0.0143574879227053
//        
//        
//        (lldb) po greenMax
//        0.988
//        
//        
//        (lldb) po blueMin
//        -0.516
//        
//        
//        (lldb) po blueMax
//        1.51109178743961
//
//        let redMax: CGFloat = 1.06724637681159
//        let redMin: CGFloat = -0.07
//        let redDiff = redMax - redMin
//        red = red - redMin / redDiff
//        
//        
//        let greenMax: CGFloat = 0.988
//        let greenMin: CGFloat = 0.0143574879227053
//        let greenDiff = greenMax - greenMin
//        green = green - greenMin / greenDiff
//
//        
//        let blueMax: CGFloat = 1.51109178743961
//        let blueMin: CGFloat = -0.516
//        let blueDiff = blueMax - blueMin
//        blue = blue - blueMin / blueDiff

        

        
        
        if red > 1.0 {
            red = 1.0
            
        }
        if red < 0 {
            red = 0
        }
        
        if green > 1.0 {
            green = 1.0

        }
        if green < 0 {
            green = 0
        }

        if blue > 1.0 {
            blue = 1.0
            
        }
        if blue < 0 {
            blue = 0
        }
        
        
        let rgba = RGBA(red: red, green: green, blue: blue, alpha: yuva.alpha)
        return rgba
    }
    
    public class func yuvaToHSBA(yuva: YUVA) -> HSBA {
        let rgba = UIColor.yuvaToRGBA(yuva: yuva)
        let hsba = UIColor.rgbaToHSBA(rgba: rgba)
        return hsba
    }
    
    public class func yuvaToHSLA(yuva: YUVA) -> HSLA {
        let rgba = UIColor.yuvaToRGBA(yuva: yuva)
        let hsla = UIColor.rgbaToHSLA(rgba: rgba)
        return hsla
    }

    
    public class func yuvaToCMYKA(yuva: YUVA) -> CMYKA {
        let rgba = UIColor.yuvaToRGBA(yuva: yuva)
        let cmyka = UIColor.rgbaToCMYKA(rgba: rgba)
        return cmyka
    }

    
}

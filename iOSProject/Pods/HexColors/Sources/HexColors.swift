//
//  HexColors.swift
//
//  Created by Marius Landwehr on 25.12.16.
//  The MIT License (MIT)
//  Copyright (c) 2016 Marius Landwehr marius.landwehr@gmail.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
  public typealias HexColor = UIColor
#else
  import Cocoa
  public typealias HexColor = NSColor
#endif


public extension HexColor {
  typealias Hex = String

  convenience init?(_ hex: Hex, alpha: CGFloat? = nil) {
    
    guard let hexType = Type(from: hex), let components = hexType.components() else {
        return nil
    }
    
    #if os(iOS) || os(watchOS) || os(tvOS)
      self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha ?? components.alpha)
    #else
      self.init(calibratedRed: components.red, green: components.green, blue: components.blue, alpha: alpha ?? components.alpha)
    #endif
  }
  
  /// The string hex value representation of the current color
  var hex: Hex {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0, rgb: Int
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    if a == 1 { // no alpha value set, we are returning the short version
      rgb = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
      return String(format: "#%06x", rgb)
    } else {
      rgb = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0
      return String(format: "#%08x", rgb)
    }
  }
  
  private enum `Type` {
    
    case RGBshort(rgb: Hex)
    case RGBshortAlpha(rgba: Hex)
    case RGB(rgb: Hex)
    case RGBA(rgba: Hex)
    
    init?(from hex: Hex) {
      
      var hexString = hex
      hexString.removeHashIfNecessary()
      
      guard let t = Type.transform(hex: hexString) else {
        return nil
      }
      
      self = t
    }
    
    static func transform(hex string: Hex) -> Type? {
      switch string.characters.count {
      case 3:
        return .RGBshort(rgb: string)
      case 4:
        return .RGBshortAlpha(rgba: string)
      case 6:
        return .RGB(rgb: string)
      case 8:
        return .RGBA(rgba: string)
      default:
        return nil
      }
    }
    
    var value: Hex {
      switch self {
      case .RGBshort(let rgb):
        return rgb
      case .RGBshortAlpha(let rgba):
        return rgba
      case .RGB(let rgb):
        return rgb
      case .RGBA(let rgba):
        return rgba
      }
    }
    
    typealias rgbComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    func components() -> rgbComponents? {
      
      var hexValue: UInt32 = 0
      guard Scanner(string: value).scanHexInt32(&hexValue) else {
        return nil
      }
      
      let r, g, b, a, divisor: CGFloat
      
      switch self {
      case .RGBshort(_):
        divisor = 15
        r = CGFloat((hexValue & 0xF00) >> 8) / divisor
        g = CGFloat((hexValue & 0x0F0) >> 4) / divisor
        b = CGFloat( hexValue & 0x00F) / divisor
        a = 1
      case .RGBshortAlpha(_):
        divisor = 15
        r = CGFloat((hexValue & 0xF000) >> 12) / divisor
        g = CGFloat((hexValue & 0x0F00) >> 8) / divisor
        b = CGFloat((hexValue & 0x00F0) >> 4) / divisor
        a = CGFloat( hexValue & 0x000F) / divisor
      case .RGB(_):
        divisor = 255
        r = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
        g = CGFloat((hexValue & 0x00FF00) >> 8) / divisor
        b = CGFloat( hexValue & 0x0000FF) / divisor
        a = 1
      case .RGBA(_):
        divisor = 255
        r = CGFloat((hexValue & 0xFF000000) >> 24) / divisor
        g = CGFloat((hexValue & 0x00FF0000) >> 16) / divisor
        b = CGFloat((hexValue & 0x0000FF00) >> 8) / divisor
        a = CGFloat( hexValue & 0x000000FF) / divisor
      }
      
      return (red: r, green: g, blue: b, alpha: a)
    }
  }
}

private extension String {
  
  mutating func removeHashIfNecessary() {
    if hasPrefix("#") {
      self = replacingOccurrences(of: "#", with: "")
    }
  }
}

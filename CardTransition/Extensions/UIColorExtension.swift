import Foundation
import CoreImage
import UIKit

extension UIColor {
    
	func withAlpha(_ alpha: CGFloat) -> UIColor {
    return withAlphaComponent(alpha)
	}
	
	/// Init with hex string
    /// e.g. #ffffff or 03f7c4
	///
	/// - Parameter hexString: a string represent a color
	convenience init(hex: String) {
		let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		
		if (hexString.hasPrefix("#")) {
			scanner.scanLocation = 1
		}
		
		var color: UInt32 = 0
		scanner.scanHexInt32(&color)

    let mask = 0x000000FF

    if hexString.count == 6 || hexString.count == 7 {
      let r = Int(color >> 16) & mask
      let g = Int(color >> 8) & mask
      let b = Int(color) & mask

      let red   = CGFloat(r) / 255.0
      let green = CGFloat(g) / 255.0
      let blue  = CGFloat(b) / 255.0

      self.init(red: red, green: green, blue: blue, alpha: 1)
    } else if hexString.count == 8 || hexString.count == 9 {
      let r = Int(color >> 24) & mask
      let g = Int(color >> 16) & mask
      let b = Int(color >> 8) & mask
      let a = Int(color) & mask

      let red   = CGFloat(r) / 255.0
      let green = CGFloat(g) / 255.0
      let blue  = CGFloat(b) / 255.0
      let alpha = CGFloat(a) / 255.0

      self.init(red: red, green: green, blue: blue, alpha: alpha)
    } else {
      self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
	}
	
	/// Get a hex string of the color
	///
	/// - Returns: a hex string of the color
	func hexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
		
		return String(format: "#%06x", rgb)
	}

  class func randomColor() -> UIColor {
    let offset = 100
    let r = (Int.random() % (256 - offset) + offset).cgFloat / 255
    let g = (Int.random() % (256 - offset) + offset).cgFloat / 255
    let b = (Int.random() % (256 - offset) + offset).cgFloat / 255
    return UIColor(red: r, green: g, blue: b, alpha: 1)
  }
    
}

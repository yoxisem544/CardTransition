import UIKit

extension NSNumber {

  var cgFloat: CGFloat {
    return self.doubleValue.cgFloat
  }

}

extension CGFloat {
    
	/// Double of a CGFloat
	var double: Double {
		return Double(self)
	}

    /// Int of a CGFloat
	var int: Int {
		return Int(self)
	}
    
  func point(below view: UIView) -> CGFloat {
      return view.frame.maxY + self
  }

  /// Get a x point right from a view
  func pointRight(from view: UIView) -> CGFloat {
    return view.frame.maxX + self
  }
    
}

extension NSNumber {
  
  var currencyFormatString: String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: self)
  }
  
}

extension Double {
    
	/// CGFloat of Double
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	/// Radian of Double.
	var radian: Double {
		return (Double.pi * self / 180.0)
	}
  
  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }

  var string: String {
    return String(self)
  }
    
}

extension Int {
  
  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }
    
	var double: Double {
		return Double(self)
	}
	
	var string: String {
		return String(self)
	}
	
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	var int32: Int32 {
		return Int32(self)
	}
    
  /// Get a Random number.
  /// Don't call arc4random.
  /// Will have 50% crash chance on 32bit device.
  ///
  /// - Returns: random Int
  static func random() -> Int {
      return Int(arc4random() / 2)
  }

  static func random(upperBound: Int) -> Int {
    return random() % upperBound
  }

  /// Get the y point below a view
  func point(below view: UIView) -> CGFloat {
      return view.frame.maxY + self.cgFloat
  }

  /// Get a x point right from a view
  func pointRight(from view: UIView) -> CGFloat {
      return view.frame.maxX + self.cgFloat
  }
    
}

extension Int32 {
    
	var int: Int {
		return Int(self)
	}
    
}

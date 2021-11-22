import Foundation

extension Double {
    var decimal: Double {
        get {
            let divisor = pow(10.0, Double(8))
            let doubleValue = (self * divisor).rounded() / divisor
            
            print(doubleValue)
            
            return (doubleValue == -0.0) ? 0.0 : doubleValue
        }
    }
}

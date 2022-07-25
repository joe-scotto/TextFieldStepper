import Foundation

extension Double {
    var decimal: Double {
        get {
            let divisor = pow(10.0, Double(9))
            let doubleValue = (self * divisor).rounded() / divisor

            return (doubleValue == -0.0) ? 0.0 : doubleValue.truncate(places: 8)
        }
    }
    
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

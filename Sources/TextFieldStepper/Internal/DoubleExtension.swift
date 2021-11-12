import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundedDecimal(places: Int = 3) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension Double{
    
    var coordinateString: String{
        String(self.withMaxDigits(num: 5))
    }
    
    func withMaxDigits(num: Int) -> Double{
        let factor = pow(10,Double(num))
        return (self*factor).rounded()/factor
    }
    
}

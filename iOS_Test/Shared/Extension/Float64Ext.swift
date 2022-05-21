//
//  Float64Ext.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 21/5/22.
//

import Foundation

extension Float64{
    func float64ToString() -> String {
        
        let hours:Int = Int(self.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes:Int = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(self.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}

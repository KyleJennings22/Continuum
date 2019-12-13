//
//  DateExtension.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

extension Date {
   
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: self)
    }
    
}

//
//  DateTime.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/7/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import PDTSimpleCalendar
class DateTime {
    var date: Date!
    var timeString: String = "3:00 PM"
    
    var dateString: String {
        return DateTime.formatDate(date: date)
    }
    
    init(date: Date) {
        self.date = date
    }
    
    static func formatDate(date: Date) -> String {
        var formattedDate = date.description
        formattedDate = formattedDate.replacingOccurrences(of: "-", with: "/")
        let month = formattedDate.components(separatedBy: "/")[1]
        let year = formattedDate.components(separatedBy: "/")[0].components(separatedBy: "0")[1]
        let day = formattedDate.components(separatedBy: "/")[2].components(separatedBy: " ")[0]
        formattedDate = "\(month)/\(day)/\(year)"
        print(formattedDate)
        return formattedDate
    }
}

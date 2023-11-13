//
//  StringExtension.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import Foundation

extension String? {
    func convertUTCStringToDate(outputFormat: String = "d MMM yyyy", useCurrentLocal: Bool = false) -> String? {
        guard let self = self, self.isEmpty else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH: mm: ss'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let utcDate = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            if useCurrentLocal {
                dateFormatter.locale = Locale(identifier: "ar")
            } else {
                dateFormatter.locale = Locale(identifier: "en_US")
            }
            let simpleDateString = dateFormatter.string(from: utcDate)
            return simpleDateString
        } else {
            return nil
        }
    }
}

//
//  TransactionGroup.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022-11-20.
//

import Foundation

struct TransactionGroup: Identifiable {
    
    enum DateType: Hashable, Comparable {
        case month(Date), thisMonth, thisWeek, today
        
        static func from(_ date: Date) -> DateType {
            let calendar = Calendar.current
            let today = Date()
            if calendar.isDateInToday(date) {
                return .today
            } else if calendar.isDate(date, equalTo: today, toGranularity: .weekOfMonth) {
                return .thisWeek
            } else if calendar.isDate(date, equalTo: today, toGranularity: .month) {
                return .thisMonth
            } else {
                let dateComponents = calendar.dateComponents([.year, .month], from: date)
                let newDate = calendar.date(from: dateComponents) ?? Date()
                return .month(newDate)
            }
        }
        
        var description: String {
            switch self {
            case .today:
                return "今天"
            case .thisWeek:
                return "本周"
            case .thisMonth:
                return "本月"
            case .month(let date):
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.setLocalizedDateFormatFromTemplate("yyyyMM")
                return formatter.string(from: date)
            }
        }
    }
    
    var id: DateType
    var transactions: [Transaction]
    
    var title: String {
        self.id.description
    }
}

typealias TransactionGroupDictionary = [TransactionGroup.DateType: [Transaction]]

extension Array where Element == Transaction {
    func grouped() -> [TransactionGroup] {
        let sorted = self.sorted { $0.date > $1.date }
        let dict: TransactionGroupDictionary = sorted.reduce(into: TransactionGroupDictionary()) { partialResult, transaction in
            let dateType = TransactionGroup.DateType.from(transaction.date)
            var arr = partialResult[dateType] ?? []
            arr.append(transaction)
            partialResult[dateType] = arr
        }
        return dict.map { (key: TransactionGroup.DateType, value: [Transaction]) in
            TransactionGroup(id: key, transactions: value)
        }.sorted { $0.id > $1.id }
    }
}

//
//  CurrencyText.swift.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/4.
//

import SwiftUI

struct CurrencyText: View {
    var value: Int
    var textStyle: Font.TextStyle
    var valueNumber: NSNumber {
        let doubleValue = Double(value)
        return NSNumber(value: doubleValue / 100)
    }
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    init(_ value: Int, textStyle: Font.TextStyle = .body) {
        self.value = value
        self.textStyle = textStyle
    }
    
    var body: some View {
        Text(valueNumber, formatter: Self.formatter)
            .font(.system(self.textStyle, design: .rounded))
    }
}

struct CurrencyText_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyText(-1234, textStyle: .largeTitle)
            .fontWeight(.bold)
    }
}

//
//  SectionTitle.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/17.
//

import SwiftUI

struct SectionTitle: View {
    var title = ""
    
    init(_ title: String = "") {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle()
    }
}

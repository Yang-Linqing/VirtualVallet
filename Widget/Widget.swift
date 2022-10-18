//
//  Widget.swift
//  Widget
//
//  Created by 杨林青 on 2022/7/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WalletBalanceEntry {
        WalletBalanceEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (WalletBalanceEntry) -> ()) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let userDefaults = UserDefaults(suiteName: "group.cn.ylq-dev.Virtual-Wallet"),
           let entryJSON = userDefaults.string(forKey: "cn.ylq-dev.Virtual-Wallet.Widget.WalletBalance"),
           let entry = try? decoder.decode(WalletBalanceEntry.self, from: entryJSON.data(using: .utf8)!)
        {
            completion(entry)
        } else {
            completion(WalletBalanceEntry.placeholder)
        }
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WalletBalanceEntry] = []
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let userDefaults = UserDefaults(suiteName: "group.cn.ylq-dev.Virtual-Wallet"),
           let entryJSON = userDefaults.string(forKey: "cn.ylq-dev.Virtual-Wallet.Widget.WalletBalance"),
           let entry = try? decoder.decode(WalletBalanceEntry.self, from: entryJSON.data(using: .utf8)!)
        {
            entries = [entry]
        } else {
            entries = [
                WalletBalanceEntry.placeholder
            ]
        }
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack {
                Text(entry.primary.name)
                    .lineLimit(1)
                    .font(.caption)
                    .minimumScaleFactor(0.3)
                CurrencyText(entry.primary.balance)
                    .lineLimit(1)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .privacySensitive()
                Image(systemName: "creditcard.fill")
            }
            .padding(4.0)
        }
    }
}

@main
struct WalletBalanceWidget: Widget {
    let kind: String = "cn.ylq-dev.Virtual-Wallet.Widget.WalletBalance"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("钱包余额")
        .description("显示主要钱包的余额。如果空间足够，也会显示次要钱包的余额。")
        .supportedFamilies([.accessoryCircular])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: WalletBalanceEntry.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

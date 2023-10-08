//
//  NewTransactionWizard.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/23.
//

import SwiftUI
import MyViewLibrary

/// 记录新交易的视图模型
struct NewTransactionConfig {
    var total: Double?
    var incomingWallet: Wallet? = nil
    var targetWallet: Wallet? = nil
    var date: Date = Date()
    var type: String = ""
    var firstAppear = true
    
    var isValid: Bool {
        (total != nil) && (incomingWallet != nil || targetWallet != nil)
    }
    
    mutating func swapWallet() {
        let tmp = incomingWallet
        incomingWallet = targetWallet
        targetWallet = tmp
    }
    
    var suggestions: [String] {
        (incomingWallet?.transactionTypeSuggestions ?? []) + (targetWallet?.transactionTypeSuggestions ?? [])
    }
    
    mutating func initWithStore(_ store: VirtualWalletStore) {
        incomingWallet = store.primaryWallet
        targetWallet = store.secondaryWallet.last
    }
    
    func save(to store: VirtualWalletStore) {
        guard isValid else { return }
        let intTotal = Int((self.total ?? 0.0) * 100)
        for wallet in store.allWallet {
            if wallet.id == incomingWallet?.id {
                var outgoingTransaction = Transaction()
                outgoingTransaction.date = self.date
                outgoingTransaction.total = -abs(intTotal)
                if self.type == "" {
                    outgoingTransaction.type = "转至\(targetWallet?.name ?? "")"
                } else {
                    outgoingTransaction.type = self.type
                }
                store.insert(outgoingTransaction, into: wallet)
            }
            if wallet.id == targetWallet?.id {
                var incomingTransaction = Transaction()
                incomingTransaction.date = self.date
                incomingTransaction.total = abs(intTotal)
                if self.type == "" {
                    incomingTransaction.type = "转自\(incomingWallet?.name ?? "")"
                } else {
                    incomingTransaction.type = self.type
                }
                store.insert(incomingTransaction, into: wallet)
            }
        }
    }
}

struct NewTransactionSheet: View {
    // MARK: Environment Variables
    @EnvironmentObject private var store: VirtualWalletStore
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .body) private var digitSize = 50
    
    @State var config: NewTransactionConfig = NewTransactionConfig()
    
    enum Field {
        case digit
    }
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if let total = config.total {
                        config.total = -total
                    }
                } label: {
                    Label("切换正负", systemImage: "plus.forwardslash.minus")
                }
                .opacity(focusedField == .digit ? 1 : 0)
                TextField("金额", value: $config.total, format: .currency(code: .localCurrencyID), prompt: Text("金额"))
                    .font(.system(size: digitSize, weight: .semibold, design: .rounded))
                    .focused($focusedField, equals: .digit)
                    .onSubmit {
                        config.total = config.total
                        // 这是一个黑魔法
                    }
                    .keyboardType(.decimalPad)
                Button {
                    config.total = nil
                } label: {
                    Label("清零", systemImage: "eraser.line.dashed.fill")
                }
                .opacity(focusedField == .digit ? 1 : 0)
            }
            .background(.background)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .labelStyle(.iconOnly)
            .onTapGesture {
                focusedField = .digit
            }
            .padding(.vertical, digitSize)
            
            Group {
                HStack {
                    Text("账户信息")
                    Spacer()
                    Button {
                        config.swapWallet()
                    } label: {
                        Label("交换", systemImage: "arrow.left.arrow.right")
                            .bold()
                    }
                }
                Rectangle()
                    .frame(height: 1)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("付款钱包")
                    Spacer()
                    WalletPicker(selection: $config.incomingWallet)
                }
                HStack(alignment: .firstTextBaseline) {
                    Text("收款钱包")
                    Spacer()
                    WalletPicker(selection: $config.targetWallet)
                }
            }
            .tint(.primary)
            
            Rectangle()
                .frame(height: 1)
                .padding(.top)
            SearchSuggestionTextFieldButton("类型", text: $config.type, suggestions: config.suggestions)
            DatePicker(selection: $config.date, label: { Text("时间") })

            Spacer()
            Button{
                config.save(to: store)
                dismiss()
            } label: {
                Text("记录")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!config.isValid)
            Button {
                dismiss()
            } label: {
                Text("丢弃")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding(.horizontal)
        .background(.background)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            focusedField = nil
            let total = config.total
            config.total = nil
            config.total = total
        }
        .onAppear {
            if !config.firstAppear {
                return
            }
            config.firstAppear = false
            
            config.initWithStore(store)
            focusedField = .digit
        }
    }
}

#Preview {
    NewTransactionSheet()
        .environmentObject(VirtualWalletStore())
        .tint(.brown)
}

struct WalletPicker: View {
    @EnvironmentObject private var store: VirtualWalletStore
    
    @Binding var selection: Wallet?
    var title = "无"
    
    var body: some View {
        Menu {
            Button(title) {
                selection = nil
            }
            Section {
                Button(store.primaryWallet.name) {
                    selection = store.document.primaryWallet as Wallet?
                }
            }
            Section {
                ForEach(store.secondaryWallet) { wallet in
                    Button(wallet.name) {
                        selection = wallet as Wallet?
                    }
                }
            }
            Section {
                ForEach(store.otherWallet) { wallet in
                    Button(wallet.name) {
                        selection = wallet as Wallet?
                    }
                }
            }
        } label: {
            HStack {
                if selection != nil {
                    VStack(alignment: .trailing) {
                        Text(selection!.name)
                            .bold()
                        Text(selection!.balance.currencyString)
                            .font(.caption)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                } else {
                    Text(title)
                        .bold()
                }
            }
        }
    }
    
}

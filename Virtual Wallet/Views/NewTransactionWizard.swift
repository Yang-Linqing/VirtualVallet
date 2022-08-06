//
//  NewTransactionWizard.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/23.
//

import SwiftUI

// MARK: 导航标记
fileprivate struct NaviPageTypeSetDirection: Codable, Hashable {
    var id = UUID()
}

struct NewTransactionWizard: View {
    // MARK: Environment Variables
    @Environment(\.document) private var documentBinding
    private var document: VirtualWalletDocument {
        get { documentBinding.wrappedValue }
        set { documentBinding.wrappedValue = newValue }
    }
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Wizard State
    @State private var incomingWallet: Wallet?
    @State private var targetWallet: Wallet?
    @State private var date = Date()
    @State private var type = ""
    @State private var total = 0
    
    var body: some View {
        NavigationView {
            firstPage_SetDirection()
        }
        .onAppear {
            incomingWallet = document.primaryWallet
        }
    }
    
    // MARK: 第一页 选择钱包和时间
    @ViewBuilder func selectWalletView() -> some View {
        Text("无").tag(nil as Wallet?)
        Section {
            Text(document.primaryWallet.name).tag(document.primaryWallet as Wallet?)
        }
        Section {
            ForEach(document.secondaryWallet) { wallet in
                Text(wallet.name).tag(wallet as Wallet?)
            }
        }
        Section {
            ForEach(document.otherWallet) { wallet in
                Text(wallet.name).tag(wallet as Wallet?)
            }
        }
    }
    
    @ViewBuilder func firstPage_SetDirection() -> some View {
        Form {
            Section {
                Picker(selection: $incomingWallet) {
                    selectWalletView()
                } label: {
                    Text("付款钱包")
                }
                Picker(selection: $targetWallet) {
                    selectWalletView()
                } label: {
                    Text("收款钱包")
                }
            } footer: {
                Text("要从钱包之间转账，请同时选择付款钱包和收款钱包。")
            }
            DatePicker(selection: $date, label: { Text("时间") })
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    let temp = incomingWallet
                    incomingWallet = targetWallet
                    targetWallet = temp
                } label: {
                    Text("交换钱包")
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .buttonStyle(.bordered)
                NavigationLink {
                    secondPage_SetType()
                } label: {
                    Text("下一步")
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .navigationTitle("记账")
    }
    
    // MARK: 第二页 选择类型
    private var suggestions: [String] {
        (incomingWallet?.transactionTypeSuggestions ?? []) + (targetWallet?.transactionTypeSuggestions ?? [])
    }
    @ViewBuilder func secondPage_SetType() -> some View {
        Form {
            SearchSuggestionTextField(nil, text: $type, suggestions: suggestions)
        }
        .safeAreaInset(edge: .bottom, content: {
            NavigationLink {
                thirdPage_SetTotal()
            } label: {
                Text("下一步")
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        })
        .navigationTitle("类别")
    }
    
    // MARK: 第三页 输入金额
    @ViewBuilder func thirdPage_SetTotal() -> some View {
        Form {
            PriceField(value: $total, positiveOnly: true) {
                Text("总额")
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Button {
                saveTransfer()
            } label: {
                Text("记录")
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        })
        .navigationTitle("金额")
    }
    
    // MARK: 保存
    func saveTransfer() {
        check(documentBinding.primaryWallet)
        documentBinding.secondaryWallet.forEach { wallet in
            check(wallet)
        }
        documentBinding.otherWallet.forEach { wallet in
            check(wallet)
        }
        
        dismiss()
    }
    
    func check(_ wallet: Binding<Wallet>) {
        if wallet.id == incomingWallet?.id {
            var outgoingTransaction = Transaction()
            outgoingTransaction.date = Date()
            outgoingTransaction.total = -abs(self.total)
            if self.type == "" {
                outgoingTransaction.type = "转至\(targetWallet?.name ?? "")"
            } else {
                outgoingTransaction.type = self.type
            }
            wallet.wrappedValue.transactions.insert(outgoingTransaction, at: 0)
        }
        if wallet.id == targetWallet?.id {
            var incomingTransaction = Transaction()
            incomingTransaction.date = Date()
            incomingTransaction.total = abs(self.total)
            if self.type == "" {
                incomingTransaction.type = "转自\(incomingWallet?.name ?? "")"
            } else {
                incomingTransaction.type = self.type
            }
            wallet.wrappedValue.transactions.insert(incomingTransaction, at: 0)
        }
    }
}

struct NewTransactionWizard_Previews: PreviewProvider {
    @State private static var document = VirtualWalletDocument()
    
    static var previews: some View {
        NewTransactionWizard()
            .document($document)
    }
}

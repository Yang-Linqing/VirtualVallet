//
//  NewTransactionWizard.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/23.
//

import SwiftUI
import MyViewLibrary

struct NewTransactionSheet: View {
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
        Form {
            accountSection()
            setTypeSection()
            setTotalSection()
        }
        .safeAreaInset(edge: .bottom, content: {
            Button {
                saveTransfer()
            } label: {
                Text("记账")
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .background {
                Rectangle()
                    .fill(.bar)
                    .ignoresSafeArea()
            }
        })
        .onAppear {
            incomingWallet = document.primaryWallet
        }
    }
    
    // MARK: 选择钱包
    @ViewBuilder func accountSection() -> some View {
        Section {
            HStack {
                WalletPicker(selection: $incomingWallet)
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                WalletPicker(selection: $targetWallet)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        } header: {
            HStack {
                SectionTitle("账户")
                Spacer()
                Button("交换") {
                    let temp = incomingWallet
                    incomingWallet = targetWallet
                    targetWallet = temp
                }
            }
            .padding(.top)
        }
    }
    
    // MARK: 选择时间和类型
    private var suggestions: [String] {
        (incomingWallet?.transactionTypeSuggestions ?? []) + (targetWallet?.transactionTypeSuggestions ?? [])
    }
    @State private var presentTypeSuggestion = false
    @ViewBuilder func setTypeSection() -> some View {
        Section {
            DatePicker(selection: $date, label: { Text("时间") })
            SearchSuggestionTextField("类型", text: $type, suggestions: suggestions)
        }
    }
    
    // MARK: 第三页 输入金额
    @ViewBuilder func setTotalSection() -> some View {
        Section {
            PriceField(value: $total, positiveOnly: true) {
                Text("总额")
            }
        }
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

struct NewTransactionSheet_Previews: PreviewProvider {
    @State private static var document = VirtualWalletDocument()
    
    static var previews: some View {
        NewTransactionSheet()
            .document($document)
    }
}

struct WalletPicker: View {
    // MARK: Environment Variables
    @Environment(\.document) private var documentBinding
    private var document: VirtualWalletDocument {
        get { documentBinding.wrappedValue }
        set { documentBinding.wrappedValue = newValue }
    }
    
    @Binding var selection: Wallet?
    
    var body: some View {
        Menu {
            Button("无") {
                selection = nil
            }
            Section {
                Button(document.primaryWallet.name) {
                    selection = document.primaryWallet
                }
            }
            Section {
                ForEach(document.secondaryWallet) { wallet in
                    Button(wallet.name) {
                        selection = wallet
                    }
                }
            }
            Section {
                ForEach(document.otherWallet) { wallet in
                    Button(wallet.name) {
                        selection = wallet
                    }
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                HStack {
                    Text(selection?.name ?? "无")
                    Spacer()
                    Divider()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8))
            }
            .tint(Color.primary)
        }

    }
    
}

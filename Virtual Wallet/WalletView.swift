//
//  WalletView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import MyViewLibrary

struct WalletView: View {
    @Binding var wallet: Wallet
    @State private var selection = Set<UUID>()
    @Environment(\.editMode) private var editMode
    @State private var showSquashSheet = false
    
    var body: some View {
        List(selection: $selection) {
            ForEach(wallet.transactions.grouped()) { group in
                Section {
                    ForEach(group.transactions) { transaction in
                        TransactionRow(transaction: $wallet[transaction.id], suggestions: wallet.transactionTypeSuggestions)
                            .swipeActions {
                                Button("删除", role: .destructive) {
                                    wallet.deleteTransactions([transaction.id])
                                }
                            }
                    }
                } header: {
                    SectionTitle(group.title)
                }
            }
        }
        .sheet(isPresented: $showSquashSheet) {
            VStack {
                HStack {
                    Text("如何压缩？")
                        .bold()
                    Spacer()
                }
                Button {
                    squashSelectedByType()
                    showSquashSheet = false
                } label: {
                    HStack(spacing: 0.0) {
                        VStack(alignment: .leading) {
                            Text("合并同类项").bold()
                            Text("将相同类型交易金额汇总到每类最近一笔上。")
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.trailing)
                        Spacer()
                        Image(systemName: "arrow.triangle.pull")
                            .resizable()
                            .frame(width: 25.0, height: 50.0)
                        Image(systemName: "arrow.triangle.pull")
                            .resizable()
                            .frame(width: 25.0, height: 50.0)
                    }
                }
                .buttonCard()
                Button(role: .destructive) {
                    squashSelected()
                    showSquashSheet = false
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("压缩为一个").bold()
                            Text("将所有交易金额汇总到最近一笔上。")
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.trailing)
                        Spacer()
                        Image(systemName: "arrow.triangle.merge")
                            .resizable()
                            .frame(width: 40.0, height: 50.0)
                    }
                }
                .buttonCard()
                Button {
                    showSquashSheet = false
                } label: {
                    Text("取消").frame(maxWidth: .infinity)
                }
                .buttonCard()
                .padding(.top)
                Spacer()
            }
            .padding()
            .actionSheetBackground()
            .presentationDetents([.medium])
        }
        .navigationTitle($wallet.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                if editMode?.wrappedValue.isEditing == true {
                    Button(role: .destructive) {
                        withAnimation {
                            deleteSelected()
                        }
                    } label: {
                        Label("删除", systemImage: "xmark.bin")
                            .labelStyle(.titleAndIcon)
                    }
                    .tint(.red)
                    .disabled(selection.isEmpty)
                    Button {
                        showSquashSheet = true
                    } label: {
                        Label("压缩", systemImage: "archivebox")
                            .labelStyle(.titleAndIcon)
                    }
                    .disabled(selection.isEmpty)
                } else {
                    Button {
                        withAnimation {
                            wallet.transactions.insert(Transaction(date: Date(), total: 0, type: ""), at: 0)
                        }
                    } label: {
                        Label("添加交易", systemImage: "plus.circle.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            ToolbarItemGroup(placement: .status) {
                if editMode?.wrappedValue.isEditing == true {
                    CurrencyText(selectedTotal)
                } else {
                    CurrencyText(wallet.balance)
                }
            }
            ToolbarItemGroup {
                if editMode?.wrappedValue.isEditing == true {
                    Button("完成") {
                        withAnimation {
                            editMode?.wrappedValue = .inactive
                        }
                    }
                } else {
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label("选择", systemImage: "checkmark.circle")
                            .labelStyle(.titleAndIcon)
                    }
                    
                }
            }
        }
    }
    
    var selectedTotal: Int {
        wallet.transactions.reduce(0) { partialResult, transaction in
            if selection.contains(transaction.id) {
                return partialResult + transaction.total
            } else {
                return partialResult
            }
        }
    }
    
    func deleteSelected() {
        wallet.deleteTransactions(selection)
    }
    
    func squashSelected() {
        wallet.squashTransactions(selection)
    }
    
    func squashSelectedByType() {
        wallet.squashTransactionsByType(selection)
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

fileprivate extension View {
    func actionSheetBackground() -> some View {
        self.background {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
        }
    }
    func buttonCard() -> some View {
        self.padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            
        }
    }
}

struct WalletView_Previews: PreviewProvider {
    @State static var wallet = Wallet.sampleSet.randomElement()!
    
    static var previews: some View {
        NavigationStack {
            WalletView(wallet: $wallet)
        }
    }
}

//
//  ChildView.swift
//  TestEgenApp
//
//  Created by Rebecca Zadig on 2022-10-28.
//

import SwiftUI
import CoreData

struct ChildView: View {
    enum transMode: String, CaseIterable, Identifiable {
        case alla = "Historik"
        case plus = "Plus"
        case minus = "Minus"
        var id: Self { self }
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var summa = ""
    @State var meddelande = ""
    @ObservedObject var barnet : BarnNamn
    @State var visaAlert = false
    @State var currentTab: Int = 0
    @FocusState private var sumIsFocused: Bool
    @FocusState private var messageIsFocused: Bool
    @State var barntrans = [BarnTransaktion]()
    @State var plustrans = [BarnTransaktion]()
    @State var minustrans = [BarnTransaktion]()
    @State var difftab = transMode.alla
    
    
    init(barnet: BarnNamn) {
        self.barnet = barnet
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.AppColors.LightOrange)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.AppColors.LightPurple)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.AppColors.DarkBrown)], for: .selected)
    }
    
    
    var body: some View {
        NavigationStack {
            
            VStack{
                
                Text(barnet.firstname!)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(5)
                    .foregroundColor(.AppColors.DarkBrown)
                    .multilineTextAlignment(.center)
                    .background(Color.AppColors.LightPurple)
                    .cornerRadius(5)
                
                Spacer()
                
                Text("Veckopeng: \(barnet.weekmoney)" + " kr")
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .foregroundColor(.AppColors.DarkBrown)
                    .background(Color.AppColors.LightGreen)
                    .cornerRadius(5)
                
                Spacer()
                
                
                Text(String(barnet.pengar) + " kr")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .foregroundColor(.AppColors.DarkBrown)
                    .background(Color.AppColors.LightOrange)
                    .cornerRadius(5)
                
                
                Spacer()

                HStack {
                    
                    NavigationLink(destination: GeView(barnet: barnet)){
                        Text ("Ge")
                            .padding()
                            .frame(width: 85)
                            .foregroundColor(.AppColors.DarkBrown)
                            .background(Color.AppColors.LightGreen)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                    }

                    NavigationLink(destination: TaView(barnet: barnet)){
                        Text ("Ta")
                            .padding()
                            .frame(width: 85)
                            .foregroundColor(.AppColors.DarkBrown)
                            .background(Color.AppColors.LightGreen)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                    }
                    
                    NavigationLink(destination: WeekMoneyView(barnet: barnet)) {
                        Text("Veckopeng")
                            .padding()
                            .frame(width: 150)
                            .foregroundColor(.AppColors.DarkBrown)
                            .background(Color.AppColors.LightGreen)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                    }
                }
                Picker("Transaktioner", selection: $difftab) {
                    ForEach(transMode.allCases){
                        value in
                        Text(value.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                switch(difftab) {
                case .alla:
                    TransaktionsView(barntrans: $barntrans)
                case .plus:
                    TransaktionsView(barntrans:
                                        $plustrans
                    )
                case .minus:
                    TransaktionsView(barntrans: $minustrans
                    )
                }
            }
            .padding()
            .background(Color.AppColors.purple)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .alert("Hoppsan! Du har för lite pengar för denna transaktionen", isPresented: $visaAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear() {
               
                loadtransact()
                
            }
            
        }.background(Color.AppColors.LightBeige)
    }
    
    func maketransaction(plus : Bool)
    {
        if(Int32(summa) == nil)
        {
            return
        }
        
        if(plus == true)
        {
            barnet.pengar = barnet.pengar + Int32(summa)!
        } else {
            
            if(Int32(summa)! > barnet.pengar)
            {
                return
            }
            
            barnet.pengar = barnet.pengar - Int32(summa)!
        }
        
        let newTransact = BarnTransaktion(context: viewContext)
        if(plus == true)
        {
            newTransact.amount = Int32(summa)!
        } else {
            newTransact.amount = -Int32(summa)!
        }
        newTransact.barnrelationship = barnet
        newTransact.date = Date()
        newTransact.message = meddelande
        
        do {
            try viewContext.save()
        } catch {
        }
        
        summa = ""
        meddelande = ""
        
        loadtransact()
    }
    
    func loadtransact()
    {
        if let transacts = barnet.transactrelationship {
            
            let subs = transacts as! Set<BarnTransaktion>
            
            var subarray = Array(subs)
            
            subarray = subarray.sorted(by: { $0.date! > $1.date! })
            
            barntrans = subarray
            plustrans = barntrans.filter {$0.amount >= 0}
            minustrans = barntrans.filter {$0.amount < 0}
        }
    }
}
struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(barnet: BarnNamn())
    }
}

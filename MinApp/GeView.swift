//
//  GeView.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-12-19.
//

import SwiftUI
import CoreData

struct GeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State var barnet : BarnNamn
    @State var summa = ""
    @State var meddelande = ""
    @FocusState private var sumIsFocused: Bool
    @FocusState private var messageIsFocused: Bool
    @State var barntrans = [BarnTransaktion]()
    @State var plustrans = [BarnTransaktion]()
    @State var minustrans = [BarnTransaktion]()
    
    var body: some View {
        
        VStack {
            TextField("Ange summa", text: $summa)
                .padding()
                .focused($sumIsFocused)
                .background(Color.AppColors.OtherBeige)
                .cornerRadius(20)
            
            TextField("Meddelande", text: $meddelande)
                .padding()
                .focused($messageIsFocused)
                .background(Color.AppColors.OtherBeige)
                .cornerRadius(20)
            
            Button("Ge pengar")
            {
                maketransaction(plus: true)
                sumIsFocused = false
                messageIsFocused = false
                summa = ""
                meddelande = ""
                
                do {
                    try viewContext.save()
                    dismiss()
                } catch {
                }
            }.padding()
                .foregroundColor(.AppColors.DarkBrown)
                .background(Color.AppColors.LightGreen)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppColors.purple)
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
struct GeView_Previews: PreviewProvider {
    static var previews: some View {
        GeView(barnet: BarnNamn())
    }
}

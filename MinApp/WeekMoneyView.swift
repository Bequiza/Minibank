//
//  WeekMoneyView.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-12-07.
//

import SwiftUI
import CoreData

struct WeekMoneyView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var date = Date.now
    @State var veckopeng = ""
    @State var barnet : BarnNamn
    @State var visaAlert = false
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    
                    Spacer()
                    
                    Text("När ska veckopengen dras?")
                        .font(.title)
                        .foregroundColor(.AppColors.DarkBrown)
                    
                    HStack {
                        
                        
                        TextField("Ange summa..", text: $veckopeng)
                            .padding()
                            .font(.title)
                            .foregroundColor(.AppColors.DarkBrown)
                            .focused($nameIsFocused)
                        
                        Button(action: {
                            
                            if(Int32(veckopeng) == nil)
                            {
                                return
                            }
                     
                            let lastpaid = date.addingTimeInterval(-7*24*60*60)
                                                        
                            barnet.weekmoney = Int32(veckopeng)!
                            barnet.lastmoney = lastpaid
                            barnet.weekmessage = "Veckopeng"
                           
                            
                            do {
                                try viewContext.save()
                                dismiss()
                                nameIsFocused = false
                            } catch {
                            }
                        }) {
                            Text("Ok")
//                                .font(.title3)
                                .padding()
                                .foregroundColor(.AppColors.DarkBrown)
                                .background(Color.AppColors.LightGreen)
                                .cornerRadius(20)
                            
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                                .padding()
                            
                        }
                    }
                    
                    DatePicker("veckopeng", selection: $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: 400)
                        .padding()
                        Spacer()
                }
                .background(Color.AppColors.purple)
            }
            .onAppear() {
                if let lastmon = barnet.lastmoney {
                    let nextmon = lastmon.addingTimeInterval(7*24*60*60)
                    
                    date = nextmon
                }
                
                if(barnet.weekmoney > 0)
                {
                    veckopeng = String(barnet.weekmoney)
                }
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WeekMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        WeekMoneyView(barnet: BarnNamn())
    }
}

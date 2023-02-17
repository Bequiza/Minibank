//
//  transaktionsView.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-12-07.
//

import SwiftUI

struct TransaktionsView: View {
    
    @Binding var barntrans : [BarnTransaktion]
    @State var dateform = DateFormatter()
    
    var body: some View {
        
        List {
            
            if(barntrans.isEmpty)
            {
                Text("")
                    .listRowBackground(Color.AppColors.OtherBeige)
                    .hidden()
            } else {
                
                ForEach(barntrans) { eventlista in
                    
                    HStack {
                        Text(String(eventlista.amount) + " kr")
                            .frame(width: 60, alignment: .leading)
                            .font(.headline)
                        Text(dateform.string(from: eventlista.date!))
                            .font(.headline)
                        
                        VStack {
                            Text(eventlista.message!)
                                .font(.headline)
                        }
                    }
                }
                .listRowBackground(Color.AppColors.OtherBeige)
                
            }
        }.foregroundColor(Color.AppColors.DarkBrown)
            .background(Color.AppColors.OtherBeige)
            .cornerRadius(20)
            .onAppear() {
                dateform.dateStyle = .short
            }
    }
}


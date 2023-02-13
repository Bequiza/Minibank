//
//  AddChildView.swift
//  TestEgenApp
//
//  Created by Rebecca Zadig on 2022-10-28.
//

import SwiftUI
import CoreData

struct AddChildView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State var LaggTill = ""
    
    var body: some View {
        
        VStack{
            
            Spacer(minLength: 75)
            
            Text("Lägg till nytt barn")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.AppColors.DarkBrown)
            
            VStack {
                
                TextField("Barnets namn", text: $LaggTill)
                    .padding()
                    .background(Color.AppColors.OtherBeige)
                    .cornerRadius(20)
                    
                Button("Lägg till")
                {
                    let newName = BarnNamn(context: viewContext)
                    newName.firstname = LaggTill
                    
                    do {
                        try viewContext.save()
                        dismiss()
                    } catch {
                    }
                    LaggTill = ""
                }
               // .font(.title)
                .frame(width: 100, height: 45)
                    .foregroundColor(.AppColors.DarkBrown)
                    .background(Color.AppColors.LightGreen)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                    .padding()
                    
            }
            Spacer()
            Spacer()
        }
        .background(Color.AppColors.purple)
    }
}

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView()
    }
}

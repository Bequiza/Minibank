//
//  ContentView.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-11-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BarnNamn.firstname, ascending: true)],
        animation: .default)
    var items: FetchedResults<BarnNamn>
    
    
    
    var body: some View {
        NavigationStack {
            
            VStack {
                StartView()
                    .padding(.top, 20.0)
                
                
                List {
                    if(items.isEmpty)
                    {
                        Text("")
                            .listRowBackground(Color.AppColors.OtherBeige)
                            .hidden()
                    } else {
                        ForEach(items) { nameitem in
                            
                            NavigationLink(destination: ChildView(barnet: nameitem)) {
                                VStack {
                                    HStack {
                                        Text(nameitem.firstname!)
                                            .padding(.vertical)
                                            .frame(alignment: .leading)
                                            .font(.title2)
                                        Text(String(nameitem.pengar) + " kr")
                                            .padding(.vertical)
                                            .frame(alignment: .leading)
                                            .font(.title2)
                                    }
                                }
                                
                            }
                            .listRowBackground(Color.AppColors.OtherBeige)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    
                }
                .foregroundColor(Color.AppColors.DarkBrown)
                .background(Color.AppColors.OtherBeige)
                .cornerRadius(20)
                .toolbar {
                    EditButton()
                }
                .padding()
                .listStyle(.plain)
                
                
                
                NavigationLink(destination: AddChildView()) {
                    Text("Lägg till barn")
                        .padding()
                        .foregroundColor(.AppColors.DarkBrown)
                        .background(Color.AppColors.LightGreen)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.AppColors.DarkBrown, lineWidth: 2))
                }
                
            }
            .background(Color.AppColors.purple)
        }
        
        .background(Color.AppColors.LightBeige)
        .onAppear() {
            for barn in items {
                if(barn.weekmoney > 0)
                {
                    if let lastmoney = barn.lastmoney {
                        let howlongago = Date().timeIntervalSince(lastmoney)
                        
                        let weeks = Int(howlongago/(7*24*60*60))
                        
                        if(weeks > 0)
                        {
                            for i in 1...weeks {
                                let newTransact = BarnTransaktion(context: viewContext)
                                newTransact.amount = barn.weekmoney
                                newTransact.barnrelationship = barn
                                newTransact.date = lastmoney.addingTimeInterval(TimeInterval(i*(7*24*60*60)))
                                newTransact.message = barn.weekmessage
                                
                                barn.pengar = barn.pengar + barn.weekmoney
                            }
                            
                            barn.lastmoney = lastmoney.addingTimeInterval(TimeInterval(weeks*(7*24*60*60)))
                        }
                        
                        do {
                            try viewContext.save()
                        } catch {
                        }
                    }
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

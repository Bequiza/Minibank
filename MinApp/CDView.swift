//
//  CDView.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-12-01.
//

import SwiftUI

import CoreData

struct CDView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BarnNamn.firstname, ascending: true)],
        animation: .default)
    private var items: FetchedResults<BarnNamn>
    
    @State var addNamn = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                TextField("Lägg till namn", text: $addNamn)
                
                List {
                    ForEach(items) { nameitem in
                       
                            Text(nameitem.firstname!)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                            Button(action: addItem) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                    Text("Select an item")
               }
            }
        }
        
        private func addItem() {
            
            
            withAnimation {
                let newName = BarnNamn(context: viewContext)
                newName.firstname = addNamn
                addNamn = ""
                
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
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    struct CDView_Previews: PreviewProvider {
        static var previews: some View {
            CDView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }


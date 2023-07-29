//
//  ContentView.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var viewModel: ContentViewModel

    @State var notesList: [Note] = []
    
    func getNotesFromDB() async {
        notesList = await viewModel.getProductsListFromGenericDB() ?? []
    }
    
    func addItem() async {
        await viewModel.addNewNote()
        await getNotesFromDB()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            
        }
    }
    
    func getDBDirectory() {
        guard let url = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first
        else {
            return
        }
        let sqlitepath = url.appendingPathComponent("RememberMe")
        print(sqlitepath)
    }
    
    var body: some View {
        NavigationView {
            
                List {
                    if notesList.isEmpty {
                        HStack(alignment: .center) {
                            Spacer()
                            Image("no-data-found")
                                .resizable()
                                .frame(width: 128, height: 100)
                                .cornerRadius(25, corners: .topLeft)
                                .cornerRadius(25, corners: .bottomRight)
                            Spacer()
                        }
                    }
                    
                    ForEach(notesList) { item in
                        NavigationLink {
                            VStack {
                                Text("Item at \(item.date)")
                                Text("Title: \(item.titleString)")
                                Text("Body: \(item.bodyString)")
                                Text("Type: \(item.type.rawValue)")
                            }
                            
                        } label: {
                            Text(item.titleString)
                        }
                    }
                    .onDelete{ indexSet in
                        deleteItems(offsets: indexSet)
                    }
                    
                }
                .padding([.bottom])
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            Task {
                                await addItem()
                            }
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .onAppear {
                    getDBDirectory()
                }
            
            
            
            
            Text("Select an item")
        }
        .task {
            await getNotesFromDB()
        }
    }
    
    

    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        ContentView()
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

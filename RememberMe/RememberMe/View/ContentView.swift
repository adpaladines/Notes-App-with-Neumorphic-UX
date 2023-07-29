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
        Task {
            notesList = await viewModel.getProductsListFromDB() ?? []
        }
    }
    
    func addItem() async {
        await viewModel.addNewNote()
        await getNotesFromDB()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else {
                return
            }
            let note = notesList[index]
            notesList.remove(atOffsets: offsets)
            Task {
                await viewModel.delete(note: note)
            }
        }
    }
    
    func getDBDirectory() {
        guard let url = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first
        else { return }
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
                }else {
                    ForEach(notesList) { item in
                        NavigationLink {
                            NoteView(item: item)
                        } label: {
                            Text(item.titleString)
                        }
                    }
                    .onDelete{ indexSet in
                        deleteItems(offsets: indexSet)
                    }
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
            .refreshable {
                Task {
                    await getNotesFromDB()
                }
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

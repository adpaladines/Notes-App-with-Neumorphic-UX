//
//  ContentView.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import SwiftUI
import CoreData
import Neumorphic

struct ContentView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var orientationInfo: OrientationInfo
    
//    @State var leftNotesList: [Note] = []
    @State var rightNotesList: [Note] = []

    @State var isSearching: Bool = false
    @State var isFilterOpen: Bool = false
    @State var searchText: String = ""
    @State var typeSelected: NoteType = .all
    @State var isEditingGrid: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderNotesView(isEditingGrid: $isEditingGrid)
                    .padding([.horizontal])
                    .padding([.top], orientationInfo.orientation == .portrait ? 16 : 4)
                TitleMainView(isSearchActive: isSearching, isFilterOpen: isFilterOpen)
                    .padding([.horizontal])
                    .padding([.vertical], orientationInfo.orientation == .portrait ? 16 : 0)
                NotesToolbar(
                    isSearching: $isSearching,
                    isFilterOpen: $isFilterOpen,
                    searchText: $searchText,
                    typeSelected: $typeSelected
                ) {
                    Task {
                        await self.addItem()
                    }
                }
                .padding([.horizontal])
                if isFilterOpen {
                    FilterToolBar(typeSelected: $typeSelected)
                        .padding([.bottom], orientationInfo.orientation == .portrait ? 16 : 0)
                        .padding([.top], 0)
                        .padding([.horizontal])
                }
                ScrollView {
                    if rightNotesList.isNotEmpty {
                            NotesVGridView(
                                notesList: rightNotesList,
                                isEditingGrid: isEditingGrid,
                                maxHeight: 256,
                                backButtonTitle:
                                    GetString.shared.getMainTitleString(when: isSearching),
                                deletionClosure: { index in
                                    print(index)
                                        deleteItems(index: index, side: .right)
                                    }, refreshUI: {
                                    Task {
                                        await getNotesFromDB()
                                    }
                                })
                            .onChange(of: rightNotesList.count) { newValue in
                                print("rightNotesList.count = \(newValue)")
                                Task {
                                    await getNotesFromDB()
                                }
                            }
                    } else {
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
                }
                .padding([.top], isFilterOpen ? 0 :
                            orientationInfo.orientation == .portrait ? 32 : 24)
                .toolbar(.hidden)
            }
            .background(Image("white-camouflage").opacity(0.35))
        }
        .task {
            await getNotesFromDB()
        }
    }
}

extension ContentView {
    
    func getNotesFromDB() async {
        Task {
            rightNotesList = await viewModel.getProductsListFromDB()
        }
    }
    
    func addItem() async {
        let newDefaultNote = Note().newDefaultNote
        withAnimation {
            rightNotesList.append(newDefaultNote)
        }
        await viewModel.add(new: newDefaultNote)
    }
    
    func deleteItems(index: Int, side: GridSide) {
        withAnimation {
            var selectedNote: Note
            selectedNote = rightNotesList[index]
            rightNotesList.remove(at: index)
            Task {
                await viewModel.delete(note: selectedNote)
//                rightNotesList = await viewModel.getProductsListFromDB()
            }
        }
    }
    
    func getDBDirectory() {
        guard let url = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first
        else { return }
        let sqlitepath = url.appendingPathComponent("RememberMe")
        print(sqlitepath)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        ContentView()
            .environmentObject(viewModel)
            .environmentObject(OrientationInfo())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

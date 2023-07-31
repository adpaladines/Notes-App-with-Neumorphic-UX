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
    
    @State var leftNotesList: [Note] = []
    @State var rightNotesList: [Note] = []

    @State var isSearching: Bool = false
    @State var isFilterOpen: Bool = false
    @State var searchText: String = ""
    @State var typeSelected: NoteType = .all
    @State var isEditingGrid: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderNotesView(isEditingGrid: $isEditingGrid)
                    .padding([.horizontal])
                    .padding([.top])
                TitleMainView(isSearchActive: isSearching, isFilterOpen: isFilterOpen)
                    .padding()
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
                        .padding([.bottom], 16)
                        .padding([.top], 0)
                        .padding([.horizontal])
                }
                ScrollView {
                    if leftNotesList.isNotEmpty {
                        HStack(alignment: .top) {
                            NotesVGridView(
                                notesList: leftNotesList.reversed(),
                                isEditingGrid: isEditingGrid,
                                maxHeight: 256,
                                backButtonTitle: GetString.shared.getMainTitleString(when: isSearching),
                                deletionClosure: { offsets in
                                    deleteItems(offsets: offsets, side: .left)
                                },
                                refreshUI: {
                                    Task {
                                        await getNotesFromDB()
                                    }
                                })
                            .onChange(of: leftNotesList.count) { newValue in
                                print("leftNotesList.count = \(newValue)")
                                Task {
                                    await getNotesFromDB()
                                }
                                
                            }
                            NotesVGridView(
                                notesList: rightNotesList.reversed(),
                                isEditingGrid: isEditingGrid,
                                maxHeight: 256,
                                backButtonTitle:
                                    GetString.shared.getMainTitleString(when: isSearching),
                                deletionClosure: { offsets in
                                        deleteItems(offsets: offsets, side: .right)
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
                .padding([.top], isFilterOpen ? 0 : 32)
                .toolbar(.hidden)
//                .refreshable {
//                    Task {
//                        await getNotesFromDB()
//                    }
//                }
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
            let toupleList = await viewModel.getProductsListFromDB()
            leftNotesList = toupleList.0
            rightNotesList = toupleList.1
        }
    }
    
    func addItem() async {
        let side: GridSide = (leftNotesList.count + rightNotesList.count).isEven ? .left : .right
        let newDefaultNote = Note().newDefaultNote
        switch side {
        case .left :
            withAnimation {
                leftNotesList.append(newDefaultNote)
            }
        case .right:
            withAnimation {
                rightNotesList.append(newDefaultNote)
            }
        }
        await viewModel.add(new: newDefaultNote)
//        await getNotesFromDB()
    }
    
    func deleteItems(offsets: IndexSet, side: GridSide) {
        guard let index = offsets.first else {
            return
        }
        var selectedNote: Note
        switch side {
        case .left:
            selectedNote = leftNotesList[index]
            withAnimation {
                leftNotesList.remove(atOffsets: offsets)
            }
        case .right:
            selectedNote = rightNotesList[index]
            withAnimation {
                rightNotesList.remove(atOffsets: offsets)
            }
        }
        Task {
            await viewModel.delete(note: selectedNote)
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

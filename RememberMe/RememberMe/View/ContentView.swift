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

    @State var notesList: [Note] = []
    @State var notesEvenList: [Note] = []

    @State var isSearching: Bool = false
    @State var isFilterOpen: Bool = false
    @State var searchText: String = ""
    @State var typeSelected: NoteType = .all
    @State var isEditingGrid: Bool = false
    
    var body: some View {
        var evenIndex = 0
        var oddIndex = 1
        NavigationView {
            VStack {
                HeaderNotesView()
                    .padding()
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
                    if notesList.isNotEmpty {
                        HStack(alignment: .top) {
                            LazyVGrid(columns: [GridItem(.flexible(minimum: 40), spacing: 16)], spacing: 24, pinnedViews: PinnedScrollableViews()) {
                                ForEach(notesList) { item in
                                    
                                    NavigationLink {
                                        NoteView(item: item)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.Neumorphic.lightShadow)
                                                .softOuterShadow()
                                            VStack {
                                                HStack {
                                                    Text(item.titleString)
                                                        .font(.title2)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                        .padding([.bottom], 8)
                                                    Spacer()
                                                }
                                                HStack {
                                                    Text(item.bodyString)
                                                        .font(.footnote)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                    Spacer()
                                                }
                                            }
                                            .padding()
                                        }
                                        .opacity(0.85)
                                    }
                                }
                                .onDelete { indexSet in
                                    deleteItems(offsets: indexSet)
                                }
                            }
                            
                            
                            LazyVGrid(columns: [GridItem(.flexible(minimum: 40), spacing: 16)], spacing: 24, pinnedViews: PinnedScrollableViews()) {
                                ForEach(notesEvenList) { item in
                                    NavigationLink {
                                        NoteView(item: item)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.Neumorphic.lightShadow)
                                                .softOuterShadow()
                                            VStack {
                                                HStack {
                                                    Text(item.titleString)
                                                        .font(.title2)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                        .padding([.bottom], 8)
                                                    Spacer()
                                                }
                                                HStack {
                                                    Text(item.bodyString)
                                                        .font(.footnote)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                    Spacer()
                                                }
                                            }
                                            .padding()
                                        }
                                        .opacity(0.85)
                                    }
                                }
                                .onDelete { indexSet in
                                    deleteItems(offsets: indexSet)
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
            notesList = toupleList.0
            notesEvenList = toupleList.1
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
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        ContentView()
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

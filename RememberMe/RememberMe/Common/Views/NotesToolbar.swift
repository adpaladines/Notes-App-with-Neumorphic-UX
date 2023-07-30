//
//  NotesToolbar.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//


import SwiftUI
import Neumorphic

struct NotesToolbar: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    @Binding var isSearching: Bool
    @Binding var isFilterOpen: Bool
    @Binding var searchText: String
    @Binding var typeSelected: NoteType
    
    let closure: () -> Void
    
    var body: some View {
        HStack {
            Button {} label: {
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .frame(width: 24, height: 28)
                    .foregroundColor(.gray)
                    .softOuterShadow()
                    .onTapGesture {
                        closure()
                    }
            }
            Spacer()
            ZStack {
                if isSearching {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Neumorphic.main)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 8))
                        .frame(height: 32)
                    TextField(searchText, text: $searchText)
                        .padding([.leading], 8)
                        .padding([.trailing], 48)
                }
                HStack {
                    Spacer()
                    Button {} label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                            .softOuterShadow()
                            .onTapGesture {
                                withAnimation {
                                    isSearching.toggle()
                                    searchText = ""
                                }
                            }
                    }
                    .padding([.horizontal], isSearching ? 12 : 0)
                }
            }
            Button {} label: {
                Image(isFilterOpen ? "filter-fill" : "filter-line")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                    .shadow(radius: 4)
                    .onTapGesture {
                        withAnimation {
                            isFilterOpen.toggle()
                            typeSelected = .all
                        }
                    }
            }
            .padding([.horizontal], 8)
        }
        .frame(height: 36)
    }
}

struct NotesToolbar_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        NotesToolbar(isSearching: .constant(true), isFilterOpen: .constant(true), searchText: .constant("Text"), typeSelected: .constant(.all)) { }
        .environmentObject(viewModel)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

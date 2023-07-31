//
//  NotesVGrid.swift
//  RememberMe
//
//  Created by andres paladines on 7/30/23.
//

import SwiftUI
import Neumorphic

struct NotesVGridView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var notesList: [Note]
    var isEditingGrid: Bool
    var maxHeight: CGFloat
    var backButtonTitle: String
    
    let deletionClosure: (_ offsets: IndexSet) -> Void
    
    let refreshUI: () -> Void
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(minimum: 40), spacing: 16)], spacing: 24, pinnedViews: PinnedScrollableViews()) {
            ForEach(notesList) { item in
                
                NavigationLink {
                    NoteEditionView(
                        item: item,
                        backButtonTitle:
                            backButtonTitle,
                        refreshUI: {
                            refreshUI()
                        })
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Neumorphic.lightShadow)
                            .softOuterShadow()
                        VStack {
                            HStack {
                                Text(item.titleString)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .padding([.bottom], 8)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                            HStack {
                                Text(item.bodyString)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(4)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                        }
                        .padding()
                        if isEditingGrid {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        guard let index = notesList.firstIndex(of: item) else {
                                            return
                                        }
                                        let indexSet = IndexSet(integer: index)
                                        deletionClosure(indexSet)
                                    }label: {
                                        VStack {
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 48, height: 36)
                                        .background(Color.red)
                                        .cornerRadius(8, corners: .bottomLeft)
                                        .cornerRadius(8, corners: .topRight)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .opacity(0.85)
                }
            }
            .onDelete { indexSet in
                deletionClosure(indexSet)
//                deleteItems(offsets: indexSet)
            }
//            .frame(maxHeight: 128)
        }
        .padding([.horizontal], 8)
    }
}

struct NotesVGrid_Previews: PreviewProvider {

    
    static var previews: some View {
        let viewModel = ContentViewModel()
        NotesVGridView(notesList: [
            Note(
                uuid: UUID().uuidString,
                titleString: "Title \(Int.random(in: 0...10))",
                bodyString: "Body \(Int.random(in: 0...10))",
                date: Date(),
                type: .birthday
            )
        ], isEditingGrid: false, maxHeight: 196, backButtonTitle: GetString.shared.getMainBodyString(when: true), deletionClosure: { indexSet in
            print("indexSet: \(indexSet)")
        }, refreshUI: {
            
        })
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

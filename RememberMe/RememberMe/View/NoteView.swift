//
//  NoteView.swift
//  RememberMe
//
//  Created by andres paladines on 7/29/23.
//

import SwiftUI

struct NoteView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var item: Note
    @State var titleString: String = ""
    @State var bodyString: String = ""

    
    var body: some View {
        VStack {
            Text("Item at \(item.date)")
            TextField(titleString, text: $titleString)
            TextField(bodyString, text: $bodyString)
            Text("Title: \(item.titleString)")
            Text("Body: \(item.bodyString)")
            Text("Type: \(item.type.rawValue)")
        }
        .onAppear {
            titleString = item.titleString
            bodyString = item.bodyString
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    Task {
                        let newItem = Note(note: item, titleString: titleString, bodyString: bodyString, type: item.type)
                        await viewModel.update(note: newItem)
                    }
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContentViewModel()
        NoteView(item: Note(uuid: UUID().uuidString, titleString: "My Title", bodyString: "My body", date: Date(), type: .home))
            .environmentObject(viewModel)
    }
}

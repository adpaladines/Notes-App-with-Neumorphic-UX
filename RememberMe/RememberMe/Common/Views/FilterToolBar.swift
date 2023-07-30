//
//  FilterToolBar.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//


import SwiftUI
import Neumorphic

struct FilterToolBar: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    @Binding var typeSelected: NoteType
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], alignment: .center, spacing: 16) {
                    ForEach(NoteType.allCases.reversed(), id: \.self) { noteType in
                        ZStack {
                            if noteType == typeSelected {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.Neumorphic.main)
                                    .frame(height: 24)
                                    .softOuterShadow()
                            }else {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.Neumorphic.main.opacity(0.6))
                                    .frame(height: 24)
                                    .softInnerShadow(RoundedRectangle(cornerRadius: 20))
                            }
                            
                            Text(noteType.rawValue)
                                .foregroundColor( (typeSelected == noteType) ? .primary : .gray)
                                .padding([.horizontal])
                                .onTapGesture {
                                    withAnimation {
                                        typeSelected = noteType
                                    }
                                }
                        }
                    }
                }
            }
            .frame(height: 38)
        }
    }
}


struct FilterToolBar_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        FilterToolBar(typeSelected: .constant(.all))
        .environmentObject(viewModel)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

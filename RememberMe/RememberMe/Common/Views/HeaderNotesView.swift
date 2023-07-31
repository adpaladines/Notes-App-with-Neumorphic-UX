//
//  NoteCellView.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/29/23.
//

import SwiftUI
import Neumorphic

struct HeaderNotesView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    @Binding var isEditingGrid: Bool

    let shapeSize: CGFloat = ViewSizes.shared.shapeSize// 48
    let iconSize: CGFloat = ViewSizes.shared.iconSize// 28
    let cornerRadius: CGFloat = ViewSizes.shared.cornerRadius// 12
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.Neumorphic.main)
                            .frame(width: shapeSize, height: shapeSize)
                            .softOuterShadow()
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        print("User tapped")
                    }
                }
                
                Spacer()
                Button {} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.Neumorphic.main)
                            .frame(width: shapeSize, height: shapeSize)
                            .softOuterShadow()
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .frame(width: iconSize-4, height: iconSize-4)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        withAnimation {
                            isEditingGrid.toggle()
                            print("Edition enabled = \(isEditingGrid)")
                        }
                        
                    }
                }
            }
        }
        
    }
}

struct NoteCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        HeaderNotesView(isEditingGrid: .constant(false))
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.Neumorphic.main)
                            .frame(width: 64, height: 64)
                            .softOuterShadow()
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        print("User tapped")
                    }
                }
                
                Spacer()
                Button {} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.Neumorphic.main)
                            .frame(width: 64, height: 64)
                            .softOuterShadow()
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        print("Options tapped")
                    }
                }
            }
        }
        
    }
}

struct NoteCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        HeaderNotesView()
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

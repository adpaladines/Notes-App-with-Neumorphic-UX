//
//  ContentView.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import SwiftUI
import Neumorphic

struct TitleMainView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var isSearchActive: Bool
    var isFilterOpen: Bool
    
    var body: some View {
        let isSearching = isFilterOpen || isSearchActive
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(GetString.shared.getMainTitleString(when: isSearching))
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline) {
                Text(GetString.shared.getMainBodyString(when: isSearching))
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct TitleMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        TitleMainView(isSearchActive: false, isFilterOpen: false)
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

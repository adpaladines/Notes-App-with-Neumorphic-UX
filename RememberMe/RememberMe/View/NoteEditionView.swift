//
//  NoteEditionView.swift
//  RememberMe
//
//  Created by andres paladines on 7/29/23.
//

import SwiftUI
import Neumorphic


struct HeaderNotesEditionView: View {
    
    @State var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    @Binding var isEditingGrid: Bool
    @FocusState var isTitleFocused: Bool
    @FocusState var isBodyFocused: Bool

    let shapeSize: CGFloat = ViewSizes.shared.shapeSize// 48
    let iconSize: CGFloat = ViewSizes.shared.iconSize// 28
    let cornerRadius: CGFloat = ViewSizes.shared.cornerRadius// 12
    let refreshUI: () -> Void
    
    var uuid: String
    var titleString: String
    var bodyString: String
        
    var backButtonTitle: String = "all notes"
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(Color.Neumorphic.main)
//                                .frame(
//                                    minWidth: <#T##CGFloat?#>,
//                                    maxWidth: <#T##CGFloat?#>,
//                                    minHeight: <#T##CGFloat?#>,
//                                    maxHeight: <#T##CGFloat?#>
//                                )
                            
                                .frame(width: shapeSize, height: shapeSize)
                                .softOuterShadow()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            print("Back tapped")
                            dismiss()
                            refreshUI()
                        }
                        .padding([.trailing])
                        
                        Text(backButtonTitle)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.trailing])
                Spacer()
                Button {} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.Neumorphic.main)
                            .frame(width: shapeSize, height: shapeSize)
                            .softOuterShadow()
                        
                        Image(systemName: "tray.and.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        Task {
                            await viewModel.updateNoteWith(
                                with: uuid,
                                titleString: titleString,
                                bodyString: bodyString
                            )
                            isTitleFocused = false
                            isBodyFocused = false
                            
                        }
                        
                    }
                }
                .padding([.trailing])
            }
        }
    }
}

struct HeaderNotesEditionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ContentViewModel()
        HeaderNotesEditionView(
            isEditingGrid: .constant(true),
            isTitleFocused: .init(),
            isBodyFocused: .init(),
            refreshUI: {},
            uuid: "",
            titleString: "",
            bodyString: "",
            backButtonTitle: "all notes"
        )
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


import Combine

struct NoteEditionView: View {
        
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isBodyFocused: Bool

    @State var titleString: String = ""
    @State var bodyString: String = ""
    
    
    @State var isEditing: Bool = false
    
    var item: Note
    var backButtonTitle: String

    let refreshUI: () -> Void
    
    let shapeSize: CGFloat = ViewSizes.shared.shapeSize// 48
    let iconSize: CGFloat = ViewSizes.shared.iconSize// 28
    let cornerRadius: CGFloat = ViewSizes.shared.cornerRadius// 12
    let textLimit = 50
    
    func limitText(_ upper: Int) {
        if titleString.count > upper {
            titleString = String(titleString.prefix(upper))
        }
    }
    
    var body: some View {
        
            VStack {
                HeaderNotesEditionView(
                    isEditingGrid: $isEditing,
                    isTitleFocused: _isTitleFocused,
                    isBodyFocused: _isBodyFocused,
                    refreshUI: {
                        refreshUI()
                    },
                    uuid: item.uuid,
                    titleString: titleString,
                    bodyString: bodyString,
                    backButtonTitle: backButtonTitle
                )
                .padding([.top], orientationInfo.orientation == .portrait ? 12 : 0)
                .padding([.bottom], orientationInfo.orientation == .portrait ? 32 : 0)
                .padding([.leading])
                
                ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Neumorphic.main.opacity(0.7))
                        .softInnerShadow(RoundedRectangle(cornerRadius: 12), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.05, radius: 2)
                    VStack {
                        TextField(titleString, text: $titleString, axis: .horizontal)
                            .onReceive(Just(titleString)) { _ in limitText(textLimit) }
                            .font(.title2)
                            .lineLimit(1, reservesSpace: true)
                            .padding([.horizontal])
                            .padding([.top], 8)
                            .truncationMode(.tail)
                            .focused($isTitleFocused)
                            .scrollDismissesKeyboard(.interactively)
                        Divider()
                        TextEditor(text: $bodyString)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .padding([.horizontal])
                            .padding([.top], 0)
                            .padding([.bottom], 8)
                            .keyboardType(.emailAddress)
                            .focused($isBodyFocused)
                        //                        .toolbar {
                        //                            ToolbarItemGroup(placement: .keyboard) {
                        //                                Spacer()
                        //                                Button("Done") {
                        //                                    isTitleFocused = false
                        //                                    isBodyFocused = false
                        //                                }
                        //                            }
                        //                        }
                            .scrollDismissesKeyboard(.interactively)
                    }
                }
                //            Text("Item at \(item.date)")
                //            Text("Body: \(item.bodyString)")
            }
            .onAppear {
                titleString = item.titleString
                bodyString = item.bodyString
            }
            .toolbar(.hidden)
            .background(Image("white-camouflage").opacity(0.35))
            .padding([.horizontal])
            .padding([.bottom])
//            .onReceive(orientationInfo) { _ in
//                self.orientation = UIDevice.current.orientation
//            }
                Spacer()
            }
//            .onAppear {
//                self.orientation = UIDevice.current.orientation
//                print(self.orientation)
//            }
            .scrollDismissesKeyboard(.interactively)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContentViewModel()
        NoteEditionView(
            item: Note(uuid: UUID().uuidString, titleString: "My Title", bodyString: "My body", date: Date(), type: .home),
            backButtonTitle: "All Notes",
            refreshUI: {}
        )
        .environmentObject(viewModel)
        .environmentObject(OrientationInfo())
    }
}

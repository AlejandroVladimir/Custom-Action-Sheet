//
//  SwiftUIView.swift
//  Custom Action Sheet
//
//  Created by AlejandroVladimir on 3/3/23.
//

import SwiftUI

struct SwiftUIView: View {
    @State var title = "This is a normal text"
    @State var isShowingActionSheet = false
    
    var body: some View {
        VStack {
            Text(title)
            Button {
                isShowingActionSheet.toggle()
            } label: {
                Text("Click here to show the action sheet")
            }
        }
        .fullScreenCover(isPresented: $isShowingActionSheet) {
            ActionSheetView()
                .withTitle("This is a custom action sheet!")
                .withMessage("This is epic :)")
                .withButton(title: "This is a normal action")
                .withButton(title: "This is a destructive action", style: .destructive)
                .withButton(title: "Click here to change label text") {
                    title = "The text changed!"
                }
                .withButton(title: "This is a cancel action", style: .cancel)
                .withBackgroundColor(.black.opacity(0.4))
                .dismissAction {
                    isShowingActionSheet.toggle()
                }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

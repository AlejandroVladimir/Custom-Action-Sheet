//
//  ActionSheetView+Builder.swift
//  Custom Action Sheet
//
//  Created by AlejandroVladimir on 3/2/23.
//

import UIKit
import SwiftUI

extension ActionSheetView {
    final class Builder {
        private var title: String?
        private var message: String?
        private var backgroundColor: Color = .clear
        private var actions = [ActionDetails]()
        private var presentationStyle: UIModalPresentationStyle = .automatic
        
        @discardableResult func withTitle(_ title: String?) -> Builder {
            self.title = title
            return self
        }
        
        @discardableResult func withMessage(_ message: String?) -> Builder {
            self.message = message
            return self
        }
        
        @discardableResult func withBackgroundColor(_ color: Color) -> Builder {
            backgroundColor = color
            return self
        }
        
        @discardableResult func withButton(title: String,
                                           style: ActionStyle = .defaultStyle,
                                           action: (() -> Void)? = nil) -> Builder {
            actions.append(ActionDetails(title: title,
                                         style: style,
                                         action: action))
            return self
        }
        
        @discardableResult func withPresentationStyle(_ style: UIModalPresentationStyle) -> Builder {
            self.presentationStyle = style
            return self
        }
        
        func present(in viewController: UIViewController?) {
            guard let viewController = viewController, viewController.isViewLoaded, viewController.view.window != nil else { return }
            let viewModel = ActionSheetViewModel()
            let actionSheet = ActionSheetView(viewModel: viewModel)
            let hostingController = UIHostingController(rootView: actionSheet)
            
            viewModel.updateSheet(with: title, message: message, actions: actions, backgroundColor: backgroundColor) {
                hostingController.dismiss(animated: true)
            }
            
            hostingController.modalPresentationStyle = presentationStyle
            
            viewController.present(hostingController, animated: true)
        }
    }
}

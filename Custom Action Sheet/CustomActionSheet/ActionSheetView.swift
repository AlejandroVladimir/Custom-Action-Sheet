//
//  ActionSheetView.swift
//  Custom Action Sheet
//
//  Created by AlejandroVladimir on 3/2/23.
//

import SwiftUI

enum ActionStyle {
    case defaultStyle, destructive, cancel
}

class ActionDetails: Hashable {
    let id = UUID()
    let title: String
    let style: ActionStyle
    var action: (() -> Void)?
    
    init(title: String, style: ActionStyle = .defaultStyle, action: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    static func == (lhs: ActionDetails, rhs: ActionDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class ActionSheetViewModel: ObservableObject {
    @Published private(set) var title: String?
    @Published private(set) var message: String?
    @Published private(set) var actions = [ActionDetails]()
    @Published private(set) var backgroundColor: Color = .clear
    @Published private(set) var dismissAction: (() -> Void)?
    @Published private(set) var cancelAction: ActionDetails?
    
    func updateSheet(with title: String? = nil,
                     message: String? = nil,
                     actions: [ActionDetails],
                     backgroundColor: Color = .clear,
                     dismissAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.backgroundColor = backgroundColor
        self.dismissAction = dismissAction
        
        var actions = actions
        cancelAction = actions.first { $0.style == .cancel }
        
        actions.removeAll { $0.style == .cancel }
        self.actions = actions
    }
    
    func updateTitle(with title: String?) {
        self.title = title
    }
    
    func updateMessage(with message: String?) {
        self.message = message
    }
    
    func addNew(action: ActionDetails) {
        actions.append(action)
        
        if let cancelAction = cancelAction {
            actions.append(cancelAction)
            self.cancelAction = nil
        }
        
        updateSheet(with: title,
                    message: message,
                    actions: actions,
                    backgroundColor: backgroundColor,
                    dismissAction: dismissAction)
    }
    
    func updateBackgroundColor(with color: Color) {
        backgroundColor = color
    }
    
    func updateDismiss(action: (() -> Void)?) {
        self.dismissAction = action
    }
}

struct ActionSheetView: View {
    @ObservedObject var viewModel: ActionSheetViewModel
    private let titleFontColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5450980392, alpha: 1)
    private let normalActionBackground = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.8588235294, alpha: 1)
    
    init() {
        viewModel = ActionSheetViewModel()
    }
    
    init(viewModel: ActionSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                if viewModel.title != nil || viewModel.message != nil {
                    VStack {
                        if let title = viewModel.title {
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(Color(titleFontColor))
                        }
                        if let message = viewModel.message {
                            Text(message)
                                .font(.system(size: 12))
                                .foregroundColor(Color(titleFontColor))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 15)
                    .background(Color(normalActionBackground))
                    
                    Divider()
                }
                
                ForEach(viewModel.actions, id: \.id) { action in
                    makeText(for: action)
                    
                    if action != viewModel.actions.last {
                        Divider()
                    }
                }
            }
            .cornerRadius(7)
            .padding([.leading, .trailing], 10)
            .padding(.bottom, 2)
            
            if let cancelAction = viewModel.cancelAction {
                makeText(for: cancelAction)
                    .cornerRadius(7)
                    .padding([.leading, .trailing, .bottom], 10)
            }
        }
        .background(viewModel.backgroundColor)
        .background(Background())
    }
    
    private func makeText(for action: ActionDetails) -> some View {
        Button {
            viewModel.dismissAction?()
            action.action?()
        } label: {
            Text(action.title)
                .fontWeight(fontWeight(for: action.style))
                .frame(maxWidth: .infinity)
        }
        .padding([.top, .bottom], 15)
        .background(backgroundColor(for: action.style))
        .foregroundColor(fontColor(for: action.style))
    }
    
    private func fontColor(for style: ActionStyle) -> Color {
        return style == .destructive ? .red : .accentColor
    }
    
    private func fontWeight(for style: ActionStyle) -> Font.Weight {
        return style == .cancel ? .bold : .regular
    }
    
    private func backgroundColor(for style: ActionStyle) -> Color {
        return style == .cancel ? .white : Color(normalActionBackground)
    }
    
    @inlinable public func withTitle(_ title: String?) -> ActionSheetView {
        viewModel.updateTitle(with: title)
        return self
    }
    
    @inlinable public func withMessage(_ message: String?) -> ActionSheetView {
        viewModel.updateMessage(with: message)
        return self
    }
    
    @inlinable public func withButton(title: String,
                                      style: ActionStyle = .defaultStyle,
                                      action: (() -> Void)? = nil) -> ActionSheetView {
        let action = ActionDetails(title: title,
                                   style: style,
                                   action: action)
        viewModel.addNew(action: action)
        return self
    }
    
    @inlinable public func withBackgroundColor(_ color: Color) -> ActionSheetView {
        viewModel.updateBackgroundColor(with: color)
        return self
    }
    
    @inlinable public func dismissAction(_ action: (() -> Void)?) -> ActionSheetView {
        viewModel.updateDismiss(action: action)
        return self
    }
}

struct Background: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Background>) -> UIViewController {
        return Controller()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Background>) {
    }
    
    class Controller: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.view?.backgroundColor = .clear
        }
    }
}

struct ActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetView(viewModel: ActionSheetViewModel())
    }
}

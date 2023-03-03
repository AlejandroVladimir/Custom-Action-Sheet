//
//  ViewController.swift
//  Custom Action Sheet
//
//  Created by AlejandroVladimir on 3/2/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    
    @IBAction func didTapButton(_ sender: UIButton) {
        ActionSheetView.Builder()
            .withTitle("This is a custom action sheet!")
            .withMessage("This is epic :)")
            .withButton(title: "This is a normal action")
            .withButton(title: "This is a destructive action", style: .destructive)
            .withButton(title: "Click here to change label text") { [weak self] in
                guard let self else { return }
                self.titleLabel.text = "The text changed!"
            }
            .withButton(title: "this is a cancel action", style: .cancel)
            .withBackgroundColor(.black.opacity(0.4))
            .withPresentationStyle(.overCurrentContext)
            .present(in: self)
    }
    
    @IBAction func didTapShow(_ sender: UIButton) {
        let hostingController = UIHostingController(rootView: SwiftUIView())
        hostingController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
}


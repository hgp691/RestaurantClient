//
//  RestaurantListCell_Preview.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 4/10/22.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ViewcontrollerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return RestaurantListViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct ViewController_preview: PreviewProvider {
    static var previews: some View {
        ViewcontrollerRepresentable()
            .preferredColorScheme(.light)
    }
}

#endif

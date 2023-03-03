//
//  Constant.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import Foundation
import SwiftUI

struct Constants {
     static let baseUrl = "https://dummyjson.com/products"
}

enum DataStatus {
    case initial, loading, loaded, failed, empty
}

struct Loading: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<Loading>) -> UIActivityIndicatorView {
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = UIColor.blue
        return loading
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loading>) {
        uiView.startAnimating()
    }

}

//
//  ProductView.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import SwiftUI

struct ProductView: View {
  @ObservedObject var viewModel = ProductViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.products) { item in
          NavigationLink(destination:
            ProductDetailView(viewModel: ProductDetailViewModel(), dataProduct: item)) {
            HStack {
              Image("\(item.thumbnail)")
                  .resizable()
                  .frame(width: 80, height: 80)
                  .cornerRadius(8.0)

              VStack(alignment: .leading, spacing: 8) {
                Text("\(item.title)")
              }
            }
          }
        }
        .navigationBarTitle("EZV")
        .navigationBarItems(trailing:
          NavigationLink(destination: ProfileView()) {
            Image(systemName: "person.circle")
              .resizable()
              .renderingMode(.original)
              .frame(width: 25, height: 25)
              .foregroundColor(Color.green)
        })
        .onAppear { viewModel.fetchProducts() }
        .environmentObject(viewModel)

    }
  }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}

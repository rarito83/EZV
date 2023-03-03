//
//  ProductDetailViewModel.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import Foundation
import SwiftyJSON

class ProductDetailViewModel: ObservableObject {
  
  @Published var product: Product?
  @Published var status: DataStatus = DataStatus.initial
  @Published var isFav: Bool = false

  private lazy var productProvider: ProductProvider = { return ProductProvider() }()

  func toogleFav() {
      if isFav {
        productProvider.deleteProduct(Int(product!.id)) {
              DispatchQueue.main.async {
                  self.isFav = false
              }
          }
      } else {
        productProvider.createProduct(product!) {
              DispatchQueue.main.async {
                  self.isFav = true
              }
          }
      }
  }
}

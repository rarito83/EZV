//
//  Product.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import Foundation

struct Product: Identifiable {
  var id: Int32
  var title: String
  var description: String = ""
  var price: Int32
  var discount: Double
  var rating: Double
  var stock: Int32
  var brand: String
  var category: String
  var thumbnail: String
  var image: String = ""
}

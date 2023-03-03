//
//  ProductViewModel.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import Foundation
import SwiftyJSON

class ProductViewModel: ObservableObject {
  @Published var products = [Product]()
  @Published var status: DataStatus = DataStatus.initial

  func fetchProducts() {
    DispatchQueue.main.async {
        self.status = DataStatus.loading
    }
    
    guard let url = URL(string: "\(Constants.baseUrl)") else { return }
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, _ in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        if response.statusCode == 200 {
            do {
                let json = try JSON(data: data)
                let items = json["products"].array!

                for item in items {
                    let imageList = item["images"].arrayValue.map {$0["images"].stringValue}

                    let product = Product(
                        id: item["id"].int32Value,
                        title: item["title"].stringValue,
                        description: item["description"].stringValue,
                        price: item["price"].int32Value,
                        discount: item["discountPercentage"].doubleValue,
                        rating: item["rating"].doubleValue,
                        stock: item["stock"].int32Value,
                        brand: item["brand"].stringValue,
                        category: item["category"].stringValue,
                        thumbnail: item["thumbnail"].stringValue,
                        image: imageList.joined(separator: ", ")
                    )
                    DispatchQueue.main.async {
                        self.products.append(product)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.status = DataStatus.failed
                }
            }
        } else {
            print("ERROR: \(data), HTTP Status: \(response.statusCode)")
            DispatchQueue.main.async {
                self.status = DataStatus.failed
            }
        }
    }
    task.resume()
  }
}

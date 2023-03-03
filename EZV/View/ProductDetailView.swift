//
//  ProductDetailView.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
  
  @ObservedObject var viewModel = ProductDetailViewModel()
  var dataProduct: Product
  
  var body: some View {
    ZStack {
      if viewModel.status == DataStatus.loaded {
        ScrollView {
          ZStack(alignment: .bottom) {
            let width = UIScreen.main.bounds.size.width
            
            Rectangle()
              .fill(Color.white).frame(width: width, height: 250)
            WebImage(url: URL(string: dataProduct.thumbnail)!)
              .resizable().placeholder { Loading() }
              .scaledToFill().frame(width: width, height: 250.0).clipped()
            RoundedRectangle(cornerRadius: 25, style: .continuous)
              .fill(Color.white).frame(width: width, height: 100).offset(y: 75)
            HStack {
              Spacer()
              Button(action: {
                viewModel.toogleFav()
              }, label: {
                Image(systemName: viewModel.isFav ? "heart.fill" : "heart")
                  .resizable().frame(width: 35, height: 35)
              })
              .frame(width: 75, height: 75)
              .foregroundColor(Color.red)
              .background(Color.white)
              .clipShape(Circle()).padding(.trailing, 35).offset(y: 15)
            }
          }
          
          VStack(alignment: .leading) {
            Text(dataProduct.title)
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundColor(.black)
            HStack {
              Spacer()
            }
          }.padding(.horizontal)
        }
      } else if viewModel.status == DataStatus.failed {
        VStack {
          Text("Something Error")
            .bold().font(.title).foregroundColor(.black)
            .padding(.bottom, 2)
          Text("please try again later")
            .font(.subheadline).foregroundColor(.black)
            .padding(.bottom, 30)
        }
      } else {
        Loading()
      }
    }
  }
}

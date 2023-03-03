//
//  SplashView.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import SwiftUI

struct SplashView: View {
  
  @State private var isActive = false
  @State private var size = 0.4
  @State private var opacity = 0.5
  
  var body: some View {
      if isActive {
          ProductView()
      } else {
          VStack {
            Text("EZV Products")
                .font(.title.bold())
                .fontWeight(.bold)
                .foregroundColor(.green)
          }
          .scaleEffect(size)
          .opacity(opacity)
          .onAppear {
              withAnimation(.easeIn(duration: 2.0)) {
                  self.size = 1.5
                  self.opacity = 1.0
              }
          }
          .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                  self.isActive = true
              }
          }
      }
  }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

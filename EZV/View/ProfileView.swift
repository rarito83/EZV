//
//  ProfileView.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import SwiftUI

struct ProfileView: View {
  
  var body: some View {
    VStack(alignment: .center) {
      Image("rarito")
          .resizable()
          .frame(width: 150.0, height: 150.0)
          .clipShape(Circle())
      
      Text("Rahmat Tri Susanto")
          .bold()
          .padding(.top, 24.0)
  
      Text("iOS Developer")
          .font(.headline)
          .foregroundColor(Color(UIColor.systemGray))
    }
    .padding(.top, 24.0)
    .navigationBarTitle(Text("Akun"), displayMode: .inline)
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

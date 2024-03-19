//
//  SplashView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-20.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("UniLogo")
                .padding()
            Image("UniName")
        }
        .frame(width: 393,height: 852, alignment: .center )
        .offset(y: -50)
        .background(Color(red: 0.58, green: 0.11, blue: 0.5))
    }
}

#Preview {
    SplashView()
}

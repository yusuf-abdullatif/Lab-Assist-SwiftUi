//
//  LoginPage.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-19.
//

import SwiftUI

struct LandingPageView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                NavigationStack {
                    VStack {
                        Text("Lab Assist")
                            .font(
                                Font.custom("SF Pro", size: 40)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 1, green: 1, blue: 1))
                        
                        Image("UniLogo")
                            .padding(55)
                        
                        NavigationLink(destination: LoginPageView()) {
                            ZStack{
                                Image("button")
                                    .padding()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(width: 393,height: 852, alignment: .center )
                    .offset(y: -50)
                    .background(Color(red: 0.58, green: 0.11, blue: 0.5))
                    .navigationBarHidden(true)
                }
            }
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}

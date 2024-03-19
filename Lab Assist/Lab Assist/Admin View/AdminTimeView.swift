//
//  AdminTimeView.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-06.
//

import SwiftUI

struct AdminTimeView: View {
    @EnvironmentObject var appState: AppState
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var minutes: Int {
        appState.remainingTime / 60
    }
    
    var seconds: Int {
        appState.remainingTime % 60
    }
    
    var body: some View {
            ZStack {
                
                VStack {
                    Spacer()

                    VStack(alignment: .center) {
                        Text("Time left with student")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(40)
                        
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 20)
                                .opacity(0.3)
                                .foregroundColor(.gray)
                                .frame(width: 200, height: 200)

                            Circle()
                                .trim(from: 0, to: CGFloat(appState.remainingTime) / CGFloat(appState.timerDuration))
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color(red: 0.58, green: 0.11, blue: 0.5))
                                .rotationEffect(.degrees(-90))
                                .onAppear {
                                    withAnimation(.linear(duration: 1)) {
                                        
                                    }
                                }
                                .frame(width: 200, height: 200)

                            Text("\(minutes):\(String(format: "%02d", seconds))")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        Text("\(appState.studentsAfterSelected) students waiting in line")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                    .padding()
                    Spacer()
                }
                .navigationBarTitle("Admin Time View", displayMode: .inline)
                .onReceive(timer) { _ in
                    if appState.remainingTime > 0 && appState.timerActive {
                        appState.remainingTime -= 1
                    } else {
                        timer.upstream.connect().cancel()
                        if appState.remainingTime <= 0 {
                            appState.timerActive = false
                        }
                    }
                }
                .onChange(of: appState.timerActive) { isActive in
                    if isActive {
                        appState.remainingTime = appState.timerDuration
                    }
                }
            }
        
    }
}


struct AdminTimeView_Previews: PreviewProvider {
    @State static var peopleInFront = 5
    static var previews: some View {
        AdminTimeView()
    }
}

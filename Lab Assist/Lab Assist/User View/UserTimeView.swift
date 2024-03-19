//
//  TimeView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//
import SwiftUI

struct UserTimeView: View {
    @EnvironmentObject var appState: AppState
    
    private var remainingTime: (minutes: Int, seconds: Int) {
        (appState.remainingTimeInSeconds / 60, appState.remainingTimeInSeconds % 60)
    }
    
    private var peopleAheadInQueue: Int {
        (appState.remainingTimeInSeconds / 60) / 10
    }
    
    var body: some View {
        //NavigationView {
            VStack {
                Spacer()
                if appState.isLoggedIn {
                    VStack(alignment: .center) {
                        Text("Time left for your turn")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 20)
                                .opacity(0.3)
                                .foregroundColor(.gray)
                                .frame(width: 200, height: 200)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(min(appState.remainingTimeInSeconds, appState.waitingTimeForCurrentUser() * 60)) / CGFloat(appState.waitingTimeForCurrentUser() * 60))
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color(red: 0.58, green: 0.11, blue: 0.5))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 200, height: 200)
                            
                            Text("\(remainingTime.minutes):\(String(format: "%02d", remainingTime.seconds))")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // Display the modified waiting time and people in front calculation
                        VStack {
                            Text("Waiting time: \(appState.remainingTimeInSeconds / 60) minutes")
                            Text("\(peopleAheadInQueue) people before you")
                        }
                        .padding()
                    }
                    .padding()
                } else {
                    Text("Please log in to see your queue status.")
                }
                Spacer()
            }
            .navigationBarTitle("Your Turn", displayMode: .inline)
        }
    //}
}

struct UserTimeView_Previews: PreviewProvider {
    static var previews: some View {
        UserTimeView().environmentObject(AppState())
    }
}

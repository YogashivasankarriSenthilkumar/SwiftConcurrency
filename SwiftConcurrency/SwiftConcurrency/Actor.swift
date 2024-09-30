//
//  Actor.swift
//  SwiftConcurrency
//
//  Created by Yogashivasankarri Senthilkumar on 03/01/24.
//

import SwiftUI

class MyDataManager {

    static let instance = MyDataManager()
    private init() { }

    var data: [String] = []

    func getRandomData() -> String? {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            return data.randomElement()
    }

}

actor MyActorDataManager {

    static let instance = MyActorDataManager()
    private init() { }

    var data: [String] = []


    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }

}


struct HomeView: View {

    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()

            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
//            Task {
//                if let data = await manager.getRandomData() {
//                    await MainActor.run(body: {
//                        self.text = data
//                    })
//                }
//            }
//        }
//    }
            DispatchQueue.global(qos: .background).async {
                if let data = manager.getRandomData() {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
          }
        }
    }

struct BrowseView: View {

    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()

            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
        }
    }
}

struct Actor: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}


#Preview{
    Actor()
}

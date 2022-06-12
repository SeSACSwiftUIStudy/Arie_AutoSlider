//
//  ContentView.swift
//  AutoSlider
//
//  Created by Ahyeonway on 2022/06/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            // 부모를 기반으로 하는 뷰를 만들기
            GeometryReader { geometry in
                ImageCarouselView(numberOfImages: 3) {
                    Image("0")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    Image("1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    Image("2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }.frame(height: 300, alignment: .center)
            
        }.edgesIgnoringSafeArea(.all)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

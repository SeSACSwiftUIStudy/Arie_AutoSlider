//
//  ImageCarouselView.swift
//  AutoSlider
//
//  Created by Ahyeonway on 2022/06/05.
// https://levelup.gitconnected.com/swiftui-create-an-image-carousel-using-a-timer-ed546aacb389
// https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset

import SwiftUI
import Combine

struct ImageCarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content
    @State var slideGesture: CGSize = CGSize.zero
    @State var offset: CGSize = CGSize.zero
    @State private var currentIndex: Int = 0
    @State private var connectedTimer: Cancellable?
    @State private var timer = Timer.publish(every: 5, on: .main, in: .common)

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
        self.instantiateTimer()
    }
    
    func instantiateTimer() {
        self.timer = Timer.publish(every: 5, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }

    func cancelTimer() {
//        print("cancel timer")
        self.connectedTimer?.cancel()
        return
    }

    func restartTimer() {
//        print("restart timer")
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
    
    var body: some View {
        GeometryReader { geometry in
            // 1
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    self.content
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                // 오프셋을 얻기 위해 현재 인덱스에 부모 너비의 역수를 곱함.
                // CGFloat(self.currentIndex) * -geometry.size.width
                .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                // onReceive: 시간에 따라 Slider omit
                .onReceive(self.timer) { _ in
                    self.currentIndex = (self.currentIndex + 1) % (self.numberOfImages == 0 ? 1 : self.numberOfImages)
                }
                // .gesture: swipe 할 때 omit
                // .onChanged: 손가락을 움직일 때마다 호출됨
                // .onEnded: 손가락을 떼면 호출됨
                // 시작 위치, 예상 종료 위치를 확인할 수 있음
                .gesture(DragGesture().onChanged{ value in
                    self.cancelTimer()
                    self.slideGesture = value.translation
                    // slideGesture: 드래그 양을 저장하기 위한 속성
                }
                .onEnded{ value in
                    self.restartTimer()
                    // 어느 방향으로든 반 이상 이동했는지 확인, 그렇지 않은 경우 오프셋을 다시 0으로 설정
                    let halfWidth = geometry.size.width / 2
                    if self.slideGesture.width < -halfWidth {
                        print("왼쪽으로 슬라이드")
                        if self.currentIndex < self.numberOfImages - 1 {
                            withAnimation {
                                self.currentIndex += 1
                            }
                        } else if self.currentIndex == self.numberOfImages - 1 {
                            withAnimation {
                                self.currentIndex = 0
                            }
                        }
                    }
                    else if self.slideGesture.width > halfWidth {
                        print("오른쪽으로 슬라이드")
                        if self.currentIndex > 0 {
                            withAnimation {
                                self.currentIndex -= 1
                            }
                        } else if self.currentIndex == 0 {
                            withAnimation {
                                self.currentIndex = numberOfImages >= 0 ? numberOfImages - 1 : 0
                            }
                        }
                    } else {
                        print("넘 죠큼이얏!")
                        self.slideGesture = .zero
                    }
                })
            
                // 동그라미 친구들
                HStack(spacing: 3) {
                    ForEach(0..<self.numberOfImages, id: \.self) { index in
                        Circle()
                            .frame(width: index == self.currentIndex ? 10 : 8,
                                   height: index == self.currentIndex ? 10 : 8)
                            .foregroundColor(index == self.currentIndex ? Color.blue : .white)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
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
        }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}

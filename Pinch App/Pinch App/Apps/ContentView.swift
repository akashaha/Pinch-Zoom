//
//  ContentView.swift
//  Pinch App
//
//  Created by Arman Akash on 1/21/22.
//

import SwiftUI

struct ContentView: View {
    //MARK: -  PROPERTIES
    
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset : CGSize = .zero
    @State private var isDrwarOpen : Bool = false
    
    let pages : [Page] = pageData
    @State private var pageIndex : Int = 1
    
    //MARK: -  Functions
    func resetImageState(){
        withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String{
        return pages[pageIndex - 1].imageName
    }
    //MARK: -  BODY
    var body: some View {
        NavigationView{
            ZStack{
                
                Color.clear
                
                //MARK: - Page Image
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: - Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1{
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }
                        else{
                            withAnimation(.spring()){
                                resetImageState()
                            }
                        }
                    })
                
                //MARK: - Drag Gesture
                
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            })
                        
                    )
                
            } //: ZSTACK
            .navigationTitle("Zoom & Pinch")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            })
            //MARK: - Info panel
            
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            //MARK: - Control
            .overlay(
                Group{
                    HStack{
                        
                        //MARK: - Scale Down
                        
                        Button {
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1{
                                        resetImageState()
                                    }
                                }
                            }
                            
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        
                        //MARK: - Reset
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        //MARK: - Scale Up
                        Button {
                            withAnimation(.spring()){
                                if imageScale < 5{
                                    imageScale += 1
                                    
                                    if imageScale > 5{
                                    imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    } //: Control
                    //: HStack
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom , 30)
                ,alignment: .bottom
            )
            
            //MARK: - Megnification Gesture
            .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        withAnimation(.linear(duration: 1)){
                            if imageScale >= 1 && imageScale <= 5{
                                imageScale = value
                            }
                            else if imageScale>5 {
                                imageScale = 5
                            }
                        }
                    })
                    .onEnded({ _ in
                        if imageScale > 5 {
                            imageScale = 5
                        }
                        else if imageScale < 1{
                            resetImageState()                        }
                    })
            )
            
            //MARK: - Drawer
            .overlay(
                HStack(spacing: 12){
                    
                    //MARK: - Drawer Handeler
                    Image(systemName: isDrwarOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                isDrwarOpen.toggle()
                            }
                        })
                    
                    //MARK: - Thumbnanils
                    ForEach(pages){ item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrwarOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.6), value : isDrwarOpen)
                            .onTapGesture(perform: {
                                isAnimating = true
                                pageIndex = item.id
                            })
                    }
                    Spacer()
                    
                } //: Drawer
                //: HStack
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1: 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrwarOpen ? 20 : 215)
                ,alignment : .topTrailing
                
            )
            
        } //: NAVIGATIONVIEW
    }
}

//MARK: -  PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

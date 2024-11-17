//
//  GetLookAroundScene.swift
//  LookAroundSScene_V2
//
//  Created by Mak Yilam on 11/11/2024.
//

import SwiftUI
import MapKit
import Contacts

struct GetLookAroundScene: View {
    @State private var lookAroundScene: MKLookAroundScene?
    var mapItem: MKMapItem
    
    func getLookaroundScene(){
        lookAroundScene = nil  //clear the old lookAroundScene
        Task{
            //Get the scene for a given map item using MKLookAroundSceneRequest
            let request = MKLookAroundSceneRequest(coordinate: mapItem.placemark.coordinate)
            lookAroundScene = try? await request.scene  //why we use try? Ans: Use await when calling an asynchronous method which may take a longer time; also, write try before calling a throwing function.
            
        }
    }
    var body: some View {
        ZStack{
            if lookAroundScene == nil{
                ContentUnavailableView("No Look Around Scene Available", systemImage: "eye.slash")
            }else{
                LookAroundPreview(scene: $lookAroundScene)
                    .overlay(alignment: .bottomTrailing){
                        HStack{
                            Text("\(mapItem.name ?? "")")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(10)
                    }
            }
        }
        .onAppear{
            getLookaroundScene()
        }
        .onChange(of: mapItem){
            getLookaroundScene()
        }
    }
}

//#Preview {
//    GetLookAroundScene(mapItem: )
//}

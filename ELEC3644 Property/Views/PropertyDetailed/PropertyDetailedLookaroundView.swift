//
//  PropertyDetailedLookaroundView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 25/10/2024.
//
import CoreMotion
import SceneKit
import SwiftUI

struct PropertyDetailLookaroundView: View {
    @State private var property: Property
    @State private var scene: SCNScene = SCNScene()
    @State private var cameraNode: SCNNode = SCNNode()
    @State private var sphereNode: SCNNode
    @State private var selectedScene: Int = 0
    @State var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    @State var isLoading = true
    let sphereGeometry = SCNSphere(radius: 10)

    init(property: Property) {
        self.property = property
        self.sphereNode = SCNNode()
        imageLoader = ImageLoader(urlString: property.vrImageUrls[0].url)
    }

    var body: some View {
        ZStack {
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                options: []
            )
            .gesture(
                DragGesture(minimumDistance: 0).onChanged { value in
                    let translation = value.translation
                    let rotationRate: CGFloat = 0.00015
                    let rotation = SCNVector3(
                        x: Float(translation.height * rotationRate),
                        y: Float(translation.width * rotationRate),
                        z: 0
                    )
                    cameraNode.eulerAngles.x += rotation.x
                    cameraNode.eulerAngles.y += rotation.y
                }
            )
            .gesture(
                MagnificationGesture().onChanged { value in
                    let scaleRate: CGFloat = 1
                    let scale = value * scaleRate
                    let fov = cameraNode.camera!.fieldOfView / scale
                    if fov < 25 {
                        cameraNode.camera?.fieldOfView = 25
                    } else if fov > 90 {
                        cameraNode.camera?.fieldOfView = 90
                    } else {
                        cameraNode.camera?.fieldOfView = fov
                    }
                })
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.neutral100)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(.black.opacity(0.5))
            }
            VStack {
                Spacer()
                Picker("Select a VR View", selection: $selectedScene) {
                    ForEach(property.vrImageUrls.indices, id: \.self) { index in
                        Text(property.vrImageUrls[index].name).tag(index)
                    }
                }
                .onChange(of: selectedScene) {
                    isLoading = true
                    imageLoader = ImageLoader(urlString: property.vrImageUrls[$0].url)
                }
                .pickerStyle(WheelPickerStyle())
                .background(.white)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.15)
                .cornerRadius(12)
            }
        }
        .onReceive(imageLoader.dataPublisher) { data in
            self.image = UIImage(data: data) ?? UIImage()
            isLoading = false
        }
        .onChange(of: image) {
            sphereGeometry.firstMaterial?.diffuse.contents = self.image
            sphereGeometry.firstMaterial?.isDoubleSided = true
            sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(x: 0, y: 0, z: 0)
            scene.rootNode.addChildNode(sphereNode)
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
            scene.rootNode.addChildNode(cameraNode)
        }
        .onAppear(perform: setupScene)
        .backButton()
        .ignoresSafeArea()
    }

    private func setupScene() {

    }

    private func updateSphereRotation(with attitude: CMAttitude) {
        let rotationRate = -1.0
        let rotation = SCNVector3(
            x: Float(attitude.pitch * -rotationRate),
            y: Float(attitude.roll * rotationRate),
            z: Float(attitude.yaw * rotationRate)
        )
        cameraNode.eulerAngles = rotation
    }
}

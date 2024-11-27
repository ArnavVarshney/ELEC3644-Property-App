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
    @State private var scene: SCNScene?
    @State private var cameraNode: SCNNode?
    @State private var sphereNode: SCNNode
    init() {
        let sphereGeometry = SCNSphere(radius: 10)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "PropertyLookaround")
        sphereGeometry.firstMaterial?.isDoubleSided = true
        sphereNode = SCNNode(geometry: sphereGeometry)
    }

    var body: some View {
        GeometryReader { _ in
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                options: [.allowsCameraControl]
            )
        }
        .onAppear(perform: setupScene)
        .ignoresSafeArea()
        .backButton()
    }

    private func setupScene() {
        scene = SCNScene()
        sphereNode.position = SCNVector3(x: 0, y: 0, z: -10)
        sphereNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi / 2)
        scene?.rootNode.addChildNode(sphereNode)
        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene?.rootNode.addChildNode(cameraNode!)
    }

    private func updateSphereRotation(with attitude: CMAttitude) {
        let rotationRate = -1.0
        let rotation = SCNVector3(
            x: Float(attitude.pitch * -rotationRate),
            y: Float(attitude.roll * rotationRate),
            z: Float(attitude.yaw * rotationRate)
        )
        cameraNode?.eulerAngles = rotation
    }
}


#Preview {
    PropertyDetailLookaroundView()
}

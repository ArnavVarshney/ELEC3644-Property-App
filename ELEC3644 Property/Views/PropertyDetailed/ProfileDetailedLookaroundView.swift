//
//  ProfileDetailedLookaroundView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 25/10/2024.
//

import CoreMotion
import SceneKit
import SwiftUI

struct ProfileDetailedLookaroundView: View {
    @State private var scene: SCNScene?
    @State private var cameraNode: SCNNode?
    @StateObject private var motionManager = MotionManager()

    var body: some View {
        GeometryReader { geometry in
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                options: [.allowsCameraControl]
            )
        }
        .onAppear(perform: setupScene)
        .onReceive(motionManager.$attitude) { attitude in
            updateCameraRotation(with: attitude)
        }
        .ignoresSafeArea()
    }

    private func setupScene() {
        scene = SCNScene()

        let sphereGeometry = SCNSphere(radius: 10)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "PropertyLookaround")
        sphereGeometry.firstMaterial?.isDoubleSided = true

        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(x: 0, y: 0, z: -10)
        scene?.rootNode.addChildNode(sphereNode)

        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene?.rootNode.addChildNode(cameraNode!)

        motionManager.startUpdates()
    }

    private func updateCameraRotation(with attitude: CMAttitude) {
        let rotationRate = 1.0
        cameraNode?.eulerAngles = SCNVector3(
            x: Float(attitude.pitch * rotationRate),
            y: Float(attitude.yaw * rotationRate),
            z: Float(attitude.roll * rotationRate)
        )
    }
}

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var attitude = CMAttitude()

    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
    }

    func startUpdates() {
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion, error == nil else { return }
            self.attitude = motion.attitude
        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
#Preview {
    ProfileDetailedLookaroundView()
}

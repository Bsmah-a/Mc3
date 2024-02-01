//
//  ContentView.swift
//  Mc3
//
//  Created by Basmah Ali on 06/07/1445 AH.
//
import SwiftUI
import ARKit
import SceneKit

class ARViewCoordinator: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    var sceneView: ARSCNView?
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let sceneView = sceneView else { return }
        
        if gesture.state == .changed {
            let pinchScaleX = Float(gesture.scale) * sceneView.scene.rootNode.scale.x
            let pinchScaleY = Float(gesture.scale) * sceneView.scene.rootNode.scale.y
            let pinchScaleZ = Float(gesture.scale) * sceneView.scene.rootNode.scale.z
            sceneView.scene.rootNode.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
            gesture.scale = 1.0
        }
    }
}
struct ARViewContainer: UIViewRepresentable {
    @ObservedObject private var coordinator = ARViewCoordinator()

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        coordinator.sceneView = sceneView

        let scene = SCNScene()
//      let camera= SCNCamera()
        // Load the model
        if let robotScene = SCNScene(named: "robot_walk_idle.usdz") {
            for child in robotScene.rootNode.childNodes {
                scene.rootNode.addChildNode(child)
            }
        }

        sceneView.scene = scene

        // Add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 1000
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        sceneView.autoenablesDefaultLighting = true
        
        
        
        
        // Adjust the scale of the Model on camera
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.camera?.usesOrthographicProjection = true
//        cameraNode.position = SCNVector3(0, 5, 10)
//        //cameraNode.lookAt(SCNVector3(0, 5, 0))
//        sceneView.scene.rootNode.addChildNode(cameraNode)
        
        
//         Adjust the scale of the root node to change the size of the model
        scene.rootNode.scale = SCNVector3(0.8, 0.8, 0.1)

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        // Add pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action: #selector(ARViewCoordinator.handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}

struct ContentView: View {
    @State private var isModesSheetPresented = true
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
        
//            .sheet(isPresented: $isModesSheetPresented, content: {
//                  ModesSheet()
//                .presentationDetents([.height(110), .medium])})
                   }
}




 
#Preview {
    ContentView()
}

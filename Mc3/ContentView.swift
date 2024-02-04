


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
    weak var characterNode: SCNNode? // Reference to the character node
    var currentAngleY: Float = 0.0

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let characterNode = characterNode else { return }
        
        if gesture.state == .changed {
            let pinchScale = Float(gesture.scale)
            let scale = SCNVector3(x: characterNode.scale.x * pinchScale,
                                   y: characterNode.scale.y * pinchScale,
                                   z: characterNode.scale.z * pinchScale)
            
            characterNode.scale = scale
            gesture.scale = 1.0 // Reset the scale factor to avoid compounding the scale
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        let translation = gesture.translation(in: gesture.view!)
        
        var newAngleY = (Float)(translation.x) * (Float)(Double.pi) / 180.0
        newAngleY += currentAngleY
        
        characterNode?.eulerAngles.y = newAngleY
        
        if gesture.state == .ended {
            currentAngleY = newAngleY
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject private var coordinator = ARViewCoordinator()
//    @State var selectedModel: Models = Models(model:"Normal.usdz",pic:"Study_Mood",
//                                              title: "Study Mood",
//                                              desc: "Pick your book and study with Ozzy")
    @Binding var selectedModel: Models

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        coordinator.sceneView = sceneView

        let scene = SCNScene()
        // Load the model and adjust its position and scale
        if let modelScene = SCNScene(named: selectedModel.model) {
            for child in modelScene.rootNode.childNodes {
                // Set the initial position of the character
                child.position = SCNVector3(0, -20, -30) // Adjust position here
                scene.rootNode.addChildNode(child)
                coordinator.characterNode = child // Store the reference to the character node
            }
        }
        
        // Set the initial scale of the root node to change the size of the model
        scene.rootNode.scale = SCNVector3(0.4, 0.4, 0.4)

        sceneView.scene = scene

        // Add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 1000
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        sceneView.autoenablesDefaultLighting = true

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Add pinch gesture recognizer for scaling the model with pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action: #selector(ARViewCoordinator.handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        // Add pan gesture recognizer for rotating the model
        let panGesture = UIPanGestureRecognizer(target: coordinator, action: #selector(ARViewCoordinator.handlePan(_:)))
        panGesture.delegate = coordinator
        sceneView.addGestureRecognizer(panGesture)

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}

import SwiftUI

struct ContentView: View {
    @State private var isModesSheetPresented = false
    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height / 1.30
    @State var selectedModel: Models = Models(model:"Normal.usdz",pic:"Study_Mood",
                                              title: "Study Mood",
                                              desc: "Pick your book and study with Ozzy")
    var body: some View {
        ARViewContainer(selectedModel: $selectedModel)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ModesSheet(selectedModel: $selectedModel)
                    .offset(y: sheetOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newOffset = sheetOffset + value.translation.height
                                sheetOffset = max(0, min(newOffset, UIScreen.main.bounds.height / 1.30))
                            }
                            .onEnded { value in
                                withAnimation {
                                    if sheetOffset > UIScreen.main.bounds.height / 4 {
                                        isModesSheetPresented = true
                                    } else {
                                        sheetOffset = 250 // Keep the sheet open when swiped up
                                    }
                                }
                            }
                    )
            )
    }
}



#Preview {
    ContentView()
}

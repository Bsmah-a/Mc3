


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
    @Binding var selectedModel: Models
    @ObservedObject private var coordinator = ARViewCoordinator()

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        coordinator.sceneView = sceneView

        // Call loadModel method to load the initial model
        loadModel(sceneView: sceneView, modelName: selectedModel.model)

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Add pinch gesture recognizer for scaling the model with pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action: #selector(ARViewCoordinator.handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Call loadModel method to load the new model when selectedModel changes
        loadModel(sceneView: uiView, modelName: selectedModel.model)
    }
    
    private func loadModel(sceneView: ARSCNView, modelName: String) {
        let scene = SCNScene()
        
        if let modelScene = SCNScene(named: modelName) {
            for child in modelScene.rootNode.childNodes {
                scene.rootNode.addChildNode(child)
            }
        }

        scene.rootNode.scale = SCNVector3(0.4, 0.4, 0.4)

        sceneView.scene = scene

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 1000
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        sceneView.autoenablesDefaultLighting = true
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()  // ViewModel instance

    var body: some View {
        ARViewContainer(selectedModel: $viewModel.selectedModel)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ModesSheet(selectedModel: $viewModel.selectedModel)
                    .offset(y: viewModel.sheetOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newOffset = viewModel.sheetOffset + value.translation.height
                                viewModel.sheetOffset = max(0, min(newOffset, UIScreen.main.bounds.height / 1.30))
                            }
                            .onEnded { value in
                                withAnimation {
                                    if viewModel.sheetOffset > UIScreen.main.bounds.height / 4 {
                                        viewModel.isModesSheetPresented = true
                                    } else {
                                        viewModel.sheetOffset = 250 // Keep the sheet open when swiped up
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

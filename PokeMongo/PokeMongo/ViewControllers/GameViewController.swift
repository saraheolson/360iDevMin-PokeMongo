//
//  GameViewController.swift
//  PokeMongo
//
//  Created by Floater on 8/21/16.
//  Copyright © 2016 SarahEOlson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet var gameView: SKView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var arModeButton: UIButton!
    
    // True if we're viewing in AR Mode
    var isARMode = false
    
    // True if camera has been configured
    var isCameraConfigured = false
    
    // For real-time data capture from camera
    private let avCaptureSession: AVCaptureSession = AVCaptureSession()
    
    // The camera preview layer
    lazy private var previewLayer: AVCaptureVideoPreviewLayer = { [unowned self] in
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        return previewLayer!
        }()
    
    // Defined error
    private enum AVFoundationError: Error {
        case ConfigurationFailed
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                sceneNode.backgroundColor = UIColor.clear
                
                sceneNode.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                
                // Present the scene
                if let view = self.gameView {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    
                    view.allowsTransparency = true
                    view.backgroundColor = UIColor.clear
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    @IBAction func tappedARModeButton(_ sender: AnyObject) {
        
        isARMode = !isARMode
        
        if isARMode {
            
            // Ask for permission to use the camera
            askForCameraPermissions()
            
            arModeButton.setTitle("Image Mode", for: .normal)
            
        } else {
            
            arModeButton.setTitle("AR Mode", for: .normal)
            
            // Stop the camera session
            if avCaptureSession.isRunning == true {
                avCaptureSession.stopRunning()
            }
        }
        
        // Hide/display background and camera view
        self.backgroundView.isHidden = isARMode
        self.cameraView.isHidden = !isARMode
    }

    
    // MARK: - Camera permissions
    
    func askForCameraPermissions() {
        
        // We need to ask the user for permission to use the camera.
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            print("Authorized")
            self.displayCameraView()
            break
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Ask for permission")
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                
                if granted {
                    print("Show camera view")
                    self.displayCameraView()
                } else {
                    print("Denied")
                }
            }
        case .restricted:
            // We don't have access to the camera. Nothing we can do here.
            print("No camera access")
        }
    }
    
    // MARK: Scanning
    func displayCameraView() {
        
        // Return if we're not authorized
        guard AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized else {
            return
        }
        
        // Configure camera if not done already
        if !isCameraConfigured {
            configureCameraView()
        }
        
        // Start capturing data
        if avCaptureSession.isRunning == false {
            avCaptureSession.startRunning()
        }
    }
    
    func configureCameraView() {
        
        // Configure AV Capture Session
        do {
            let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            let videoInput: AVCaptureDeviceInput
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if avCaptureSession.canAddInput(videoInput) {
                avCaptureSession.addInput(videoInput)
            } else {
                throw AVFoundationError.ConfigurationFailed
            }
            
        } catch {
            debugPrint("Something went wrong")
            debugPrint(error)
            return
        }
        
        // Set up our layer
        previewLayer.frame = cameraView.bounds
        if let videoPreviewView = cameraView {
            videoPreviewView.layer.addSublayer(previewLayer)
        }
        
        // Camera has been configured
        isCameraConfigured = true
    }
}

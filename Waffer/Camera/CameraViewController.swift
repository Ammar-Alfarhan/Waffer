//
//  CameraViewController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/23/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.

import UIKit
import AVFoundation

var postedImage = UIImage()
class CameraViewController : UIViewController, AVCapturePhotoCaptureDelegate, PreviewPhotoContainerViewDelegate {
    
    func didTapUseButton() {
        let adPostingController = AdPostingViewController()
        let adsController = UINavigationController(rootViewController: adPostingController)
        present(adsController, animated: true, completion: nil)

    }
    
    
    var previewPhotoContainerView: PreviewPhotoContainerView?
    
    func didTapUse(_ image: UIImage) {
        let adPostingController = AdPostingViewController()
        adPostingController.image = image
        
        present(adPostingController, animated: true, completion: nil)
    }
    

    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        let customTabBar = CustomTabBarController()
        present(customTabBar, animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        setupCaptureSession()
        setupHUD()
    }
    

    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -25, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 50, height: 50)
    }
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()

        
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
        
        #endif
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!) //AVCapturePhoto fileDataRepresentation

        
        guard let previewImage = UIImage(data: imageData!) else { return }

        let containerView = PreviewPhotoContainerView()
        containerView.delegate = self
        containerView.previewImageView.image = previewImage
        
        postedImage = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

    }
    var image: UIImage?

    
    let output = AVCapturePhotoOutput()
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
}



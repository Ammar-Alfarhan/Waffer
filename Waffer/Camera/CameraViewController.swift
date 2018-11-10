//
//  CameraViewController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/23/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.

import UIKit
import AVFoundation

var postedImage = UIImage()
class CameraViewController : UIViewController, AVCapturePhotoCaptureDelegate {
    var myViewController: AdPostingViewController?
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("Capturing photo...")
        
        let settings = AVCapturePhotoSettings()
        
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        postedImage = previewImage!
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let useButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("use", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(handlUse), for:.touchUpInside)
            return button
        }()
        
        view.addSubview(useButton)
        useButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 50, height: 50)
        
        
        
        
        //        let previewImageView = UIImageView(image: previewImage)
        //        view.addSubview(previewImageView)
        //        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        //        print("Finish processing photo sample buffer...")
        
    }
    
    
    @objc func handlUse() {
        print("Handing use ...")
        
        let AdPostingController = AdPostingViewController()
        let adsController = UINavigationController(rootViewController: AdPostingController)
        present(adsController, animated: true, completion: nil)
        
        // myViewController?.navigationController?.pushViewController(AdPostingViewController(), animated: true)
        
        //let adPost = AdPostingViewController()
        //performSegue(withIdentifier: "adPost", sender: nil)
        //presentViewController(adPost, animated: true, completion: nil)
        //navigationController?.pushViewController(adPost, animated: true, completion: nil)
    }
    
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


//var picture = UIImage()
//class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    var imgPhoto: UIImageView!
//
//    let itemImageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "default-user")
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(itemImageView)
//        setupPicker()
//        setupItemImageView()
//
//    }
//
//
//
//   func setupPicker()
//   {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing=true
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//
//            imagePicker.sourceType = .camera
//
//            if (UIImagePickerController.isCameraDeviceAvailable(.rear)){
//                imagePicker.cameraDevice = .rear
//            }
//            else {
//
//                imagePicker.cameraDevice = .front
//            }
//        }
//        else{
//            imagePicker.sourceType = .photoLibrary
//        }
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // Local variable inserted by Swift 4.2 migrator.
//        //let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info[.originalImage] as? UIImage {
//            selectedImageFromPicker = editedImage
//        }
//
//
//        if let selectedImage = selectedImageFromPicker {
//            itemImageView.image = selectedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Canceled Picker")
//        dismiss(animated: true, completion: nil)
//        setupPicker()
//
//    }
//
//    func setupItemImageView()
//    {
//        //need x, y, width, height constraints
//        itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        itemImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        itemImageView.widthAnchor.constraint(equalToConstant: 500).isActive = true
//        itemImageView.heightAnchor.constraint(equalToConstant: 500).isActive = true
//    }
//
//
//}

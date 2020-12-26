//
//  ImageRendererVM.swift
//  Scanner
//
//  Created by Vibhor Mehrotra on 24/12/20.
//

import UIKit
import AVFoundation

protocol ImageRendererDelegate: class{
    func setupLivePreview(with captureSession: AVCaptureSession)
}

protocol ImageRendererVMProtocol{
    func cameraSetup()
    func didTakePhoto()
    func stopCaptureSession()
}

class ImageRendererVM: NSObject, ImageRendererVMProtocol{
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private let imageScanner: ImageScannerProtocol!
    
    weak var delegate: ImageRendererDelegate?
    let completion: (Result<[String], ScannerError>) -> Void
    
    init(delegate: ImageRendererDelegate, imageScanner: ImageScannerProtocol, callback: @escaping (Result<[String], ScannerError>) -> Void){
        self.delegate = delegate
        self.completion = callback
        self.imageScanner = imageScanner
    }
    
    //MARK: ImageRendererVMProtocol Protocol methods
    func cameraSetup(){
        checkPermissions()
        setupCameraLiveView()
    }
    
    func didTakePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func stopCaptureSession(){
        self.captureSession.stopRunning()
    }
    
    //MARK: Private methods
    private func checkPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
          AVCaptureDevice.requestAccess(for: .video) { [self] granted in
            if !granted {
              completion(.failure(.cameraInaccessable))
            }
          }
        case .denied, .restricted:
          completion(.failure(.cameraInaccessable))
        default:
          return
        }
      }
    
    private func setupCameraLiveView() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            completion(.failure(.cameraInaccessable))
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            completion(.failure(.cameraInitiationError(message: error.localizedDescription)))
        }
    }
    
    private func setupLivePreview() {
        delegate?.setupLivePreview(with: captureSession)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.captureSession.startRunning()
        }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate methods
extension ImageRendererVM: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let err = error{
            DispatchQueue.main.async {
                self.completion(.failure(.errorInTextDetection(message: err.localizedDescription)))
            }
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            DispatchQueue.main.async {
                self.completion(.failure(.invalidImage))
            }
            return
        }
        
        if let image = UIImage(data: imageData){
            imageScanner.readText(in: image) { [weak self](result) in
                self?.completion(result)
            }
        }
    }
}

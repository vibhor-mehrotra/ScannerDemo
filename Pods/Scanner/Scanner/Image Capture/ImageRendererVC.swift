//
//  ImageRendererVC.swift
//  Scanner
//
//  Created by Vibhor Mehrotra on 23/12/20.
//

import UIKit
import AVFoundation

final class ImageRendererVC: UIViewController {
    //MARK: - Internal properties
    var viewModel: ImageRendererVMProtocol!
    
    //MARK: - Private properties
    @IBOutlet weak private var previewView: UIView!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.cameraSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopCaptureSession()
    }
    
    //MARK: - IBOutlet
    @IBAction private func didTakePhoto(_ sender: Any) {
        viewModel.didTakePhoto()
    }
}

//MARK: - ImageRendererDelegate Implementation
extension ImageRendererVC: ImageRendererDelegate{
    func setupLivePreview(with captureSession: AVCaptureSession) {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        self.videoPreviewLayer.frame = self.previewView.bounds
    }
}

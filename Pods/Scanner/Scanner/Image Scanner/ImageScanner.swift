//
//  UsertInputReceiver.swift
//  Scanner
//
//  Created by Vibhor Mehrotra on 21/12/20.
//

import UIKit
import Vision

/*
 The class internal function takes in an image and scans it for all the texts with confidence greater than or equal to 0.6 and returns an array of String as an output
 */
protocol ImageScannerProtocol{
    func readText(in image: UIImage, completion: @escaping (Result<[String], ScannerError>) -> Void)
}

final class ImageScanner: ImageScannerProtocol{
    func readText(in image: UIImage, completion: @escaping (Result<[String], ScannerError>) -> Void){
        detectText(in: image) { (result) in
            completion(result)
        }
    }
    
    private func detectText(in image: UIImage, completion: @escaping (Result<[String], ScannerError>) -> Void) {
        guard let image = image.cgImage else {
            completion(.failure(.invalidImage))
            return
        }
                
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(.failure(.errorInTextDetection(message: error.localizedDescription)))
            } else {
                self.handleDetectionResults(results: request.results, completion: completion)
            }
        }
        
        request.recognitionLanguages = ["en_US"]//Just for the purpose of this project..
        request.recognitionLevel = .accurate
        
        performDetection(request: request, image: image, completion: completion)
    }
    
    private func performDetection(request: VNRecognizeTextRequest, image: CGImage, completion: @escaping (Result<[String], ScannerError>) -> Void) {
      let requests = [request]
      
      let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
      
      DispatchQueue.global(qos: .userInitiated).async {
          do {
              try handler.perform(requests)
          } catch let error {
            completion(.failure(.errorInTextDetection(message: error.localizedDescription)))
          }
      }
    }
    
    private func handleDetectionResults(results: [Any]?, completion: @escaping (Result<[String], ScannerError>) -> Void) {
        guard let results = results, results.count > 0 else {
            completion(.failure(.noTextFound))
            return
        }
        var scannedTexts = [String]()
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                for text in observation.topCandidates(1) {
                    if text.confidence >= 0.6{
                        scannedTexts.append(text.string)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            scannedTexts.count > 0 ? completion(.success(scannedTexts)) : completion(.failure(.noTextFound))
        }
        
    }

}

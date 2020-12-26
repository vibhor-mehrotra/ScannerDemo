//
//  Helper.swift
//  Scanner
//
//  Created by Vibhor Mehrotra on 23/12/20.
//

import Foundation

//MARK: - Custom ScannerError
enum ScannerError: Error{
    case cameraInaccessable
    case cameraInitiationError(message: String)
    case invalidImage
    case errorInTextDetection(message: String)
    case noTextFound
}

extension ScannerError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .cameraInaccessable:
            return "Unable to access back camera. Please provide camera access to the app from settings and try again."
        case let .cameraInitiationError(message):
            return "Unable to initialize back camera: \(message)"
        case .invalidImage:
            return "Image is invalid. Please try again."
        case let .errorInTextDetection(message):
            return "Error in detecting text: \(message)"
        case .noTextFound:
            return "Text not found in Image."
        }
    }
}

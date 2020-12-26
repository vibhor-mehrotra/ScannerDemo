//
//  ScannerDemoVC.swift
//  ScannerDemo
//
//  Created by Vibhor Mehrotra on 25/12/20.
//

import UIKit
import Scanner

class ScannerDemoVC: UIViewController {
    //MARK: - Private constants
    
    //Alert body
    private let errorAlertTitle = "Error"
    private let successAlertTitle = "Results"
    private let defaultErrorMessage = "Something went wrong"
    
    //Alert action titles
    private let tryAgain = "Try Again"
    private let ok = "OK"
    private let cancel = "Cancel"
    
    
    //MARK: - ViewController lifecycle methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showScanner()
    }
    
    //MARK: - Private Utility methods to display Scanner
    private func showScanner(){
        Scanner.present(on: self) { [weak self](output, error) in
            guard let `self` = self else{
                return
            }
            if let err = error {
                self.showAlertView(title: self.errorAlertTitle, message: err, firstBtnTitle: self.tryAgain, firstBtnAction: { (_) in
                    self.showScanner()
                }, secondBtnTitle: self.cancel)
                return
            }
            guard let scannedTexts = output else{
                self.showAlertView(title: self.errorAlertTitle, message: self.defaultErrorMessage, firstBtnTitle: self.ok)
                return
            }
            self.showAlertView(title: self.successAlertTitle, message: scannedTexts.joined(separator: "\n"), firstBtnTitle: self.ok)
        }
    }
}

//MARK: - Extension for showing alert views
extension ScannerDemoVC{
    func showAlertView(title: String, message: String, firstBtnTitle: String, firstBtnAction: @escaping (UIAlertAction) -> Void = { _ in}, secondBtnTitle: String? = nil, secondBtnAction: @escaping ((UIAlertAction) -> Void) = { _ in}, preferredStyle: UIAlertController.Style = .alert) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: firstBtnTitle, style: .default, handler: firstBtnAction))
        if let secBtnTitle = secondBtnTitle{
            alert.addAction(UIAlertAction(title: secBtnTitle, style: .default, handler: secondBtnAction))
        }
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

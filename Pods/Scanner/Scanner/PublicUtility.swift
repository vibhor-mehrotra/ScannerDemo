//
//  PublicUtility.swift
//  Scanner
//
//  Created by Vibhor Mehrotra on 23/12/20.
//

import UIKit

public final class Scanner{
    public class func present(on vc: UIViewController, completion: @escaping ([String]?, String?) -> Void){
        let imageRendererVC = ImageRendererVC(nibName: "ImageRendererVC", bundle: Bundle(for: Scanner.self))
        imageRendererVC.viewModel = ImageRendererVM(delegate: imageRendererVC, imageScanner: ImageScanner(), callback: {(result) in
            switch result {
            case .success(let output):
                DispatchQueue.main.async {
                    completion(output,  nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                imageRendererVC.view.removeFromSuperview()
            }
        })
        vc.view.addSubview(imageRendererVC.view)
    }
}

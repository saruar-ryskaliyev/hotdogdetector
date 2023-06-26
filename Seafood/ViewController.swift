//
//  ViewController.swift
//  SeaFood
//
//  Created by Saruar on 26.06.2023.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let CIImage = CIImage(image: userPickedImage) else{
                fatalError("NOOOOOO")
            }
            detect(image: CIImage)
        }
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)


    }
    
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("BRUIUUUH")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Could not get results")
            }
            
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
            print(results)
        }
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}


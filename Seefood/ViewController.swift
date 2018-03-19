//
//  ViewController.swift
//  Seefood
//
//  Created by Francois Schaus on 10/14/17.
//  Copyright © 2017 Francois Schaus. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    let imagePicker = UIImagePickerController()
    var answer : String = ""
    var effect: UIVisualEffect!
    @IBOutlet var AnswerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet var startLabel: UIView!
    @IBOutlet weak var shadedWhiteBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "jared-silicon-valley-jacket")
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        self.view.addSubview(startLabel)
//        self.present(imagePicker, animated: true, completion: nil) // Add back to get straight to the camera app
        AnswerView.layer.cornerRadius = 5
        startLabel.layer.cornerRadius = 5
        startLabel.center = self.view.center
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
        fatalError("Loading CoreML model failed")
        }
        let request = VNCoreMLRequest(model: model) {(request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Could not launch request")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.answerLabel.text = "Hotdog!"
                    self.animateIn()
                    self.startLabel.removeFromSuperview()
                } else {
                    let resultString = firstResult.identifier
                    let delimiter = ","
                    let shortString = resultString.components(separatedBy: delimiter).first
                    self.answerLabel.text = "Not Hotdog! It's a \(shortString!)!"
                    self.startLabel.removeFromSuperview()
                    self.animateIn()
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func startLabelpush(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func animateIn() {
        shadedWhiteBackground.isHidden = true
        self.view.addSubview(AnswerView)
        AnswerView.center = self.view.center
        AnswerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        AnswerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.AnswerView.alpha = 1
            self.AnswerView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.AnswerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.AnswerView.alpha = 0
            
        }) {(success:Bool) in self.AnswerView.removeFromSuperview()
        }
    }
    
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
   animateOut()
    self.present(imagePicker, animated: true, completion: nil)
    }
    

}


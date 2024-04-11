//
//  DetectionFactory.swift
//  HotDog
//
//  Created by Daniel Leivers on 09/04/2024.
//

import CoreML
import Vision
import UIKit

class DetectionFactory {
    static func createClassificationRequest(completion: @escaping ([VNRecognizedObjectObservation])->()) -> VNCoreMLRequest {
        do {

            let config = MLModelConfiguration()
            config.computeUnits = .all

//            let model = try VNCoreMLModel(for: HotdogDetector(configuration: config).model)
            let model = try VNCoreMLModel(for: Exp8(configuration: config).model)
            model.inputImageFeatureName = "image"

            let request = VNCoreMLRequest(model: model) { response, _ in
                if let observations = response.results as? [VNRecognizedObjectObservation] {
                    print("Object results: \(observations)")
                    completion(observations)
                }
                else {
                    print("It's something else!!")
                    completion([])
                }
            }

            //        request.imageCropAndScaleOption = .centerCrop
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }

    static func classifyImage(_ image: UIImage, completion: @escaping ([VNRecognizedObjectObservation])->()) {
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
            return
        }
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }

        let request = createClassificationRequest(completion: completion)
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
                completion([])
            }
        }
    }
}

//
//  TambahProdukScanViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 25/07/21.
//

import UIKit
import Vision
import AVFoundation

class TambahProdukScanViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var flashLightButton: UIButton!
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sequenceHandler = VNSequenceRequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tambah Produk"
        self.addCameraInput()
        self.configurePreviewLayer()
        self.addVideoOutput()
    }
    
    @IBAction func buttonFlash(_ sender: Any) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "TambahProdukForm", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "TambahProdukForm") as! TambahProdukFormViewController
//
//        self.present(vc, animated: true, completion: nil)
    }
    
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        cameraPreviewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
        cameraPreviewLayer.bounds = cameraView.frame
        cameraView.layer.addSublayer(cameraPreviewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        if let barcode = self.extractBarcode(fromFrame: frame) {
            //MARK: - TODO Gunakan data barcode untuk disimpan
//            showAlert(withTitle: "Barcode Founde", message: barcode)
//
            DispatchQueue.main.async {
                let storyboard: UIStoryboard = UIStoryboard(name: "TambahProdukForm", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "TambahProdukForm") as! TambahProdukFormViewController
                        
                vc.scanningBarcode = barcode
                self.present(vc, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
           
        }
    }
    
    private func extractBarcode(fromFrame frame: CVImageBuffer) -> String? {
        let barcodeRequest = VNDetectBarcodesRequest()
        barcodeRequest.symbologies = [.EAN13]
        try? self.sequenceHandler.perform([barcodeRequest], on: frame)
        guard let results = barcodeRequest.results as? [VNBarcodeObservation], let firstBarcode = results.first?.payloadStringValue else {
            return nil
        }
        return firstBarcode
    }
    
    private func addCameraInput() {
        guard let device = AVCaptureDevice.default(for: .video) else { return print("No camera detected") }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func addVideoOutput() {
        self.videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        self.captureSession.addOutput(self.videoOutput)
    }
    
    @IBAction func flashlightPressed(_ sender: Any) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)!
        
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                if torchOn == false {
                    flashLightButton.setImage(UIImage(named: "flashlight-off.png"), for: .normal)
                } else {
                    flashLightButton.setImage(UIImage(named: "flashlight-on.png"), for: .normal)
                }
                
                try device.setTorchModeOn(level: 1)
                device.torchMode = torchOn ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        } else {
        }
    }
}

extension TambahProdukScanViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
}

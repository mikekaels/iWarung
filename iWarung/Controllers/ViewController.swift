//
//  ViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 18/07/21.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var flashLightButton: UIButton!
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sequenceHandler = VNSequenceRequestHandler()
    
    @IBOutlet weak var keranjangPopUp: KeranjangPopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.addCameraInput()
        self.configurePreviewLayer()
        self.addVideoOutput()
        self.captureSession.startRunning()

        keranjangPopUp.cornerRadius()
        keranjangPopUp.addGradient()
    }
    
    @IBAction func flashlightPressed(_ sender: UIButton) {
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
    fileprivate func setupNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.white
        let iWarungLogoImageView = UIImageView(image: UIImage(named: "iwarung_logo"))
        iWarungLogoImageView.frame = CGRect(x: 0, y: 0, width: 132, height: 40)
        iWarungLogoImageView.contentMode = .scaleAspectFit
        
        let width = view.frame.width
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        titleView.addSubview(iWarungLogoImageView)
        
        navigationItem.titleView = titleView
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
        // TODO Gunakan data barcode untuk mencari barang yang sudah terdaftar
        if let barcode = self.extractBarcode(fromFrame: frame) {
            showModal()
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
    
    @objc func showModal() {
        DispatchQueue.main.async {
            let slideVC = DetectedProductView()
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: { () in
                print("Modal opened")
            })
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        print("This is the First View Controller")
    }
    
    @IBAction func openModal(_ sender: UIButton) {
        showModal()
    }
}

//MARK: - Remove Nav bar
extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isHiddenHairline = true
        super.viewWillAppear(animated)
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

//MARK: - PresentationModal
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !Core.shared.isNewUser() {
            // show onboarding
            let controller = storyboard?.instantiateViewController(identifier: "Onboarding") as! OnboardingViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
    }
}

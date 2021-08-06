//
//  TambahProdukScanViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 25/07/21.
//

import UIKit
import Vision
import AVFoundation

class TambahProdukScanViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var flashLightButton: UIButton!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var flashlightView: UIView!
    @IBOutlet weak var scanButton       : UIButton!
    @IBOutlet weak var pickerView       : UIPickerView!
    
    private let captureSession                          = AVCaptureSession()
    private let videoOutput                             = AVCaptureVideoDataOutput()
    private let sequenceHandler                         = VNSequenceRequestHandler()
    private var isBarcode                               = true
    
    var pickerData          : [String]      = K.pickerData
    var rotationAngle       : CGFloat!
    var pickerWidth         : CGFloat       = 100
    var pickerHeight        : CGFloat       = 100
    var isPressed           : Bool          = false
    var torchOn             : Bool          = false
    var timer               : Timer?
    
    let productService      : Persisten = Persisten()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tambah Produk"
        backButtonView.cornerRadius(width: 10, height: 10)
        flashlightView.cornerRadius(width: 10, height: 10)
        cameraView.backgroundColor = UIColor(rgb: K.blueColor1)
        
        //MARK: - Picker
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle )
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: -100)
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //MARK: - Camera
        self.addCameraInput()
        self.addVideoOutput()
        self.configurePreviewLayer()
        self.captureSession.startRunning()
        
        if let layers = cameraView.layer.sublayers {
            for layer in layers {
                if layer.name == "camera-active" {
                    layer.removeFromSuperlayer()
                    self.captureSession.stopRunning()
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonFlash(_ sender: Any) {
        if torchOn == false {
            self.torchOn = true
            flashLightButton.setImage(UIImage(named: "flashlight-on.png"), for: .normal)
            do {
                guard let device = AVCaptureDevice.default(for: .video) else { return print("No camera detected") }
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1)
                device.torchMode = AVCaptureDevice.TorchMode.on
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        } else {
            self.torchOn = false
            flashLightButton.setImage(UIImage(named: "flashlight-off.png"), for: .normal)
            do {
                guard let device = AVCaptureDevice.default(for: .video) else { return print("No camera detected") }
                try device.lockForConfiguration()
                device.torchMode = AVCaptureDevice.TorchMode.off
                device.unlockForConfiguration()
            } catch  {
                print(error)
            }
            
        }
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

//MARK: - Check Inactivity
extension TambahProdukScanViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        resetTimer()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(toggleControls2))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(toggleControls))
        
        self.scanButton.addGestureRecognizer(longTapGesture)
        self.scanButton.addGestureRecognizer(longPressRecognizer)
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc func hideControls() {
        if let layers = cameraView.layer.sublayers {
            for layer in layers {
                if layer.name == "camera-active" {
                    layer.removeFromSuperlayer()
                    self.captureSession.stopRunning()
                }
            }
        }
    }
    
    @objc func toggleControls() {
        resetTimer()
        if !captureSession.isRunning {configurePreviewLayer()}
        self.captureSession.startRunning()
    }
    
    @objc func toggleControls2(sender:UILongPressGestureRecognizer) {
        resetTimer()
        if !captureSession.isRunning {configurePreviewLayer()}
        self.captureSession.startRunning()
        longPressed(sender: sender)
    }
}

//MARK: - Remove Nav bar
extension TambahProdukScanViewController {
    override func viewWillAppear(_ animated: Bool) {
        if !Core.shared.isNewUser() {
            // show onboarding
            let controller = storyboard?.instantiateViewController(identifier: "Onboarding") as! OnboardingViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
        
        self.navigationController?.isHiddenHairline = true
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if let layers = cameraView.layer.sublayers {
            for layer in layers {
                if layer.name == "camera-active" {
                    layer.removeFromSuperlayer()
                    self.captureSession.stopRunning()
                }
            }
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
}

//MARK: - UIPicker Non Barcode or Barcode
extension TambahProdukScanViewController: UIPickerViewDelegate , UIPickerViewDataSource {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = pickerData[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight )
        view.backgroundColor = .clear
        
        // Label inside uiPicker Label
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight)
        label.textAlignment = .center
        label.text = pickerData[row]
        view.addSubview(label)
        
        // view transform
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
        // selection area
        pickerView.subviews[1].backgroundColor = UIColor.white.withAlphaComponent(0)
        pickerView.tintColor = .red
        
        return view
    }
}

//MARK: - Scan Button
extension TambahProdukScanViewController {
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        print("Shoot..")
        if sender.state == .began {
            print("Start scanning...")
            scanButton.setImage(UIImage(named: "camera-button-pressed"), for: .normal)
            self.captureSession.startRunning()
            self.isPressed = true
            UIView.animate(withDuration: 0.3, animations: {self.scanButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)},completion: nil)
        } else if sender.state == .ended {
            print("Scan stopped...")
            scanButton.setImage(UIImage(named: "camera-button"), for: .normal)
            self.isPressed = false
            UIView.animate(withDuration: 0.2) {self.scanButton.transform = CGAffineTransform.identity}}
    }
}

//MARK: - CaptureSession
extension TambahProdukScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.name = "camera-active"
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        //        cameraPreviewLayer.frame = cameraView.frame
        cameraPreviewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(cameraPreviewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        if self.isPressed == true && self.extractBarcode(fromFrame: frame) != nil {
            if let barcode = self.extractBarcode(fromFrame: frame) {
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "TambahProdukForm", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "TambahProdukForm") as! TambahProdukFormViewController
                            
                    vc.scanningBarcode = barcode
                    self.present(vc, animated: true, completion: nil)
    //                self.navigationController?.popViewController(animated: true)
                }
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
    
    static func checkPermission() {
        let accessStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch accessStatus  {
        case .denied:
            print("Denied")
            break
        case .restricted:
            print("Restricted")
            break
        case .authorized:
            print("Authorized")
            break
        case .notDetermined:
            print("Not Determined")
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success {
                    print("Permission granted")
                } else {
                    print("Permission not granted ")
                }
            }
            break
        default:
            break
        }
    }
}

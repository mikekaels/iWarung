//
//  ViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 18/07/21.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
//    @IBOutlet weak var cameraView       : UIImageView!
    @IBOutlet weak var flashLightButton : UIButton!
    @IBOutlet weak var pickerView       : UIPickerView!
    @IBOutlet weak var scanButton       : UIButton!
    @IBOutlet weak var keranjangPopUp   : KeranjangPopUp!
    
    private let captureSession                          = AVCaptureSession()
    private let videoOutput                             = AVCaptureVideoDataOutput()
    private let sequenceHandler                         = VNSequenceRequestHandler()
    private var isBarcode                               = true
    var pickerData                      : [String]      = [String]()
    var rotationAngle                   : CGFloat!
    var pickerWidth                     : CGFloat       = 100
    var pickerHeight                    : CGFloat       = 100
    var isPressed                       : Bool          = false
    var torchOn                         : Bool          = false
    let device                                          = AVCaptureDevice.default(for: AVMediaType.video)!
    var timer                           : Timer?
    let scanView                        : UIView        = createRectView(x: 0, y: 0, width: 390, height: 543, color: UIColor(rgb: K.blueColor1), transparency: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.backgroundColor = UIColor(rgb: K.blueColor1)
        setupNavBar()
        self.addCameraInput()
        self.configurePreviewLayer()
        self.addVideoOutput()
//        self.captureSession.startRunning()
        toggleControls()

        keranjangPopUp.cornerRadius()
        keranjangPopUp.addGradient()
        
        pickerData = ["Barcode", "No-Barcode"]
        
        // picker rotation
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle )
        
        // picker frame
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: -100)
//        pickerView.center = self.view.
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.popUpDismissed),
            name: NSNotification.Name(K.NSpopUpDismissed),
            object: nil)
        
    }
    
    @objc func popUpDismissed(notification: NSNotification){
        self.toggleControls()
    }
    
    static func createRectView(x:Float, y:Float, width:Float, height:Float, color: UIColor, transparency: Float) -> UIView{
            
            let viewRectFrame = CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height))
            
            let retView = UIView(frame:viewRectFrame)
            
            retView.backgroundColor = color
            
            retView.alpha = CGFloat(transparency)
            
            return retView
        }
    
    @IBAction func flashlightPressed(_ sender: UIButton) {
        
        if torchOn == false {
            self.torchOn = true
            flashLightButton.setImage(UIImage(named: "flashlight-on.png"), for: .normal)
        } else {
            self.torchOn = false
            flashLightButton.setImage(UIImage(named: "flashlight-off.png"), for: .normal)
            
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
    
    @objc func showModalSelectProduct() {
        DispatchQueue.main.async {
            let slideVC = SelectProductView()
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: { () in
                print("Modal opened")
            })
        }
    }
    
    func showCameraInactivePopUp() {
        let popUp = CameraInactivePopUpViewController.create()
        let sbPopUp = SBCardPopupViewController(contentViewController: popUp)
        sbPopUp.show(onViewController: self)
        navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        print("This is the First View Controller")
    }
    
    @IBAction func openModal(_ sender: UIButton) {
        showModal()
    }
    
    
}

//MARK: - Check Inactivity
extension ViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        resetTimer()

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(toggleControls2))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(toggleControls))
        
//        self.scanButton.addGestureRecognizer(longPressRecognizer)
        self.view.addGestureRecognizer(tapGesture)
        self.scanButton.addGestureRecognizer(tapGesture)
        self.scanButton.addGestureRecognizer(longTapGesture)
        self.scanButton.addGestureRecognizer(longPressRecognizer)
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc func hideControls() {
        print("APP is Inactive")
        self.captureSession.stopRunning()
        scanView.removeFromSuperview()
        showCameraInactivePopUp()
    }
    
    @objc func toggleControls() {
        print("Touched")
        resetTimer()
        
        view.addSubview(scanView)
        scanView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanView.topAnchor.constraint(equalTo: view.topAnchor, constant: 98),
            scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -203),
            scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
        self.captureSession.startRunning()
    }
    
    @objc func toggleControls2(sender:UILongPressGestureRecognizer) {
        print("Touched")
        resetTimer()
        
        view.addSubview(scanView)
        scanView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanView.topAnchor.constraint(equalTo: view.topAnchor, constant: 98),
            scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -203),
            scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
        self.captureSession.startRunning()
        longPressed(sender: sender)
    }
}

//MARK: - Remove Nav bar
extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        if !Core.shared.isNewUser() {
            // show onboarding
            let controller = storyboard?.instantiateViewController(identifier: "Onboarding") as! OnboardingViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
        
        self.navigationController?.isHiddenHairline = true
//        self.segmentedControl.removeBorders()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.captureSession.stopRunning()
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
        
        
    }
}

//MARK: - UIPicker Non Barcode or Barcode
extension ViewController: UIPickerViewDelegate , UIPickerViewDataSource {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
    
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
extension ViewController {
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began {
            self.captureSession.startRunning()
            self.isPressed = true
            print("Start scanning...")
            UIView.animate(withDuration: 0.3,
                animations: {
                    self.scanButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    
                    if self.torchOn == true {
                        do {
                            try self.device.lockForConfiguration()
                            try self.device.setTorchModeOn(level: 1)
                            self.device.torchMode = AVCaptureDevice.TorchMode.on
                            self.device.unlockForConfiguration()
                        } catch {
                            print(error)
                        }
                    }
                    },completion: nil)
        } else if sender.state == .ended {
//            self.captureSession.stopRunning()
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 390, height: 640))
//            imageView.image = UIImage(named: "camera-inactive")
//            cameraView.addSubview(imageView)
            
            self.isPressed = false
            print("Stop scanning...")
            UIView.animate(withDuration: 0.2) {
                self.scanButton.transform = CGAffineTransform.identity
                
                // Flashlight
                if self.torchOn == true {
                    do {
                        try self.device.lockForConfiguration()
                        self.device.torchMode = AVCaptureDevice.TorchMode.off
                        self.device.unlockForConfiguration()
                    } catch  {
                        print(error)
                    }
                }
            }
        }
    }
}

//MARK: - CaptureSession
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
//        cameraPreviewLayer.frame = scanView.frame
        scanView.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        cameraPreviewLayer.frame = CGRect(x: 100, y: 100, width: scanView.layer.frame.width, height: scanView.layer.frame.height)
        cameraPreviewLayer.frame = scanView.layer.frame
        scanView.layer.addSublayer(cameraPreviewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        // TODO Gunakan data barcode untuk mencari barang yang sudah terdaftar
        if self.isPressed == true && self.extractBarcode(fromFrame: frame) != nil {
            if isBarcode {
                showModal()
            } else {
                showModalSelectProduct()
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

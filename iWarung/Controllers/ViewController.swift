//
//  ViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 18/07/21.
//

import UIKit
import Vision
import AVFoundation
import CoreData
import WatchConnectivity

class ViewController: UIViewController{
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var flashLightButton : UIButton!
    @IBOutlet weak var flashlightView: UIView!
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var inventoryButton: UIButton!
    @IBOutlet weak var pickerView       : UIPickerView!
    @IBOutlet weak var scanButton       : UIButton!
    @IBOutlet weak var keranjangPopUp   : KeranjangPopUp!
    @IBOutlet weak var cameraOverlay: UIImageView!
    @IBOutlet weak var keranjangPopUpView: UIView!
    
    private let captureSession                          = AVCaptureSession()
    private let videoOutput                             = AVCaptureVideoDataOutput()
    private let sequenceHandler                         = VNSequenceRequestHandler()
    private var isBarcode                               = true
    private let photoOutput                             = AVCapturePhotoOutput()
    
    lazy var textRecognizeRequest: VNRecognizeTextRequest = {
        let textDetectRequest = VNRecognizeTextRequest(completionHandler: self.recognizeTextHandler)
        textDetectRequest.recognitionLevel = .accurate
        return textDetectRequest
    }()
    
    var pickerData          : [String]      = K.pickerData
    var rotationAngle       : CGFloat!
    var pickerWidth         : CGFloat       = 100
    var pickerHeight        : CGFloat       = 100
    var isPressed           : Bool          = false
    var torchOn             : Bool          = false
    var timer               : Timer?
    
    var keranjang           = [ItemKeranjang]()
    let productService      : Persisten = Persisten()
    
    var session: WCSession?//2
    var connectivityHandler = WatchSessionManager.shared
    var lastNumber: Int = 0
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEW DID LOAD ---------------------")
        self.hideKeranjangPopUp()
        setupNavBar()
        cameraOverlay.isHidden = true
        cameraOverlay.alpha = 0
        
        flashLightButton.backgroundColor = .white
        flashLightButton.cornerRadius(width: 4, height: 4)
        inventoryView.cornerRadius(width: 10, height: 10)
        flashlightView.cornerRadius(width: 10, height: 10)
        cameraView.backgroundColor = UIColor(rgb: K.blueColor1)
        
        keranjangPopUp.cornerRadius()
        keranjangPopUp.addGradient()
        
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle )
        
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: -100)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.popUpDismissed),
            name: NSNotification.Name(K.NSpopUpDismissed),
            object: nil)
        
        //MARK: - CAMERA
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
        
        self.setupNotificationCenter()
        
        //MARK: - Ask for Permission [Notification]
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        connectivityHandler.iOSDelegate = self
    }
    
    func sendDataToIwatch() {
        let data = Persisten.shared.fetchProducts()
        var array = [[String: Any]]()
        for item in data {
            let dict = ["name": item.name!, "stock": item.stock, "expired": item.exp_date!] as [String : Any]
            array.append(dict)
        }
        print("ARRAY: ",array)
        do {
            try connectivityHandler.updateApplicationContext(applicationContext: ["data": array])
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let data = Persisten.shared.fetchProducts()
        var array = [[String: Any]]()
        
        for item in data {
            let dict = ["name": item.name!, "stock": item.stock, "expired": item.exp_date!] as [String : Any]
            array.append(dict)
        }
        print("ARRAY: ",array)
        do {
            try connectivityHandler.updateApplicationContext(applicationContext: ["row" : self.lastNumber as Int, "data": array])
        } catch {
            print("Error: \(error)")
        }
        
        lastNumber += 1
    }

    func setupNotificationCenter() {
        //MARK: - ADD OBSERVER NOTIFICATION CENTER
        NotificationCenter.default.addObserver(forName: K.detectedNotificationKey, object: nil, queue: nil, using: { [self] (notification) in
            guard let object = notification.object as? ItemKeranjang else {
                print("NOT OBJECT ----------------")
                return
            }
            if keranjang.isEmpty {
                self.keranjang.append(object)
            } else {
                var indexFound = -1
                for (index, item) in keranjang.enumerated() {
                    if item.id == object.id {
                        indexFound = index
                    }
                }
                
                if indexFound != -1 {
                    keranjang[indexFound].qty += object.qty
                } else {
                    self.keranjang.append(object)
                }
            }
            self.updateKeranjangPopUp()
        })
        
        NotificationCenter.default.addObserver(forName: K.clearKeranjangNotificationKey, object: nil, queue: nil, using: { [self] (notification) in
            self.keranjang.removeAll()
            self.updateKeranjangPopUp()
        })
    }
    
    func hideKeranjangPopUp() {
        keranjangPopUpView.isHidden = true
        
        self.keranjangPopUpView.frame = CGRect(x: K.xPosition, y: K.yPosition + 100, width: K.width, height: K.height)
    }
    
    func unhideKeranjangPopUp() {
        if keranjangPopUpView.isHidden == true {
            keranjangPopUpView.isHidden = false
            UIView.animateKeyframes(withDuration: 0.6, delay: 0.3, options: .beginFromCurrentState, animations: {
                self.keranjangPopUpView.frame = CGRect(x: K.xPosition, y: K.yPosition - 13, width: K.width, height: K.height)
            }, completion: nil)
            
            UIView.animateKeyframes(withDuration: 0.2, delay: 0.9, options: .beginFromCurrentState, animations: {
                self.keranjangPopUpView.frame = CGRect(x: K.xPosition, y: K.yPosition, width: K.width, height: K.height)
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toKeranjang" {
            let landingVC = segue.destination as! KeranjangViewController
            print("KERANJANG: ",keranjang)
            landingVC.delegate = self
            landingVC.keranjang = keranjang
        }
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
        sendDataToIwatch()
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
    
    @objc func showModalDetectedProduct(product: ProductItem) {
        DispatchQueue.main.async {
            let slideVC = DetectedProductView()
            slideVC.productItem = product
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: { () in
                self.isPressed = false
            })
        }
    }
    
    @objc func showModalSelectProduct() {
        DispatchQueue.main.async {
            let slideVC = SelectProductView()
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: { () in
            })
        }
    }
    
    func showCameraInactivePopUp() {
        let popUp = CameraInactivePopUpViewController.create()
        let sbPopUp = SBCardPopupViewController(contentViewController: popUp)
        sbPopUp.show(onViewController: self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        if !isBarcode {
            if !captureSession.isRunning {
                resetTimer()
                configurePreviewLayer()
                self.captureSession.startRunning()
            } else {
                cameraOverlay.isHidden = false
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.cameraOverlay.alpha = 1
                }, completion: { finished in
                    self.cameraOverlay.isHidden = true
                    self.cameraOverlay.alpha = 0
                })
                takePhoto()
            }
        }
    }
}

extension ViewController: KeranjangDelegate  {
    
    func didTapPlusOrMinusButton(indexPath: Int, totalProduct: Int) {
        keranjang[indexPath].qty = totalProduct
        updateKeranjangPopUp()
    }
    
    func deleteProduct(indexPath: Int) {
        keranjang.remove(at: indexPath)
        updateKeranjangPopUp()
        
    }
    
    func updateKeranjangPopUp() {
        self.keranjangPopUp.jumlahProdukLabel.text = "\(self.keranjang.count) Produk"
        self.keranjangPopUp.totalHargaLabel.text = String(K.totalPrice(keranjang: keranjang)).currencyFormatting()
        if self.keranjang.count != 0 {
            self.unhideKeranjangPopUp()
        } else {
            self.hideKeranjangPopUp()
        }
    }
}

//MARK: - Check Inactivity
extension ViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APPEAR ---------------------")
        updateKeranjangPopUp()
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
                    self.cameraOverlay.isHidden = true
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
extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR ---------------------")
        
        updateKeranjangPopUp()
        
        //        if !Core.shared.isNewUser() {
        //            // show onboarding
        //            let controller = storyboard?.instantiateViewController(identifier: "OnboardingViewController") as! OnboardingViewController
        //            controller.modalPresentationStyle = .fullScreen
        //            controller.modalTransitionStyle = .crossDissolve
        //            present(controller, animated: true, completion: nil)
        //        }
        
        self.navigationController?.isHiddenHairline = true
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("VIEW WILL DISSAPPEAR ---------------------")
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            isBarcode = true
        } else {
            isBarcode = false
        }
    }
}

//MARK: - Scan Button
extension ViewController {
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began {
            print("Start scanning...")
            scanButton.setImage(UIImage(named: "camera-button-pressed"), for: .normal)
            self.captureSession.startRunning()
            self.isPressed = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scanButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },completion: nil)
            
            cameraOverlay.isHidden = false
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.cameraOverlay.alpha = 1
            }, completion: nil)
            
        } else if sender.state == .ended {
            print("Scan stopped...")
            cameraOverlay.alpha = 0
            cameraOverlay.isHidden = true
            scanButton.setImage(UIImage(named: "camera-button"), for: .normal)
            self.isPressed = false
            UIView.animate(withDuration: 0.2) {self.scanButton.transform = CGAffineTransform.identity}}
    }
}

//MARK: - CaptureSession
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
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
        if self.isBarcode == true && self.isPressed == true && self.extractBarcode(fromFrame: frame) != nil {
            if let barcode = self.extractBarcode(fromFrame: frame) {
                let result: [ProductItem] = self.productService.fetchProductsByBarcode(with: barcode)
                
                if !result.isEmpty {
                    DispatchQueue.main.async {
                        self.scanButton.isHighlighted = false
                        self.cameraOverlay.alpha = 0
                    }
                    showModalDetectedProduct(product: result[0])
                    //                    print("hasil search \(String(describing: result[0]))")
                } else {
                    showAlert(withTitle: "Produk tidak ditemukan", message: "Silahkan tambahkan produk")
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
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
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

//MARK: - Vision Take Photo
extension ViewController: AVCapturePhotoCaptureDelegate {
    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let _ = error {
            // Handle Error
        } else if let cgImageRepresentation = photo.cgImageRepresentation(),
                  let orientationInt = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
                  let imageOrientation = UIImage.Orientation.orientation(fromCGOrientationRaw: orientationInt) {
            
            // Create image with proper orientation
            let cgImage = cgImageRepresentation.takeUnretainedValue()
            let cgOrientation = CGImagePropertyOrientation(imageOrientation)
            performVisionRequest(image: cgImage, orientation: cgOrientation)
        }
    }
    
    // MARK: - Vision
    
    /// - Tag: PerformRequests
    fileprivate func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        
        // Fetch desired requests based on switch status.
        let requests = createVisionRequests()
        // Create a request handler.
        let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                        orientation: orientation,
                                                        options: [:])
        
        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                self.presentAlert("Image Request Failed", error: error)
                return
            }
        }
    }
    
    /// - Tag: CreateRequests
    fileprivate func createVisionRequests() -> [VNRequest] {
        
        // Create an array to collect all desired requests.
        var requests: [VNRequest] = []
        requests.append(self.textRecognizeRequest)
        
        // Return grouped requests as a single array.
        return requests
    }
    
    fileprivate func recognizeTextHandler(request: VNRequest, error: Error?) {
        var resultScanText = [String]()
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let maximumCandidates = 1
        
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            if let result = candidate.string.extractTextRecognize() {
                resultScanText.append(result)
            }
        }
        
        // MARK : Koding untuk menyimpan produk dari vision text
        let result: [ProductItem] = self.productService.fetchProductsByNonBarcode(with: resultScanText)
        
        if !result.isEmpty {
            DispatchQueue.main.async {
                self.scanButton.isHighlighted = false
                self.cameraOverlay.alpha = 0
            }
            showModalDetectedProduct(product: result[0])
        } else {
            showAlert(withTitle: "Barang tidak ditemukan", message: "Silahkan tambahkan barang ke dalam database")
        }
        
        print("Result Text : \(resultScanText)")
        print("Result Database : \(result)")
    }    
}

extension ViewController: iOSDelegate {
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            print("TUPLE: ",tuple)
            if let row = tuple.applicationContext["row"] as? Int {
                self.label.text = String(row)
                self.lastNumber = row
            }
        }
    }
    
    
    func messageReceived(tuple: MessageReceived) {
    }
    
}

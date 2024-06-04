//
//  QRScannerViewController.swift
//  Pebble
//
//  Created by macbookPro on 28/07/2022.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var backBtn: UIButton!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrcodeFrameView: UIView?

    var didScanQR: ((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // get back camera for capture
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession.addInput(input)
            
            //Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            //Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            let scanBorder = UIImageView.init(frame: CGRect.init(x: self.view.center.x - 140, y: self.view.center.y - 140, width: 280, height: 280))
            scanBorder.image = UIImage.init(named: "scanBorder")
            self.view.addSubview(scanBorder)
            let label = UILabel.init()
            
            label.font = UIFont.init(name: "SatoshiVariable-Bold", size: 24)
            label.textColor = .white
            label.frame.size.height = 20
            label.frame.size.width = 185
            label.text = "Scan QR Code"
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -170),
                label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
            self.view.bringSubviewToFront(label)
            
            let label2 = UILabel.init()
            
            label2.font = UIFont.init(name: "SatoshiVariable-Bold_Medium", size: 16)
            label2.textColor = .white
            label2.frame.size.height = 20
            label2.frame.size.width = 185
            label2.text = "Scan QR Code to sign"
            
            self.view.addSubview(label2)
            label2.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 170),
                label2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
            self.view.bringSubviewToFront(label2)
            //Start video capture
            self.view.bringSubviewToFront(backBtn)
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
      
            
            // Initialize QR Code Frame to highlight the QR Code
            qrcodeFrameView = UIView()
            
            if let qrcodeFrameView = qrcodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it cotains at least one object
        if metadataObjects.count == 0 {
            qrcodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR Code is detected"
            return
        }
        
        //Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrcodeFrameView?.frame = barCodeObject!.bounds
        
        if metadataObj.stringValue != nil {
            self.didScanQR?(metadataObj.stringValue ?? "")
            captureSession.stopRunning()
            self.dismiss(animated: true)
//            messageLabel.text = metadataObj.stringValue
            }
        
        }
    }
}

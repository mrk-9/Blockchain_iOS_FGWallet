//
//  ScanQRVC.swift
//  FGWallet
//
//  Created by Ivan on 1/8/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import AVFoundation


class ScanQRVC: BaseViewController {
    
    var getcode: ((String) ->())?
    
    @IBOutlet weak var imgScan: UIImageView!
    
    @IBOutlet weak var viewScan: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        let backButon = UIBarButtonItem.init(image: #imageLiteral(resourceName: "backmenu"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButon
      
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        let videoInput: AVCaptureDeviceInput
        if let videoCaptureDevice = videoCaptureDevice {
            do {
                
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                
                
                
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [
                    AVMetadataObject.ObjectType.upce,
                    AVMetadataObject.ObjectType.code39,
                    AVMetadataObject.ObjectType.code39Mod43,
                    AVMetadataObject.ObjectType.ean13,
                    AVMetadataObject.ObjectType.ean8,
                    AVMetadataObject.ObjectType.code93,
                    AVMetadataObject.ObjectType.code128,
                    AVMetadataObject.ObjectType.pdf417,
                    AVMetadataObject.ObjectType.qr,
                    AVMetadataObject.ObjectType.aztec,
                    AVMetadataObject.ObjectType.itf14]
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
            } else {
                failed()
                return
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = AVLayerVideoGravity.resize
            previewLayer.frame = viewScan.layer.bounds
            viewScan.layer.insertSublayer(previewLayer, at: 0)
            
            captureSession.startRunning()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                metadataOutput.rectOfInterest = (self.previewLayer.metadataOutputRectConverted(fromLayerRect: self.imgScan.frame))
                
            })
        }else {
           failed()
        }
        
        

    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
}

extension ScanQRVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            
            if let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//                print(readableObject.stringValue.characters.count)
                if var code = readableObject.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    code = code.subStringBitcon()
                    getcode?(code)
                    dismiss(animated: true)
                
                }else{
                    
                }
                
//                found(code: readableObject.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            
        }else {
            dismiss(animated: true)
            
        }
        
    }
    
}

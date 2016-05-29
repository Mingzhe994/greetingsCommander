//
//  UserCameraViewController.swift
//  BookSearch
//
//  Created by Stuart on 10/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

//
//  ViewController.swift
//  BookSearch
//
//  Created by Stuart on 10/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//


import UIKit
import AVFoundation

class UserCameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate{
    
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var sendBarCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromCamera()
    }
    
    //start the camera
    func fromCamera() {
        do{
            
            self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            self.input = try AVCaptureDeviceInput(device: device)
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            self.session = AVCaptureSession()
            if UIScreen.mainScreen().bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code,
                                               AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,
                                               AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code]
            
            //calculate the size in middle
            let windowSize:CGSize = UIScreen.mainScreen().bounds.size;
            let scanSize:CGSize = CGSizeMake(windowSize.width*3/4,
                                             windowSize.width*3/4);
            var scanRect:CGRect = CGRectMake((windowSize.width-scanSize.width)/2,
                                             (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
            //calculate rectOfInterest
            scanRect = CGRectMake(scanRect.origin.y/windowSize.height,
                                  scanRect.origin.x/windowSize.width,
                                  scanRect.size.height/windowSize.height,
                                  scanRect.size.width/windowSize.width);
            //set detective place
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.preview.frame = UIScreen.mainScreen().bounds
            self.view.layer.insertSublayer(self.preview, atIndex:0)
            
            //add middle frame
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
            self.scanRectView.center = CGPointMake(
                CGRectGetMidX(UIScreen.mainScreen().bounds),
                CGRectGetMidY(UIScreen.mainScreen().bounds));
            self.scanRectView.layer.borderColor = UIColor.greenColor().CGColor
            self.scanRectView.layer.borderWidth = 1;
            
            //start catch
            self.session.startRunning()
            
            //Zoom out
            do {
                try self.device!.lockForConfiguration()
            } catch _ {
                NSLog("Error: lockForConfiguration.");
            }
            self.device!.videoZoomFactor = 1.5
            self.device!.unlockForConfiguration()
            
        }catch _ as NSError{
            //outPrint the error message
            
            let noMessage = UIAlertController(title: "Reminder: ", message: "there are not right to access phone", preferredStyle: .Alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {(action) in
                
            })
            
            
            noMessage.addAction(doneAction)
            
            self.presentViewController(noMessage, animated: true, completion: nil)

        }
    }
    
    //catch camera
    func captureOutput(captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [AnyObject]!,
                                                fromConnection connection: AVCaptureConnection!) {
        
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0]
                as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        //out put result
        //let showBarcoed = UIAlertController(title: "Barcode is:", message: stringValue, preferredStyle: .Alert)
        //let doneAction = UIAlertAction(title: "Done", style: .Default, handler: {(action) in})
        //showBarcoed.addAction(doneAction)
        //self.presentViewController(showBarcoed, animated: true, completion: nil)
        sendBarCode = stringValue!
        
        // print("Scan code number of charaters count \()")
        // student code number will be 14 charaters
        if sendBarCode.characters.count != 14{
            performSegueWithIdentifier("showBookDetail", sender: self)
        }else{
            performSegueWithIdentifier("showStudentCode", sender: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showStudentCode"{
            let show = segue.destinationViewController as! LibraryBookViewController
            show.receiveStudentCode = sendBarCode
            
        }else if segue.identifier == "showBookDetail"{
            let show = segue.destinationViewController as! BookDetailViewController
            
            show.receiveISBN = sendBarCode
        }
        
        
    }
}
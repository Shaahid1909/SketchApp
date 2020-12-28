//
//  ViewController.swift
//  SketchApp
//
//  Created by Admin on 24/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import PencilKit
import PhotosUI

class ViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

   
    
    @IBOutlet var canvasView: PKCanvasView!
    
    @IBOutlet var PencilFingerBtn: UIBarButtonItem!
    
    @IBAction func saveDrawingToCamRoll(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)}, completionHandler: {success, error in
            })
        }
    
    }
    
    
     let canvasWidth: CGFloat = 768
     let canvasOverscrollHeight: CGFloat = 500
    
    
     
     var drawing = PKDrawing()
     
     override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.allowsFingerDrawing = true
        
        updateContentSizeForDrawing()
        
        if let window = parent?.view.window,
        let toolPicker = PKToolPicker.shared(for: window){
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            
            canvasView.becomeFirstResponder()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        
        
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        return true
    }
    
    @IBAction func toggleFingerOrPencil (_ sender: Any){
        PencilFingerBtn.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        updateContentSizeForDrawing()
    }
    
    
    func updateContentSizeForDrawing(){
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHeight) * canvasView.zoomScale)
        }else{
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
        }
    


}


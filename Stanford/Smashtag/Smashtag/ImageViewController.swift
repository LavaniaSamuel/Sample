//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 10/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate  {
    
    public var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.maximumZoomScale = 1.0
            scrollView.minimumZoomScale = 0.4
            scrollView.addSubview(imageView)
        }
    }
    
    var imageView: UIImageView = UIImageView()
    
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
            zoomScaleToAspectFit()
        }
    }
    
    var autoZoom: Bool = true
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global().async { [weak self] in
                let imageData = try? Data(contentsOf: url)
                if let imageContent = imageData {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageContent)
                    }
                }
            }
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        autoZoom = true
        zoomScaleToAspectFit()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoom = false
    }
    
    private func zoomScaleToAspectFit() {
        if imageView.bounds.height > 0 && imageView.bounds.width > 0 {
            let zoomScaleForHeight = scrollView.bounds.height / imageView.bounds.height
            let zoomScaleForWidth = scrollView.bounds.width / imageView.bounds.width
            
            scrollView.minimumZoomScale = min(zoomScaleForHeight, zoomScaleForWidth)
            scrollView.maximumZoomScale = max(max(zoomScaleForHeight, zoomScaleForWidth), 5)
            
            if autoZoom {
                scrollView.setZoomScale(max(zoomScaleForHeight, zoomScaleForWidth), animated: true)
            }
            
            let contentOffSetX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
            let contentOffSetY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
            scrollView.contentOffset = CGPoint(x: contentOffSetX, y: contentOffSetY)
        }
    }
    
}

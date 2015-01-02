//
//  C4ImageProtocol.swift
//  C4iOS
//
//  Created by travis on 2015-01-01.
//  Copyright (c) 2015 C4. All rights reserved.
//

import C4Core
import Foundation

protocol C4ImageProtocol {
    // Copy the provided image
    init(image: C4Image)
    
    //Create from UIImage
    init(uiimage: C4Image)
    
    //Create from CGImage
    init(cgimage: C4Image)
    
    //Create from CIImage
    init(ciimage: C4Image)
    
    //Create from NSURL
    init(url: NSURL)
    
    // Create from NSData source
    init(data: NSData)
    
    // Create from raw (unsigned char) data source
    init(rawData: [CUnsignedChar], size: C4Size)
    
    //MARK: Properties
    //creates UIImage when accessed
    var uiimage: UIImage { get }
    
    //creates CGImage when accessed
    var cgimage: CGImageRef { get }
    
    //creates CIImage when accessed
    var ciimage: CIImage { get }
    
    //returns current image view layer's contents
    var contents : CGImageRef { get }
    
    //adjusts width without having to provide new frame
    var width : Double { get set }
    
    //adjusts height without having to provide new frame
    var height : Double { get set }
    
    //provides original size of image
    var originalSize : C4Size { get }
    
    //provides original ratio w : h of image
    var originalRatio : C4Size  { get }
    
    //toggles constraining current w : h ratio
    var constrainsProportions : Bool { get set }
    
    //MARK: Pixels
    //loads image data into memory
    func loadData()
    
    //gets color at specific point
    func colorAt(point: C4Point)
    
    //sets color at specific point
    func setColorAt(point: C4Point, color: C4Color)
    
    //flags whether or not image data has been loaded
    var imageDataLoaded : Bool { get }
    
    //returns current loaded image data
    var rawData : [CUnsignedChar] { get }
    
    //MARK: Filters
    //returns list of all available filters
    class var availableFilters : [AnyObject] { get }
    
    //indicates when multiple filters are being applied
    var multipleFilterEnabled : Bool { get }
    
    //prepares image for applying multiple filters
    func startFiltering()
    
    //creates new image from applied filters and changes the image contents
    func renderFilteredImage()
    
    //if true, then the image will show an activity indicator while applying filters
    var showsActivityIndicator : Bool { get set }
    
    //example of filter methods
    func boxBlur(radius: Double)
    func hueAdjust(angle: Double)
    func exclusionBlend(backgroundImage: C4Image)
    
    /** example usage
    
    let img = C4Image("anImage")
    img.startFiltering()
    img.boxBlur(10.0)
    img.exclusionBlend(anotherImg)
    img.hueAdjust(M_PI_4)
    img.renderFilteredImage()
    view.add(img)
    */
}
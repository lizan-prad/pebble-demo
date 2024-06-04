//
//  UI+Extensions.swift


import UIKit
import MBProgressHUD
import CoreImage.CIFilterBuiltins
import Loaf

func pushEnabledAtOSLevel() -> Bool {
 guard let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types else { return false }
 return currentSettings.rawValue != 0
}

extension UIViewController {
    func showToastMsg(_ msg: String, state: Loaf.State, location: Loaf.Location) {
        Loaf.init(msg, state: state, location: location, sender: self).show()
    }
}


extension UIViewController {
    
    class func instantiateFromStoryboard(_ name: String) -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewControllerIdentifier = String(describing: self) + StringConstants.controller
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
        return controller
    }
    
}

extension UIImageView {
    func setImage(from url: String, completion: (() -> Void)?) {
        
        guard let imageURL = URL(string: url) else { return }
        
        QueueConfig.backgroundQueue.async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = image
                completion?()
            }
        }
    }
}

extension UIView {
    
    func setStandardCornerRadius() {
        self.layer.cornerRadius = 4
    }
    
    
    func activityStartAnimating(_ activityColor: UIColor? = .white, backgroundColor: UIColor? = .clear) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647) {
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    func addStandardBorder() {
        self.layer.borderColor = UIColor.init(hex: "C0C0C0").cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
    }
    
    func addHighlightedBorder() {
        self.layer.borderColor = UIColor.init(hex: "ffffff").cgColor
        self.layer.borderWidth = 2.0
    }
    
    func removeHighlightedBorder() {
        self.layer.borderWidth = 0
    }
    
    func setGradient(_ startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [startColor.cgColor, startColor.cgColor, startColor.cgColor, startColor.cgColor, 
                                endColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientLeftRight(_ startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [startColor.cgColor,  endColor.cgColor, 
                                endColor.cgColor]
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width + 100, height: self.bounds.height)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientLeftRightNoExtra(_ startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [startColor.cgColor,  endColor.cgColor,
                                endColor.cgColor]
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addChildViewController(_ childVc: UIViewController, parentViewController parentVc: UIViewController) {
        parentVc.addChild(childVc)
        childVc.didMove(toParent: parentVc)
        childVc.view.frame = self.bounds
        self.addSubview(childVc.view)
    }
}

extension UIImage {
    func png(isOpaque: Bool = true) -> Data? { flattened(isOpaque: isOpaque).pngData() }
    func flattened(isOpaque: Bool = true) -> UIImage {
        if imageOrientation == .up { return self }
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in draw(at: .zero) }
    }
    
    func rotateImage() -> UIImage
        {
            var rotatedImage = UIImage();
            switch self.imageOrientation
            {
            case UIImage.Orientation.right:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation:UIImage.Orientation.down);
                
            case UIImage.Orientation.down:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation:UIImage.Orientation.left);
                
            case UIImage.Orientation.left:
                rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1, orientation:UIImage.Orientation.up);
        
                 default:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation:UIImage.Orientation.right);
            }
            return rotatedImage;
        }
}

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.replacingOccurrences(of: "#", with: "")
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt: UInt64 = 0x0
        scanner.scanHexInt64(&hexInt)
        
        var red: UInt64!, green: UInt64!, blue: UInt64!
        switch hexWithoutSymbol.count {
        case 3: // #RGB
            red = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            green = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            blue = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
        case 6: // #RRGGBB
            red = (hexInt >> 16) & 0xff
            green = (hexInt >> 8) & 0xff
            blue = hexInt & 0xff
        default:
            print("Hex error!")
        }
        
        self.init(
            red: (CGFloat(red)/255),
            green: (CGFloat(green)/255),
            blue: (CGFloat(blue)/255),
            alpha: alpha)
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        
        return NSString(format: "#%06x", rgb) as String
    }
}

extension Double {
    
    var inKilometerOrMeter: String  {
        return (self/1000) < 1 ? "\(Int(self))m" : "\(self/1000)km"
    }
}

struct Associate {
    static var hud: UInt8 = 0
    static var empty: UInt8 = 0
}

extension UIViewController{
    private func setProgressHud() -> MBProgressHUD {
        
        let progressHud:  MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.tintColor = UIColor.darkGray
        progressHud.removeFromSuperViewOnHide = true
        objc_setAssociatedObject(self, &Associate.hud, progressHud, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return progressHud
    }
    
    var progressHud: MBProgressHUD {
        if let progressHud = objc_getAssociatedObject(self, &Associate.hud) as? MBProgressHUD {
            progressHud.isUserInteractionEnabled = true
            return progressHud
        }
        return setProgressHud()
    }
    
    var progressHudIsShowing: Bool {
        return self.progressHud.isHidden
    }
    
    func showProgressHud() {
        self.progressHud.show(animated: false)
    }
    func showMessageHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
    }
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func hideProgressHud() {
        self.progressHud.label.text = ""
        self.progressHud.completionBlock = {
            objc_setAssociatedObject(self, &Associate.hud, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.progressHud.hide(animated: false)
    }
    
}
extension UIView {
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func rounded() {
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func addBorderwith(_ color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}

extension String {
    func generateQRCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 8, y: 8)

            if let output = filter.outputImage?.inverted?.blackTransparent?.inverted?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func generateQRCodeWith(_ logo: UIImage?) -> UIImage? {
        
        guard var image  = createCIImage() else { return nil}
        
        
        ///scale to width:height
        let scaleW = 227/image.extent.size.width
        let scaleH = 227/image.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleW, y: scaleH)
        image = image.transformed(by: transform)
        
        /// add logo

        
        
        /// update color
        if let colorImgae = updateColor(image: image) {
            image = colorImgae
        }
        
        if let logo = logo, let newImage =  addLogo(image: image, logo: logo) {
            image = newImage
        }
        
        return UIImage(ciImage: image)
    }
    
    func createCIImage() -> CIImage? {
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
                return nil
            }
            filter.setDefaults()
            filter.setValue(self.data(using: String.Encoding.ascii), forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            //https://www.qrcode.com/en/about/error_correction.html
            return filter.outputImage
        }
    
    func updateColor(image: CIImage) -> CIImage? {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            
            colorFilter.setValue(image, forKey: kCIInputImageKey)
        colorFilter.setValue(ColorConfig.baseColor.coreImageColor, forKey: "inputColor0")
        colorFilter.setValue(UIColor.init(hex: "F1F1FA").coreImageColor, forKey: "inputColor1")
            return colorFilter.outputImage
        }
    
    func addLogo(image: CIImage, logo: UIImage) -> CIImage? {
        
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        guard let logo = logo.cgImage else {
            return image
        }
        
        let ciLogo = CIImage(cgImage: logo)
        
        
        let centerTransform = CGAffineTransform(translationX: image.extent.midX - (ciLogo.extent.size.width / 2), y: image.extent.midY - (ciLogo.extent.size.height / 2))
        
        combinedFilter.setValue(ciLogo.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(image, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage
    }
}

extension UIImage {

    func resize(maxWidthHeight : Double)-> UIImage? {

        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0

        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }

        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension UIImage {
    
    
    
    
    func drawLogoIn(_ logo: UIImage, position: CGPoint) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.size)
        return renderer.image { context in
            self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
            logo.draw(in: CGRect(origin: position, size: CGSize.init(width: 62, height: 62)))
        }
    }
    
    /// place the imageView inside a container view
    /// - parameter superView: the containerView that you want to place the Image inside
    /// - parameter width: width of imageView, if you opt to not give the value, it will take default value of 100
    /// - parameter height: height of imageView, if you opt to not give the value, it will take default value of 30
    func addToCenter(of superView: UIView, width: CGFloat = 70, height: CGFloat = 70) {
        let overlayImageView = UIImageView(image: self)
//        overlayImageView.addCornerRadius(24)
        overlayImageView.clipsToBounds = true
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        superView.addSubview(overlayImageView)
        
        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }
}

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

           // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

           // And finally, get image
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension CIImage {
    var inverted: CIImage? {
            guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
            invertedColorFilter.setValue(self, forKey: "inputImage")
            return invertedColorFilter.outputImage
        }
    var blackTransparent: CIImage? {
            guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
            blackTransparentFilter.setValue(self, forKey: "inputImage")
            return blackTransparentFilter.outputImage
        }
}

extension UIView {
    
    func setStandardShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 4
        self.layer.shadowOffset = CGSize.init(width: 1, height: 2)
        self.layer.shadowRadius = 4
    }
}

extension UIButton {
    func disable() {
        self.backgroundColor = .lightGray
        self.isEnabled = false
    }
    
    func enable() {
        self.backgroundColor = currentTheme == .dark ? .white : .black
        self.isEnabled = true
    }
}

import UIKit

class MyFiltersVendor: NSObject, CIFilterConstructor {

    func filter(withName name: String) -> CIFilter? {
        switch name {
            case "GaussianBlur2Grayscale":
                return GaussianBlur2Grayscale()

            default:
                return nil
        }
    }
}

class GaussianBlur2Grayscale: CIFilter {

    static let filterCategories : NSArray = [
        kCICategoryVideo,
        kCICategoryStillImage,
        kCICategoryNonSquarePixels,
        kCICategoryInterlaced,
        "myFilter"
    ]

    static let defaultRadius = 10.0
    static let defaultWeightR = 0.2126
    static let defaultWeightG = 0.7152
    static let defaultWeightB = 0.0722

    // https://stackoverflow.com/questions/46566076/this-class-is-not-key-value-coding-compliant-using-coreimage
    @objc dynamic var inputImage: CIImage?
    @objc dynamic var inputRadius: CGFloat = 0
    @objc dynamic var inputWeightR: CGFloat = 0
    @objc dynamic var inputWeightG: CGFloat = 0
    @objc dynamic var inputWeightB: CGFloat = 0

    override var attributes: [String : Any] {
        return [
            kCIAttributeDisplayName: "Gaussian Blur and Grayscale",

            kCIAttributeFilterCategories: GaussianBlur2Grayscale.filterCategories,

            kCIInputImageKey: [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage
            ] as [String : Any],

            kCIInputRadiusKey: [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: GaussianBlur2Grayscale.defaultRadius,
                kCIAttributeDisplayName: "Radius",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 100,
                kCIAttributeType: kCIAttributeTypeScalar
            ] as [String : Any],

            "inputWeightR": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: GaussianBlur2Grayscale.defaultWeightR,
                kCIAttributeDisplayName: "Red Weight",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 1.0,
                kCIAttributeType: kCIAttributeTypeScalar
            ] as [String : Any],

            "inputWeightG": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: GaussianBlur2Grayscale.defaultWeightG,
                kCIAttributeDisplayName: "Green Weight",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 1.0,
                kCIAttributeType: kCIAttributeTypeScalar
            ] as [String : Any],

            "inputWeightB": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: GaussianBlur2Grayscale.defaultWeightB,
                kCIAttributeDisplayName: "Blue Weight",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 1.0,
                kCIAttributeType: kCIAttributeTypeScalar
            ] as [String : Any]

        ]
    }

    override func setDefaults() {
        inputRadius = GaussianBlur2Grayscale.defaultRadius
        inputWeightR = GaussianBlur2Grayscale.defaultWeightR
        inputWeightG = GaussianBlur2Grayscale.defaultWeightG
        inputWeightB = GaussianBlur2Grayscale.defaultWeightB
    }

    override var outputImage: CIImage! {
        guard let inputImage = inputImage else {
            return nil
        }

        let sum = inputWeightR + inputWeightG + inputWeightB
        let rw = inputWeightR / sum
        let gw = inputWeightG / sum
        let bw = inputWeightB / sum

//        print("\(inputRadius), \(rw), \(gw), \(bw)")

        let outputCiImage = inputImage
            .applyingFilter("CIGaussianBlur", parameters: [
                kCIInputRadiusKey: inputRadius
            ])
            .applyingFilter("CIColorMatrix", parameters: [
                    "inputRVector": CIVector(x: rw, y: gw, z: bw, w: 0),
                    "inputGVector": CIVector(x: rw, y: gw, z: bw, w: 0),
                    "inputBVector": CIVector(x: rw, y: gw, z: bw, w: 0),
                    "inputAVector": CIVector(x: 0, y: 0, z: 0, w: 1),
                    "inputBiasVector": CIVector(x: 0, y: 0, z: 0, w: 0)
            ])

        let roi = CGRect(x: 0, y: 0,
                         width: inputImage.extent.width,
                         height: inputImage.extent.height)
        let finalImage = outputCiImage.cropped(to: roi)

        return finalImage

    }

}

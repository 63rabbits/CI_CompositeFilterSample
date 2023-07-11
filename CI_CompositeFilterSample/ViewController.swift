import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // get source image
        let inputUiImage = UIImage(named: "kerokero")!      // get the image in assets.
        let inputCiImage = CIImage(image: inputUiImage)!    // convert to CIImage

        // register a filter
        CIFilter.registerName("GaussianBlur2Grayscale",
                              constructor: MyFiltersVendor(),
                              classAttributes: [
                                kCIAttributeFilterCategories: GaussianBlur2Grayscale.filterCategories
                              ])

        // check registered filter
//        let filters = CIFilter.filterNames(inCategories: ["myFilter", kCICategoryStillImage])
//        print(filters)



        // filter
        let outputCiImage = inputCiImage
            .applyingFilter("GaussianBlur2Grayscale", parameters: [
                "inputRadius": 5.0
            ])


        // view
        let outputUiImage = UIImage(ciImage: outputCiImage)
        imageView.image = outputUiImage


    }

}

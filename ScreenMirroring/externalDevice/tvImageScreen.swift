//
//  tvImageScreen.swift
//  screen
//
//  Created by Nguyễn Anh Tú on 24/05/2022.
//

import UIKit
import SDWebImage

class tvImageScreen: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var uiImage: UIImage?
    var imageURL: URL?
    
    init(nibName: String, uiImage: UIImage) {
        self.uiImage = uiImage
        super.init(nibName: nibName, bundle: nil)
    }
    
    init(nibName: String, imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let uiImage = self.uiImage {
            self.imageView.image = uiImage
        } else {
            self.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "Sharing Image"))
        }
    }
}

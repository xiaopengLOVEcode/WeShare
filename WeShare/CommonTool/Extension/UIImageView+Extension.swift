
import Foundation

public extension UIImageView {
    convenience init(imageNamed: String) {
        self.init(image: UIImage(named: imageNamed))
    }
}

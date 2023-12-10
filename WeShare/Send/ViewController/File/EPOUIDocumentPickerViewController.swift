

import UIKit
import UniformTypeIdentifiers

open class EPOUIDocumentPickerViewController: UIDocumentPickerViewController {
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return LayoutConstants.isPad ? .landscape : .portrait
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if LayoutConstants.isPad {
            if UIDevice.current.orientation == .landscapeRight {
                return .landscapeLeft
            } else if UIDevice.current.orientation == .landscapeLeft {
                return .landscapeRight
            } else {
                return .landscapeRight
            }
        } else {
            return .portrait
        }
    }
    
    @available(iOS 14.0, *)
    public override init(forOpeningContentTypes contentTypes: [UTType], asCopy: Bool) {
        super.init(forOpeningContentTypes: contentTypes, asCopy: asCopy)
    }

    @available(iOS, introduced: 8.0, deprecated: 14.0)
    public override init(documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode) {
        super.init(documentTypes: allowedUTIs, in: mode)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

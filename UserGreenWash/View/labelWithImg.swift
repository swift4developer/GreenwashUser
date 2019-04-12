//
//  labelWithImg.swift
//  MoneyLander
//
//  Created by PUNDSK003 on 8/5/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

extension UILabel {
    func addImageWith(name: String, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}


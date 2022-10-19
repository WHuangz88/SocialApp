//
//  LinkResponsiveTextView.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit

class LinkResponsiveTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)


        // required for tap to pass through on to superview & for links to work
        self.isScrollEnabled = false
        self.isEditable = false
        self.isUserInteractionEnabled = true
        self.isSelectable = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // location of the tap
        var location = point
        location.x -= self.textContainerInset.left
        location.y -= self.textContainerInset.top

        // find the character that's been tapped
        let characterIndex = self.layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < self.textStorage.length {
            // if the character is a link, handle the tap as UITextView normally would
            if self.textStorage.attribute(.link, at: characterIndex, effectiveRange: nil) != nil {
                return self
            }
        }

        // otherwise return nil so the tap goes on to the next receiver
        return nil
    }

}

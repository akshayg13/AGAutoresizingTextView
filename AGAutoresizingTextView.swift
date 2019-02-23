import UIKit

class AGAutoresizingTextView: UITextView {
    
    /// Height constraint to update
    private var heightConstraint : NSLayoutConstraint?
    
    var previousNumberOfLines = 1
    var maxLines = 1
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: UITextView.textDidChangeNotification, object: self)
        
        for constraint in constraints{
            if constraint.firstAttribute == .height{
                heightConstraint = constraint
                break
            }
        }
    }
    
    @objc func textViewDidChange(){
        
        guard let lineHeight = font?.lineHeight, let height = heightConstraint else {return}
        let numLines = Int(contentSize.height/lineHeight)
        
        //only show 4 lines
        if previousNumberOfLines < numLines && previousNumberOfLines <= maxLines{
            
            previousNumberOfLines = numLines
            height.constant += lineHeight
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
            
        }else if previousNumberOfLines > numLines{
            
            if numLines == 1{
                height.constant = 35.0
            }else{
                height.constant -= lineHeight
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
            
            previousNumberOfLines = numLines
        }
    }
}

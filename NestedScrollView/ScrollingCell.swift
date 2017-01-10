//
//  ScrollingCell.swift
//  NestedScrollView
//
//  Created by ZhuJiang on 17/1/5.
//  Copyright © 2017年 Charles. All rights reserved.
//

import UIKit

private let kColorViewTag: Int    =   100

open class ScrollingCell: UICollectionViewCell, UIScrollViewDelegate {
    
    //MARK:
    ///default color is red
    var color: UIColor! = UIColor.red{
        didSet {
            self.contentView.backgroundColor = self.color
        }
    }
    weak open var delegate: ScrollingCellDelegate?
    static var cellIdentifier: String = "ScrollingCellIdentifier"
    var scrollview: UIScrollView? = nil
    
    // MARK:
    override init(frame: CGRect){
        super.init(frame: frame)
        self.contentView.backgroundColor = self.color
        
        self.scrollview = UIScrollView.init()
        self.scrollview!.delegate = self
        self.scrollview!.isPagingEnabled = true
        self.scrollview!.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(self.scrollview!)
        
        let colorView = UIView.init()
        colorView.backgroundColor = self.color
        self.scrollview?.addSubview(colorView)
        colorView.tag = kColorViewTag
        
    }
    
    //必须要重载
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        let bounds = self.contentView.bounds
        let pageWidth = bounds.size.width
        self.scrollview!.frame = CGRect(x: 0, y: 0, width: pageWidth, height: bounds.size.height)
        self.scrollview!.contentSize = CGSize(width: pageWidth * 2, height: bounds.size.height)
        
        let colorView = self.contentView.viewWithTag(kColorViewTag)
        colorView?.frame = self.scrollview!.convert(bounds, from: self.contentView)
        
    }
    
}

///open 不能修饰protocol
public protocol ScrollingCellDelegate : NSObjectProtocol{
    @available(iOS 2.0, *)
    func scrollingCellDidBeginPulling(_ cell: ScrollingCell)
    
    func scrollCell(_ cell: ScrollingCell, didChangePullOffset offset: Float)
    
    func scrollCellDidEndPulling(_ cell: ScrollingCell)
}
//public protocol UIScrollViewDelegate : NSObjectProtocol {
//    
//    
//    
//    optional public func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

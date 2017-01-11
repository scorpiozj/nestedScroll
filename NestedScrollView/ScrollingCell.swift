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
            let colorView = self.contentView.viewWithTag(kColorViewTag)
            colorView?.backgroundColor = self.color
//            self.contentView.backgroundColor = self.color
        }
    }
    weak open var delegate: ScrollingCellDelegate?
    static var cellIdentifier: String = "ScrollingCellIdentifier"
    var scrollview: UIScrollView? = nil
    
    
    var pulling: Bool = false
    // MARK:
    override init(frame: CGRect){
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.cyan
        
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
    //MARK:UIScrollViewDelegate
    ///? protocol 定义／实现  是否需要 public
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Int(scrollView.contentOffset.x)
        
        if offset > ZZConstrants.Pull_Threshold && !pulling {
            self.delegate!.scrollingCellDidBeginPulling(self)
            pulling = true
        }
        
        if pulling == true {
            let pullOffset = max(0, offset - ZZConstrants.Pull_Threshold)
            self.delegate!.scrollCell(self, didChangePullOffset: Float(pullOffset))
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnded()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingEnded()
    }
    ////注意 self.delegate？
    func scrollingEnded() -> Void {

        self.delegate?.scrollCellDidEndPulling(self)
        pulling = false
        
        self.scrollview!.contentOffset = CGPoint(x: 0, y: 0)
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

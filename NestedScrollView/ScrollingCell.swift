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
    var color: UIColor! = UIColor.white{
        didSet {
            let colorView = self.scrollview!.viewWithTag(kColorViewTag)
            colorView?.backgroundColor = self.color
//            self.contentView.backgroundColor = self.color
        }
    }
    weak open var delegate: ScrollingCellDelegate?
    static var cellIdentifier: String = "ScrollingCellIdentifier"
    var scrollview: UIScrollView? = nil
    
    var pulling: Bool = false
    var deceleratingBackToZero = false
    var deceleratingDistanceRatio: CGFloat = 0.0
    
    // MARK:
    override init(frame: CGRect){
        super.init(frame: frame)
//        self.contentView.backgroundColor = UIColor.cyan
        
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
        let pageWidth = bounds.size.width + (ZZConstrants.Pull_Threshold)
        
        self.scrollview!.frame = CGRect(x: 0, y: 0, width: pageWidth, height: bounds.size.height)
        
        self.scrollview!.contentSize = CGSize(width: pageWidth * 2, height: bounds.size.height)
        
        let colorView = self.scrollview!.viewWithTag(kColorViewTag)
        colorView!.frame = self.scrollview!.convert(bounds, from: self.contentView)
        
        print("colorView = \(colorView?.frame), scrollView=\(self.scrollview!.frame)")
        
    }
    //MARK:UIScrollViewDelegate
    ///? protocol 定义／实现  是否需要 public
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.x)
        
        if offset > ZZConstrants.Pull_Threshold && pulling == false {
            self.delegate!.scrollingCellDidBeginPulling(self)
            pulling = true
//            print("pulling=true")
        }
        
        if pulling == true {
            print("offset=\(offset)")
            var pullOffset = max(0.0, offset - (ZZConstrants.Pull_Threshold))
            if deceleratingBackToZero == true {
                pullOffset = offset * deceleratingDistanceRatio
                print("Decelerate pullOffset=\(pullOffset)")
            }
            else
            {
                print("NoDecelerate pullOffset=\(pullOffset)")
            }
            
            self.delegate!.scrollCell(self, didChangePullOffset: (pullOffset))
//            let transform = CGAffineTransform.identity
//            self.scrollview!.transform = transform.translatedBy(x: pullOffset, y: 0)
            self.scrollview!.transform = CGAffineTransform(translationX: (pullOffset), y: 0)
//            let colorView = self.scrollview!.viewWithTag(kColorViewTag)
//            colorView?.transform = CGAffineTransform(translationX: (pullOffset), y: 0)
            
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
        deceleratingBackToZero = false
        
        self.scrollview!.contentOffset = CGPoint.zero//CGPoint(x: 0, y: 0)
        
        ///注意 ObjC CGAffineTransformIdentity
//        self.scrollview!.transform = CGAffineTransform.identity
        
        let colorView = self.scrollview!.viewWithTag(kColorViewTag)
        colorView?.transform = CGAffineTransform.identity
    }
    
    public func scrollViewWillEndDragging(_ scroll: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scroll.contentOffset.x
        
        if targetContentOffset.pointee.x == 0 && offset > 0 {
            deceleratingBackToZero = true
            
            let pullOffset = max(0.0, offset - (ZZConstrants.Pull_Threshold))
            deceleratingDistanceRatio = pullOffset / offset
        }
        let colorView = self.scrollview!.viewWithTag(kColorViewTag)
        ZZDebugLog(object: "contentFrame: \(colorView?.frame)")
    }
    
}

///open 不能修饰protocol
@objc public protocol ScrollingCellDelegate : NSObjectProtocol{
    @available(iOS 2.0, *)
    func scrollingCellDidBeginPulling(_ cell: ScrollingCell)
    
    func scrollCell(_ cell: ScrollingCell, didChangePullOffset offset: CGFloat)
    
    func scrollCellDidEndPulling(_ cell: ScrollingCell)
}
//public protocol UIScrollViewDelegate : NSObjectProtocol {
//    
//    
//    
//    optional public func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

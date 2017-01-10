//
//  ViewController.swift
//  NestedScrollView
//
//  Created by ZhuJiang on 17/1/5.
//  Copyright © 2017年 Charles. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource {
    //MARK:
    @IBOutlet weak var scrollViewOuter: UIScrollView!
    
    ///page 1 in scroll
    weak var collectionView: UICollectionView!
    ///page 2 in scroll
    weak var viewSingle: UIView!
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        p_configureOuterScrollView()
        p_addSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private
    fileprivate func p_configureOuterScrollView() -> Void {
        let viewFrame = self.view.frame
        self.scrollViewOuter.contentSize = CGSize(width: viewFrame.size.width * 2.0, height: viewFrame.size.height)
        self.scrollViewOuter.isPagingEnabled = true
        self.scrollViewOuter.delegate = self
    }
    
    fileprivate func p_addSubviews() -> Void {
        var viewFrame = self.view.frame
        ///add collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: viewFrame.size.width, height: 60)
        flowLayout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: viewFrame, collectionViewLayout: flowLayout)
        ///
        collection.register(ScrollingCell.self, forCellWithReuseIdentifier: ScrollingCell.cellIdentifier)
        self.scrollViewOuter.addSubview(collection)
        self.collectionView = collection
        self.collectionView.dataSource = self
        
        ///add single View
        viewFrame.origin.x += viewFrame.size.width
        let blueView = UIView(frame: viewFrame)
        blueView.backgroundColor = UIColor.blue
        self.scrollViewOuter.addSubview(blueView)
        self.viewSingle = blueView

    }
    
//    fileprivate func p_addSubviews() -> Void {
//        var viewFrame = self.view.frame
//        
//        let redView = UIView(frame: viewFrame)
//        redView.backgroundColor = UIColor.red
//        self.scrollViewOuter.addSubview(redView)
//        
//        viewFrame.origin.x += viewFrame.size.width
//        let blueView = UIView(frame: viewFrame)
//        blueView.backgroundColor = UIColor.blue
//        self.scrollViewOuter.addSubview(blueView)
//    }
    
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollingCell.cellIdentifier, for: indexPath) as! ScrollingCell
        if indexPath.row % 2 == 0{
            cell.color = UIColor.red
        }
        else if indexPath.row % 3 == 0{
            cell.color = UIColor.green
        }
        else {
            cell.color = UIColor.blue
        }
        return cell
    }
}


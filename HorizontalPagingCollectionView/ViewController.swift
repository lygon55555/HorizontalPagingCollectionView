//
//  ViewController.swift
//  HorizontalPagingCollectionView
//
//  Created by Yonghyun on 2020/06/17.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var customCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    let collectionViewMargin = CGFloat(40)
    let itemSpacing          = CGFloat(15)
    let itemHeight           = CGFloat(300)
    var itemWidth            = CGFloat(0)
    
    let pages  = ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"]
    let colors = [UIColor.blue, UIColor.red, UIColor.systemGreen, UIColor.purple, UIColor.systemYellow]

    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionView.dataSource = self
        customCollectionView.delegate   = self
        
        horizontalPagingSetting()
    }

    func horizontalPagingSetting() {
        let customLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  UIScreen.main.bounds.width - collectionViewMargin * 2.0
        
        customLayout.sectionInset        = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        customLayout.itemSize            = CGSize(width: itemWidth, height: itemHeight)
        customLayout.headerReferenceSize = CGSize(width: collectionViewMargin, height: 0)
        customLayout.footerReferenceSize = CGSize(width: collectionViewMargin, height: 0)
        customLayout.minimumLineSpacing  = itemSpacing
        customLayout.scrollDirection     = .horizontal
        
        customCollectionView.collectionViewLayout = customLayout
        customCollectionView.decelerationRate     = UIScrollView.DecelerationRate.fast
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = pages.count
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text           = pages[indexPath.row]
        cell.colorView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth            = Float(itemWidth + itemSpacing)
        let contentWidth         = Float(customCollectionView!.contentSize.width)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        var newPage              = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor((targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        }
        else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

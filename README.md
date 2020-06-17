![화면 기록 2020-06-17 오전 10 26 36 2020-06-17 10_36_16](https://user-images.githubusercontent.com/39911797/84844932-7c8dde80-b086-11ea-9b5f-b43cdacaca28.gif)

# Horizontal Paging for UICollectionView
Paging size and item size are customizable by changing values<br>
Swift 5 supported
<br>
## Code
```swift
let collectionViewMargin = CGFloat(40)
let itemSpacing          = CGFloat(15)
let itemHeight           = CGFloat(300)
var itemWidth            = CGFloat(0)

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
```

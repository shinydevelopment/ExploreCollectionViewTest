#import "PhotoGridCollectionViewLayout.h"

@implementation PhotoGridCollectionViewLayout

- (void)prepareLayout
{
  [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSArray *array = [super layoutAttributesForElementsInRect:rect];

  enum { leftSide = -1, rightSide = 1 };
  CGFloat const startPercentage = 0.5;
  CGRect bounds = self.collectionView.bounds;
  CGFloat halfBoundsWidth = bounds.size.width / 2;
  CGFloat centerX = bounds.origin.x + halfBoundsWidth;
  for (UICollectionViewLayoutAttributes *attributes in array) {
    CGFloat sideOfView = (attributes.center.x < centerX) ? leftSide : rightSide;
    CGFloat pointToMeasure = (sideOfView == leftSide) ? attributes.frame.origin.x + attributes.size.width : attributes.frame.origin.x; // Track the rightmost point on views being removed on the left side and vice versa
    CGFloat distanceOfPointFromCenterX = centerX - pointToMeasure;
    CGFloat percentageX = 1 - fabs(distanceOfPointFromCenterX / halfBoundsWidth); // Distance from the edge of the view as a percentage 0 -> 100% (ignoring ±)
    percentageX = MIN(MAX(0, percentageX), startPercentage); // Clip the percentages to 0 -> startPercengate%
    CGFloat adjustedPercentageX = percentageX / startPercentage;

    CGFloat angle = M_PI_2 * (1 - adjustedPercentageX);
    attributes.transform3D = CATransform3DMakeRotation(angle * sideOfView, 0, 1, 0);
//    if (attributes == array[8]) {
//      NSLog(@"%f %f", adjustedPercentageX, angle);
//      attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1);
//    }
  }
  return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
  return YES;
}

@end

// Maths is hard
// offsetX = MIN(offsetX, 100);
// CGFloat transformX = offsetX * 0.1;
// NSLog(@"%@ %f %@ %f %f", NSStringFromCGRect(self.collectionView.bounds), centerX, NSStringFromCGPoint(attributes.center), offsetX, transformX);
// attributes.transform3D = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(transformX, transformX));
// attributes.alpha = 0.5;

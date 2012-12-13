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

  // Change startPercentage to adjust when the cells start to transition out of their untransformed state
  // Values for start percentage are between 0 and 1 representing the range of 0 to half the screen
  CGFloat const startPercentage = 0.5;

  // Pre-calculate as much as possible, values here will change when the bounds of the collection
  // view change but will not change for each cell
  CGRect bounds = self.collectionView.bounds;
  CGFloat halfBoundsWidth = bounds.size.width / 2;
  CGFloat centerX = bounds.origin.x + halfBoundsWidth;

  // Process each cell in the visible rectangle (and some others which are included for some reason)
  for (UICollectionViewLayoutAttributes *attributes in array) {
    // Which side of the center point is this cell on, left or right?
    CGFloat sideOfView = (attributes.center.x < centerX) ? leftSide : rightSide;

    // Track the rightmost point on views being removed on the left side and vice versa
    CGFloat pointToMeasure = (sideOfView == leftSide) ? attributes.frame.origin.x + attributes.size.width : attributes.frame.origin.x;
    CGFloat distanceOfPointFromCenterX = centerX - pointToMeasure;

    // Distance from the edge of the view as a percentage 0 -> 100% (ignoring ±)
    CGFloat percentageX = 1 - fabs(distanceOfPointFromCenterX / halfBoundsWidth);

    // Clip the percentages to 0 -> startPercengate%
    percentageX = MIN(MAX(0, percentageX), startPercentage);

    // Adjust the percentage from 0 -> startPercentage% to 0% -> 100%
    CGFloat adjustedPercentageX = percentageX / startPercentage;

    // Apply the transform modified by that percentage
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

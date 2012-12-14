#import "PhotoGridCollectionViewLayout.h"
#import "PhotoGridViewLayoutAttributes.h"

@implementation PhotoGridCollectionViewLayout

- (void)prepareLayout
{
  [super prepareLayout];
}

+ (Class)layoutAttributesClass
{
  return [PhotoGridViewLayoutAttributes class];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSArray *array = [super layoutAttributesForElementsInRect:rect];

  enum { leftSide = -1, rightSide = 1 };

  // Change startPercentage to adjust when the cells start to transition out of their untransformed state
  // Values for start percentage are between 0 and 1 representing the range of 0 to half the screen
  CGFloat const startPercentage = 0.4;

  // Pre-calculate as much as possible, values here will change when the bounds of the collection
  // view change but will not change for each cell
  CGRect bounds = self.collectionView.bounds;
  CGFloat halfBoundsWidth = bounds.size.width / 2;
  CGFloat centerX = bounds.origin.x + halfBoundsWidth;

  // Process each cell in the visible rectangle (and some others which are included for some reason)
  for (PhotoGridViewLayoutAttributes *attributes in array) {
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
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1000; // m34 must be set before the transform so it knows depth
    transform = CATransform3DRotate(transform, angle * sideOfView, 0, 1, 0);
    attributes.transform3D = transform;

    // Set the anchor point for the cell depending on the side
    attributes.anchorPoint = (sideOfView == leftSide) ? CGPointMake(1, 0.5) : CGPointMake(0, 0.5);

    // Set the amount of shadow to apply depending on the rotation value
    attributes.shadowAlpha = adjustedPercentageX;
  }
  return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
  return YES;
}

@end

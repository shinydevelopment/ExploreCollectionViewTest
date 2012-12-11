#import "PhotoGridCollectionViewLayout.h"

@implementation PhotoGridCollectionViewLayout

- (void)prepareLayout
{
  [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSArray *array = [super layoutAttributesForElementsInRect:rect];

  CGRect bounds = self.collectionView.bounds;
  CGFloat centerX = bounds.origin.x + (bounds.size.width / 2);
  for (UICollectionViewLayoutAttributes *attributes in array) {
    CGFloat distanceFromCenterX = fabs(centerX - attributes.center.x);
    CGFloat scale = 1 - (distanceFromCenterX * 0.0005);
    attributes.transform3D = CATransform3DMakeScale(scale, scale, 0);
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

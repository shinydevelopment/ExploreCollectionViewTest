#import "PhotoGridCollectionViewCell.h"
#import "PhotoGridViewLayoutAttributes.h"

@implementation PhotoGridCollectionViewCell

- (void)applyLayoutAttributes:(PhotoGridViewLayoutAttributes *)attributes
{
  [super applyLayoutAttributes:attributes];
  self.layer.anchorPoint = attributes.anchorPoint;
  CGPoint position = self.layer.position;
  position.x += (attributes.anchorPoint.x > 0.5) ? self.layer.bounds.size.width : -self.layer.bounds.size.width;
  self.layer.position = position;
}

@end

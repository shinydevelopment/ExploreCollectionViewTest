#import "PhotoGridViewLayoutAttributes.h"

@implementation PhotoGridViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
  PhotoGridViewLayoutAttributes *attributes = [super copyWithZone:zone];
  attributes.anchorPoint = self.anchorPoint;
  attributes.shadowAlpha = self.shadowAlpha;
  return attributes;
}

@end

#import "ViewController.h"
#import "PhotoGridCollectionViewLayout.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) CAGradientLayer *shadowLayer;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  PhotoGridCollectionViewLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  layout.minimumLineSpacing = 0;
  layout.minimumInteritemSpacing = 0;

  // Fake shadowing on the collection view
  self.shadowLayer = [CAGradientLayer layer];
  self.shadowLayer.bounds = self.view.bounds;
  self.shadowLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
  self.shadowLayer.colors = @[ (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor ];
  self.shadowLayer.locations = @[ @0, @0.2, @0.8, @1 ];
  self.shadowLayer.startPoint = CGPointMake(0, 0.5);
  self.shadowLayer.endPoint = CGPointMake(1, 0.5);
  [self.view.layer addSublayer:self.shadowLayer];
}

#pragma mark UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section
{
  return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.backgroundColor = [self randomColor];
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGRect bounds = self.collectionView.bounds;
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    // Portrait
    return CGSizeMake(bounds.size.width / 3, bounds.size.height / 5);
  } else {
    // Landscape
    return CGSizeMake(bounds.size.width / 4, bounds.size.height / 4);
  }
}

- (UIColor *)randomColor
{
  CGFloat const precision = 1000;
  CGFloat redValue = arc4random_uniform(precision) / precision;
  CGFloat greenValue = arc4random_uniform(precision) / precision;
  CGFloat blueValue = arc4random_uniform(precision) / precision;
  return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [self.collectionView reloadData];

  self.shadowLayer.bounds = self.view.bounds;
  self.shadowLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
}

@end

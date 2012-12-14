#import "ViewController.h"
#import "PhotoGridCollectionViewLayout.h"
#import "PhotoGridCollectionViewCell.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  PhotoGridCollectionViewLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  layout.minimumLineSpacing = 0;
  layout.minimumInteritemSpacing = 0;
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
  PhotoGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.backgroundColor = [self randomColor];
  cell.indexPathLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
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
}

@end

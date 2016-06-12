//
//  TRStartViewController.m
//  TuringTest
//
//  Created by 刘小姐 on 15/11/20.
//  Copyright © 2015年 Zeng Haitao. All rights reserved.
//

#import "TRStartViewController.h"

#define kFrameWidth  [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height
#define kImageNum 3

@interface TRStartViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TRStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScrollVIew];
}
- (void)initScrollVIew
{
    for (int i = 0; i < kImageNum; i++) {
        UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: [NSString stringWithFormat:@"shanping%d",i+1]]];
        imageView.frame = CGRectMake(i*kFrameWidth, 0, kFrameWidth, kFrameHeight);
        [self.scrollView addSubview:imageView];
        
        if (i == kImageNum - 1) {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(kFrameWidth*(kImageNum - 1), 0, kFrameWidth, kFrameHeight);
            [self.scrollView addSubview:btn];
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            self.scrollView.pagingEnabled = YES;
        }
        
    }
    self.scrollView.contentSize = CGSizeMake(kImageNum*kFrameWidth, 0);
}
- (void)click:(id)sender
{
    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"navi"];
    //通过故事版中场景的唯一标识，来获取对应的场景对象
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

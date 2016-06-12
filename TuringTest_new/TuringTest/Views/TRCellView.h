//
//  TRCellView.h
//  Day08_1_Message
//
//  Created by 刘小姐 on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRCellView : UIView
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UILabel *middleUpLb;
@property (weak, nonatomic) IBOutlet UILabel *middleDownLb;
@property (weak, nonatomic) IBOutlet UIImageView *middleIV;
@property (weak, nonatomic) IBOutlet UILabel *bottomUpLb;
@property (weak, nonatomic) IBOutlet UILabel *bottomDownLb;
@property (weak, nonatomic) IBOutlet UIImageView *bottomIV;

@end

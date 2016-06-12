//
//  TRPictureCell.m
//  TuringTest
//
//  Created by 刘小姐 on 16/5/30.
//  Copyright © 2016年 Zeng Haitao. All rights reserved.
//

#import "TRPictureCell.h"
#import "UIImageView+WebCache.h"

@implementation TRPictureCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (TRCellView*)cellView {
    if (_cellView == nil) {
        NSArray*array = [[NSBundle mainBundle]loadNibNamed:@"TRCellView" owner:self options:nil];
        _cellView = array[0];
        _cellView.frame = CGRectMake(CELL_MARGIN_LR+CELL_TAIL_WIDTH+CELL_PADDING+ICON_MARGIN_LR+ICON_SIZE_WH ,CELL_MARGIN_TB+CELL_PADDING, 200, 150);
        _cellView.middleDownLb.numberOfLines = 0;
        _cellView.bottomUpLb.numberOfLines = 0;
    }
    return _cellView;
}
-(void)loadPictureCell:(TRMessage*)message{
   
    
            self.popIV.image = [[UIImage imageNamed:@"message_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR, CELL_CORNOR+CELL_TAIL_WIDTH, CELL_CORNOR,CELL_CORNOR)];
        
        CGRect frameOfPop =  self.cellView.frame;
    
    //=========头像===================//
    self.iconIV.image = [UIImage imageNamed:@"icon01.png"];
    //        self.iconIV.layer.cornerRadius = 20;
    //        self.iconIV.layer.masksToBounds = YES;
    CGFloat iconY = CGRectGetMaxY(frameOfPop) + CELL_MARGIN_LR - ICON_SIZE_WH;
    self.iconIV.frame = CGRectMake( ICON_MARGIN_LR, iconY , ICON_SIZE_WH, ICON_SIZE_WH);
    [self.contentView addSubview:self.iconIV];
    //=====
        frameOfPop.origin.x = CELL_MARGIN_LR+ICON_SIZE_WH+ICON_MARGIN_LR;
        frameOfPop.origin.y = CELL_MARGIN_TB;
        frameOfPop.size.width += 2*CELL_PADDING+CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2*CELL_PADDING;
        self.popIV.frame = frameOfPop;
        
        self.cellView.textLb.text = message.text;
        self.cellView.textLb.textColor = [UIColor whiteColor];
        self.cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.cellView.middleDownLb.textColor = [UIColor darkGrayColor];
        self.cellView.bottomDownLb.textColor = [UIColor darkGrayColor];
        self.cellView.layer.cornerRadius = 5;
        self.cellView.layer.borderWidth = 1.0;
        self.cellView.layer.masksToBounds = YES;
    
        TRList*list0 = (message.listArray)[0];
        TRList*list1 = (message.listArray)[1];
        [self.cellView.middleIV sd_setImageWithURL:[NSURL URLWithString:list0.icon] placeholderImage:[UIImage imageNamed:@"unshown"]];
        [self.cellView.bottomIV sd_setImageWithURL:[NSURL URLWithString:list1.icon] placeholderImage:[UIImage imageNamed:@"unshown"]];
        self.cellHeight =  MAX(frameOfPop.size.height, self.iconIV.frame.size.height)  + 2*CELL_MARGIN_TB;
        if (message.code == 302000) {
            self.cellView.middleUpLb.text = list0.source;
            self.cellView.bottomUpLb.text = list1.source;
            self.cellView.middleDownLb.text = list0.article;
            self.cellView.bottomDownLb.text = list1.article;
            self.cellView.upImageView.image = [UIImage imageNamed:@"xinwen.png"];
        }else{
            self.cellView.bottomUpLb.text = list1.name;
            self.cellView.middleDownLb.text = list0.info;
            self.cellView.middleUpLb.text = list0.name;
            self.cellView.bottomDownLb.text = list1.info;
            self.cellView.upImageView.image = [UIImage imageNamed:@"caipu.png"];
        }
         [self.contentView addSubview:self.popIV];
         [self.contentView addSubview:self.cellView];
}

@end

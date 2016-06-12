//
//  TRMessageCell.h
//  Day08_1_Message
//
//  Created by tarena on 15/10/8.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMessage.h"
#import "TRCellView.h"
#import "TRList.h"
#import "PrefixHeader.pch"

@interface TRMessageCell : UITableViewCell
//数据项
@property(nonatomic,strong) TRMessage *message;
//泡泡图
@property(nonatomic,strong) UIImageView *popIV;
//内容标签
@property(nonatomic,strong)UILabel*contentLb;
//用于记录当前Cell需要多高才能显示全所有内容
@property(nonatomic) CGFloat cellHeight;

@property(nonatomic,strong)UIImageView*iconIV;

//@property(nonatomic,strong)TRCellView*cellView;





@end






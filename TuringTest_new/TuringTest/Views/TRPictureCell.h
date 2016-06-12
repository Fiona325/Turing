//
//  TRPictureCell.h
//  TuringTest
//
//  Created by 刘小姐 on 16/5/30.
//  Copyright © 2016年 Zeng Haitao. All rights reserved.
//

#import "TRMessageCell.h"
#import "PrefixHeader.pch"

@interface TRPictureCell : TRMessageCell

@property(nonatomic,strong)TRCellView*cellView;
-(void)loadPictureCell:(TRMessage*)message;
@end

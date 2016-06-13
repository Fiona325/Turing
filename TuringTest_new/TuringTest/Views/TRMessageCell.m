//
//  TRMessageCell.m
//  Day08_1_Message
//
//  Created by tarena on 15/10/8.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMessageCell.h"
#import "UIImageView+WebCache.h"


@implementation TRMessageCell
- (UILabel*)contentLb{
    if (!_contentLb) {

        _contentLb = [UICopyLabel new];
//必须允许自动换行
        _contentLb.numberOfLines = 0;
        _contentLb.userInteractionEnabled = YES;
        _contentLb.font = [UIFont systemFontOfSize:17];
    }
    return _contentLb;
}
- (UIImageView *)popIV{
    if (!_popIV) {
        _popIV = [UIImageView new];
    }
    return _popIV;
}
- (UIImageView*)iconIV{
    if (!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}
//当为message属性赋值后，就可以根据message中的数值
//计算泡泡图和标签 的大小 和位置
//所以我们选择重写message的set方法 来抓住这个时间点


-(void)setMessage:(TRMessage *)message{
      self.backgroundColor = [UIColor clearColor];
    _message = message;
 
    /*因为开启了autolayout模式，直接获取self.bounds是不准确的
     self.bounds只有在layoutSubViews生命周期之后才准确
     所以获取当前屏幕宽度不能用self.bounds取
     CGFloat width = [UIScreen mainScreen].bounds.size.width;
     必须先为label赋值，之后才能算出label需要多大才能展示出它的内容
    */
    //==========判断是否有网址传进来，点击网址==============//
    if (message.url != nil) {
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel)];
        [self.contentLb addGestureRecognizer:tap];
        //============attriStr============
        NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc]initWithString:[message.text stringByAppendingString:message.url]];

        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(message.text.length, message.url.length)];
        [attriStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(message.text.length, message.url.length)];
        self.contentLb.attributedText = attriStr;
    }else{
        self.contentLb.text = message.text;
    }
   //====================================================
//计算在某个宽度限制下，需要多高能够显示所有内容
    CGRect textOfRect = [self.contentLb textRectForBounds:CGRectMake(0, 0, MAX_WIDTH_OF_TEXT, MAXFLOAT) limitedToNumberOfLines:0];
//判断是收还是发消息
    if (message.type == TRMessageTypeMe) { //蓝色气泡，尾巴在右
        self.contentLb.textColor = [UIColor whiteColor];
    
        self.popIV.image = [[UIImage imageNamed:@"message_i"] resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR, CELL_CORNOR, CELL_CORNOR, CELL_CORNOR+CELL_TAIL_WIDTH)];
        //根据计算出的标签的最大宽度和高度，计算它所处的位置
        CGRect frameOfLabel = CGRectZero;
        frameOfLabel.size = textOfRect.size;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDING;
//label的x轴=屏幕宽-尾巴距离右侧-尾巴宽-气泡与标签内边距-标签本身宽
        frameOfLabel.origin.x = Screen_Width-CELL_MARGIN_LR-CELL_TAIL_WIDTH-CELL_PADDING-textOfRect.size.width-ICON_SIZE_WH-ICON_MARGIN_LR;
        self.contentLb.frame = frameOfLabel;
        
//2.计算气泡的位置和大小
        CGRect frameOfPop = self.contentLb.frame;
        frameOfPop.origin.x -= CELL_PADDING;
        frameOfPop.origin.y -= CELL_PADDING;
        frameOfPop.size.width += 2*CELL_PADDING+CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2*CELL_PADDING;
        self.popIV.frame = frameOfPop;
        //=========头像===================//
        NSData *headData = [[NSUserDefaults standardUserDefaults]objectForKey:@"headImage"];
       _headImage =  [NSKeyedUnarchiver unarchiveObjectWithData:headData];
        if (_headImage != nil) {
            self.iconIV.image = _headImage;
            self.iconIV.layer.cornerRadius = 5;
            self.iconIV.clipsToBounds = YES;
        }else{
            self.iconIV.image = [UIImage imageNamed:@"icon02.png"];
        }
//        self.iconIV.layer.cornerRadius = 20;
//        self.iconIV.layer.masksToBounds = YES;
        CGFloat iconY = CGRectGetMaxY(frameOfPop) - ICON_SIZE_WH;
        self.iconIV.frame = CGRectMake(Screen_Width- ICON_MARGIN_LR-ICON_SIZE_WH, iconY , ICON_SIZE_WH, ICON_SIZE_WH);
        [self.contentView addSubview:self.iconIV];
        
//记录当前cell需要多高才能显示全所有内容
        _cellHeight = MAX(frameOfPop.size.height, self.iconIV.frame.size.height)  + 2*CELL_MARGIN_TB;
    }else{
        //灰色气泡，尾巴朝左
        
         self.popIV.image = [[UIImage imageNamed:@"message_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR, CELL_CORNOR+CELL_TAIL_WIDTH, CELL_CORNOR,CELL_CORNOR)];
    
                       //1.计算左侧的标签的位置和大小
                if (message.url != nil) {
                    self.contentLb.textColor = [UIColor blueColor];
                }else{
                self.contentLb.textColor = [UIColor blackColor];
                }
                       CGRect frameOfLabel = CGRectZero;
                       frameOfLabel.size = textOfRect.size;
                       frameOfLabel.origin.y = CELL_MARGIN_TB+CELL_PADDING;
                       frameOfLabel.origin.x = CELL_MARGIN_LR+CELL_TAIL_WIDTH+CELL_PADDING+ICON_MARGIN_LR+ICON_SIZE_WH;
                       self.contentLb.frame = frameOfLabel;
                       
                       //2.计算左侧气泡的宽高位置
                        CGRect frameOfPop = self.contentLb.frame;
                        frameOfPop.origin.x = CELL_MARGIN_LR+ICON_SIZE_WH+ICON_MARGIN_LR;
                        frameOfPop.origin.y = CELL_MARGIN_TB;
                        frameOfPop.size.width += 2*CELL_PADDING+CELL_TAIL_WIDTH;
                        frameOfPop.size.height += 2*CELL_PADDING;
                        self.popIV.frame = frameOfPop;
             
        //=========头像===================//
        self.iconIV.image = [UIImage imageNamed:@"icon01.png"];
        self.iconIV.layer.cornerRadius = 5;
        self.iconIV.layer.masksToBounds = YES;
        CGFloat iconY = CGRectGetMaxY(self.popIV.frame) - ICON_SIZE_WH;
        self.iconIV.frame = CGRectMake(ICON_MARGIN_LR, iconY , ICON_SIZE_WH, ICON_SIZE_WH);
        [self.contentView addSubview:self.iconIV];

//3.记录需要多高能够显示所有内容
      _cellHeight = MAX(frameOfPop.size.height, self.iconIV.frame.size.height)  + 2*CELL_MARGIN_TB;
    }
//把气泡和标签添加到cell中，注意添加顺序
    [self.contentView addSubview:self.popIV];
    [self.contentView addSubview:self.contentLb];
    
  
}
- (void)tapLabel {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.message.url]];
}
- (IBAction)clickMiddleBtn:(id)sender {
    TRList*listMiddle = (self.message.listArray)[0];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:listMiddle.detailurl]];
}
- (IBAction)clickBottomBtn:(id)sender {
    TRList*listBottom = (self.message.listArray)[1];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:listBottom.detailurl]];
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

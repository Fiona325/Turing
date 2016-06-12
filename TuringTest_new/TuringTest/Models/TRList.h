//
//  TRList.h
//  Day08_1_Message
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRList : NSObject
@property(nonatomic,strong)NSString*icon;
@property(nonatomic,strong)NSString*detailurl;
//火车类属性
//@property(nonatomic,strong)NSString*endtime;
//@property(nonatomic,strong)NSString*start;
//@property(nonatomic,strong)NSString*starttime;
//@property(nonatomic,strong)NSString*terminal;
//@property(nonatomic,strong)NSString*trainnum;
//新闻类属性
@property(nonatomic,strong)NSString*article;
@property(nonatomic,strong)NSString*source;
//航班类属性
//@property(nonatomic,strong)NSString*flight;
//菜谱类属性
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*info;

//+ (NSMutableArray *)lists:(id)resultObject;
@end

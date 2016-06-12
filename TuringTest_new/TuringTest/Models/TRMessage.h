//
//  TRMessage.h
//  TuringRobot
//
//  Created by tarena on 15/11/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//
typedef enum {
    
    TRMessageTypeRobot = 0,
    TRMessageTypeMe
    
}TRMessageType;

#import <Foundation/Foundation.h>

@interface TRMessage : NSObject
//发送者类型
@property (assign, nonatomic) TRMessageType type;
//通用类属性
@property (strong, nonatomic) NSString *text;
@property(nonatomic,assign)int code;
@property(nonatomic,strong)NSString*url;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
+ (instancetype)messageWithResponseObject:(id)responseObject;
+ (NSArray *)listsWithDictionary:(NSDictionary*)dict;
@property(nonatomic,strong)NSArray*listArray;



@end

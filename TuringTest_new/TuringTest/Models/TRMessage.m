//
//  TRMessage.m
//  TuringRobot
//
//  Created by tarena on 15/11/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "TRMessage.h"
#import "TRList.h"

@implementation TRMessage
//plist
+( instancetype )messageWithDict:( NSDictionary *)dict{
    
    TRMessage *message = [[TRMessage alloc ] init];
    [message setValuesForKeysWithDictionary :dict];
    return message;
    
}
- (instancetype)initMessageWithResponseObject:(id)responseObject {
    if (self = [super init]) {
        
        self.code = [responseObject[@"code"] intValue];
        self.text = responseObject[@"text"];
        self.url = responseObject[@"url"];
    }
    return self;
}
//- (void)setValue:(id)value forKey:(NSString *)key {
//    if ([key isEqualToString:@"list"]) {
//        for (NSMutableDictionary*listDict in value) {
//            TRList*list = [TRList listWithDictionary:listDict];
//            [self.listsMutableArray addObject:list];
//        }
//    }
//}
+ (instancetype)messageWithResponseObject:(id)responseObject {

    return [[self alloc]initMessageWithResponseObject:responseObject];
}
- (NSArray*)listArray {
    if (_listArray == nil) {
        _listArray = [NSArray array];
    }
    return _listArray;
}
+ (NSArray *)listsWithDictionary:(NSDictionary*)dict {
    NSArray *listsArray = dict[@"list"];
    NSMutableArray *listsMutableArray = [NSMutableArray array];
    
    for (NSDictionary *listDic in listsArray) {
        TRList *list = [TRList new];
        [list setValuesForKeysWithDictionary:listDic];
        [listsMutableArray addObject:list];
    }
    return [listsMutableArray copy];
}

@end

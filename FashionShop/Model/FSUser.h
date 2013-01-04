//
//  FSUser.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "FSUserLoginRequest.h"
#import "CommonResponseHeader.h"
#import "FSModelBase.h"

@interface FSUser : FSModelBase

@property (nonatomic,strong) NSNumber *  uid;
@property (nonatomic,strong) NSString *uToken;
@property (nonatomic,strong) NSString *nickie;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,assign) int likeTotal;
@property (nonatomic,assign) int fansTotal;
@property (nonatomic,assign) int pointsTotal;
@property (nonatomic,assign) FSUserLevel  userLevelId;
@property (nonatomic,strong) NSString *userLevelName;
@property (nonatomic,strong) NSString *thumnail;
@property (nonatomic,readonly) NSURL *thumnailUrl;
@property (nonatomic,assign) BOOL isLiked;
@property (nonatomic,assign) int couponsTotal;
@property (nonatomic,strong) NSMutableArray *coupons;

@property (nonatomic,assign) int gender;//性别
@property (nonatomic,strong) NSString *signature;//签名




+ (void) removeUserProfile;

+(FSUser *) localProfile;

+(NSString *) localLoginToken;


+(NSString *) localDeviceToken;

+(void) saveDeviceToken:(NSString *)device;

-(NSMutableArray *) localCoupons;

- (void) save;


@end

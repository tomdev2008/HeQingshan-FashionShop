//
//  FSFeedbackRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-1-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSFeedbackRequest.h"

@implementation FSFeedbackRequest
@synthesize userToken;
@synthesize phone;
@synthesize content;

-(NSString *) routeResourcePath
{
    return @"customer/feedback";
}

- (RKRequestMethod) requestMethod{
    return RKRequestMethodPOST;
}

- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"mobile" toAttribute:@"request.phone"];
    [map mapKeyPath:@"content" toAttribute:@"request.content"];
}

@end

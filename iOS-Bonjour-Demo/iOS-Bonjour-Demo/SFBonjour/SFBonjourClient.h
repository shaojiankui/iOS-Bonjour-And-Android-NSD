//
//  SFBonjourClient.h
//  iOS-Bonjour-Demo
//
//  Created by Jakey on 2018/11/16.
//  Copyright © 2018 Jakey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBonjourClient : NSObject
- (instancetype)init;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithDomainName:(NSString *)domain
                              type:(NSString *)type
                              name:(NSString *)name;
- (BOOL)start;
- (BOOL)stop;
@end

NS_ASSUME_NONNULL_END

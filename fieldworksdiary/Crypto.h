//
//  Crypto.h
//  sunrise
//
//  Created by Jo Brunner on 19.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Crypto : NSObject

+ (NSString *)sha1WithBinary:(NSData *)data;

@end

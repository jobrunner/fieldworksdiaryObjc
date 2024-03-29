//
//  Crypto.m
//  sunrise
//
//  Created by Jo Brunner on 19.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "Crypto.h"

@implementation Crypto

+ (NSString *)sha1WithString:(NSString *)string {

    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];

    return [Crypto sha1WithBinary:keyData];
}

+ (NSString *)sha1WithBinary:(NSData *)data {

    // create filename from sha1 hash
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    
    // create an unkeyed SHA1 hash of png data
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    // convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest
                                 length:CC_SHA1_DIGEST_LENGTH];
    
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *sha1Hash = [out description];
    sha1Hash = [sha1Hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    sha1Hash = [sha1Hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    sha1Hash = [sha1Hash stringByReplacingOccurrencesOfString:@">" withString:@""];

    return sha1Hash;
}

@end

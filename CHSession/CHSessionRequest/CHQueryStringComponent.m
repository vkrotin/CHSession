//
//  CHQueryStringComponent.m
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import "CHQueryStringComponent.h"

#pragma mark MAURLEncodedStringFromStringWithEncoding

NSString * CHURLEncodedStringFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_x_Max) {
        static NSString * const kCJLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
        return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                         (CFStringRef)string,
                                                                         NULL,
                                                                         (CFStringRef)kCJLegalCharactersToBeEscaped,
                                                                         CFStringConvertNSStringEncodingToEncoding(encoding)));
    } else
        
        return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@implementation CHQueryStringComponent

- (id)initWithKey:(id)key value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.key = key;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    return [NSString stringWithFormat:@"%@=%@", self.key, CHURLEncodedStringFromStringWithEncoding([self.value description], stringEncoding)];
}
@end

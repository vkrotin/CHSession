//
//  CHQueryStringComponent.h
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHQueryStringComponent : NSObject

@property (strong, nonatomic) id key;
@property (strong, nonatomic) id value;

- (id)initWithKey:(id)key value:(id)value;
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end

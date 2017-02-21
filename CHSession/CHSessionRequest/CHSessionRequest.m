//
//  CHSessionTools.m
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import "CHSessionRequest.h"
#import "CHQueryStringComponent.h"

#define HTTP_MULTIPART_BOUNDARY @"CHMULTIPARTBOUNDARY"

@implementation CHSessionRequest

NSArray * CHQueryStringComponentsFromKeyAndValue(NSString *key, id value);
NSArray * CHQueryStringComponentsFromKeyAndDictionaryValue(NSString *key, NSDictionary *value);
NSArray * CHQueryStringComponentsFromKeyAndArrayValue(NSString *key, NSArray *value);
NSString * CHQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding);


NSString * CHQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutableComponents = [NSMutableArray array];
    for (CHQueryStringComponent *component in CHQueryStringComponentsFromKeyAndValue(nil, parameters)) {
        [mutableComponents addObject:[component URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    
    return [mutableComponents componentsJoinedByString:@"&"];
}

NSArray * CHQueryStringComponentsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    if([value isKindOfClass:[NSDictionary class]]) {
        [mutableQueryStringComponents addObjectsFromArray:CHQueryStringComponentsFromKeyAndDictionaryValue(key, value)];
    } else if([value isKindOfClass:[NSArray class]]) {
        [mutableQueryStringComponents addObjectsFromArray:CHQueryStringComponentsFromKeyAndArrayValue(key, value)];
    } else {
        [mutableQueryStringComponents addObject:[[CHQueryStringComponent alloc] initWithKey:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

NSArray * CHQueryStringComponentsFromKeyAndDictionaryValue(NSString *key, NSDictionary *value){
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    [value enumerateKeysAndObjectsUsingBlock:^(id nestedKey, id nestedValue, BOOL *stop) {
        [mutableQueryStringComponents addObjectsFromArray:CHQueryStringComponentsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
    }];
    
    return mutableQueryStringComponents;
}

NSArray * CHQueryStringComponentsFromKeyAndArrayValue(NSString *key, NSArray *value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    [value enumerateObjectsUsingBlock:^(id nestedValue, NSUInteger idx, BOOL *stop) {
        [mutableQueryStringComponents addObjectsFromArray:CHQueryStringComponentsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
    }];
    
    return mutableQueryStringComponents;
}

NSMutableURLRequest *CHRequestWithURL(NSString *urlPath,NSString *method,id parameters,NSTimeInterval timeout, BOOL encoding, CHRequestCachePolicy cachPolicy)
{
    
    if (urlPath == nil || [urlPath isEqual:[NSNull null]] || [urlPath rangeOfString:@"http"].location == NSNotFound) {
        return nil;
    }
    
    NSString *_method = method;
    if (_method == nil) {
        _method = @"GET";
    }else{
        _method = [_method uppercaseString];
    }
    if (encoding) {
        urlPath = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:urlPath];
    
    if (url == nil) {
        return nil;
    }
    
    NSTimeInterval httpTimeout = (timeout && timeout!=0)?timeout:HTTP_DEFAULT_TIMEOUT;
    NSURLRequestCachePolicy httpCachPolicy = (NSURLRequestCachePolicy)cachPolicy;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:httpCachPolicy timeoutInterval:httpTimeout];
    [request setHTTPMethod:_method];
    [request setValue:@"CH Mobile App" forHTTPHeaderField:@"User-Agent"];
    
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        if ([_method isEqualToString:@"GET"] || [_method isEqualToString:@"HEAD"] || [_method isEqualToString:@"DELETE"]) {
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[urlPath rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", CHQueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding)]];
            [request setURL:url];
        } else {
            NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            if(![request valueForHTTPHeaderField:@"Content-Type"]){
                [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
            }
            
            [request setHTTPBody:[CHQueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }else if(parameters && [parameters isKindOfClass:[NSData class]]){
        
        if(![request valueForHTTPHeaderField:@"Content-Type"]){
            [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", HTTP_MULTIPART_BOUNDARY]  forHTTPHeaderField:@"Content-Type"];
        }
        [request setHTTPBody:parameters];
    }
    
    return request;
}



@end

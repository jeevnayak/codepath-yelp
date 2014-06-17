//
//  Business.m
//  Yelp
//
//  Created by Rajeev Nayak on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Business.h"
#import <MTLValueTransformer.h>

@implementation Business

- (NSString *)reviewCountString
{
    return [NSString stringWithFormat:@"%d Reviews", self.reviewCount];
}

- (NSString *)categoryString
{
    NSString *ret;
    for (NSString *category in self.categories) {
        if (ret == nil) {
            ret = category;
        } else {
            ret = [ret stringByAppendingFormat:@", %@", category];
        }
    }
    return ret;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"imageUrl": @"image_url",
             @"ratingImageUrl": @"rating_img_url_large",
             @"reviewCount": @"review_count",
             @"address": @"location.display_address"
             };
}

+ (NSValueTransformer *)imageUrlJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

+ (NSValueTransformer *)ratingImageUrlJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

+ (NSValueTransformer *)addressJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSArray *displayAddress) {
        return displayAddress[0];
    }];
}

+ (NSValueTransformer *)categoriesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSArray *categories) {
        NSMutableArray *categoryStrings = [[NSMutableArray alloc] init];
        for (NSArray *category in categories) {
            [categoryStrings addObject:category[0]];
        }
        return categoryStrings;
    }];
}

@end

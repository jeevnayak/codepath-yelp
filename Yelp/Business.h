//
//  Business.h
//  Yelp
//
//  Created by Rajeev Nayak on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MTLModel.h"
#import <MTLJSONAdapter.h>

@interface Business : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSURL *imageUrl;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSURL *ratingImageUrl;
@property (nonatomic, readonly) NSInteger reviewCount;
@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, copy, readonly) NSArray *categories;

- (NSString *)reviewCountString;
- (NSString *)categoryString;

@end

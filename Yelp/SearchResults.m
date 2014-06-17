//
//  SearchResults.m
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchResults.h"
#import "Business.h"
#import <MTLJSONAdapter.h>

@implementation SearchResults

- (SearchResults *)initWithResponse:(id)response
{
    self = [super init];
    if (self) {
        self.businesses = [MTLJSONAdapter modelsOfClass:Business.class fromJSONArray:response[@"businesses"] error:nil];
        self.mapRegion = response[@"region"];
    }
    return self;
}

@end

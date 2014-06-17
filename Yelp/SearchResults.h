//
//  SearchResults.h
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResults : NSObject

@property (nonatomic, copy) NSArray *businesses;
@property (nonatomic, copy) NSDictionary *mapRegion;

- (SearchResults *)initWithResponse:(id)response;

@end

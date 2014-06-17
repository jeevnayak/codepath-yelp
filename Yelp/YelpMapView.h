//
//  YelpMapView.h
//  Yelp
//
//  Created by Rajeev Nayak on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "SearchResults.h"

@interface YelpMapView : GMSMapView

@property (nonatomic, copy) SearchResults *searchResults;

@end

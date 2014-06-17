//
//  YelpMapView.m
//  Yelp
//
//  Created by Rajeev Nayak on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpMapView.h"
#import "Business.h"

@implementation YelpMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myLocationEnabled = YES;
    }
    return self;
}

- (void)setSearchResults:(SearchResults *)searchResults
{
    _searchResults = searchResults;
    [self reloadData];
}

- (void)reloadData
{
    // clear all existing markers
    [self clear];

    // reset the viewport of the map
    NSDictionary *mapCenter = self.searchResults.mapRegion[@"center"];
    double latitude = [mapCenter[@"latitude"] doubleValue];
    double longitude = [mapCenter[@"longitude"] doubleValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:12];
    self.camera = camera;

    // add a marker for each business
    for (Business *business in self.searchResults.businesses) {
        [self addMarkerForBusiness:business];
    }
}

- (void)addMarkerForBusiness:(Business *)business
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    // note: randomly generating a fake position here because the yelp api stopped including lat/long in search results
    marker.position = [self generateFakePosition];
    marker.title = business.name;
    marker.snippet = business.address;
    marker.map = self;
}

- (CLLocationCoordinate2D)generateFakePosition
{
    // get the map region info
    NSDictionary *mapCenter = self.searchResults.mapRegion[@"center"];
    double centerLat = [mapCenter[@"latitude"] doubleValue];
    double centerLong = [mapCenter[@"longitude"] doubleValue];
    NSDictionary *mapSpan = self.searchResults.mapRegion[@"span"];
    double latSpan = [mapSpan[@"latitude_delta"] doubleValue];
    double longSpan = [mapSpan[@"longitude_delta"] doubleValue];

    // generate a random lat/long pair within the map region
    double randomLat = [self randomDoubleWithCenter:centerLat span:latSpan];
    double randomLong = [self randomDoubleWithCenter:centerLong span:longSpan];
    return CLLocationCoordinate2DMake(randomLat, randomLong);
}

- (double)randomDoubleWithCenter:(double)center span:(double)span {
    // generate a random number between (center - span/2) and (center + span/2)
    float start = center - span / 2;
    return start + (((double) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * span);
}

@end

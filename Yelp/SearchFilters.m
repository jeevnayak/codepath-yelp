//
//  SearchFilters.m
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchFilters.h"

@implementation SearchFilters

- (id)initWithDefaults {
    self = [super init];
    if (self) {
        self.distance = DistanceAuto;
        self.sortType = SortTypeBestMatch;
        self.dealsOnly = NO;
        self.categories = [[NSMutableSet alloc] init];
    }
    return self;
}

- (NSDictionary *)searchParams
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"location": @"San Francisco"}];

    if (self.searchTerm != nil) {
        parameters[@"term"] = self.searchTerm;
    }

    if (self.distance != DistanceAuto) {
        parameters[@"radius_filter"] = [self searchParamForDistance:self.distance];
    }

    parameters[@"sort"] = [self searchParamForSortType:self.sortType];

    if (self.categories.count > 0) {
        parameters[@"category_filter"] = [self searchParamForCategories:self.categories];
    }

    if (self.dealsOnly) {
        parameters[@"deals_filter"] = @"1";
    }

    return parameters;
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchFilters *copy = [[SearchFilters allocWithZone:zone] init];
    copy.searchTerm = self.searchTerm;
    copy.distance = self.distance;
    copy.sortType = self.sortType;
    copy.dealsOnly = self.dealsOnly;
    copy.categories = [self.categories mutableCopy];
    return copy;
}

- (NSString *)searchParamForDistance:(Distance)distance
{
    switch (distance) {
        case Distance100M:
            return @"100";
        case Distance1000M:
            return @"1000";
        case Distance5000M:
            return @"5000";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid distance" userInfo:nil];
    }
}

- (NSString *)searchParamForSortType:(SortType)sortType
{
    return [[NSString alloc] initWithFormat:@"%d", sortType];
}

- (NSString *)searchParamForCategories:(NSMutableSet *)categories
{
    NSString *param;
    for (NSNumber *category in categories) {
        NSString *categoryString = [self searchParamForCategory:[category intValue]];
        if (param == nil) {
            param = categoryString;
        } else {
            param = [param stringByAppendingFormat:@",%@", categoryString];
        }
    }
    return param;
}

- (NSString *)searchParamForCategory:(Category)category
{
    switch (category) {
        case CategoryActive:
            return @"active";
        case CategoryArts:
            return @"arts";
        case CategoryAuto:
            return @"auto";
        case CategoryBeautySvc:
            return @"beautysvc";
        case CategoryEducation:
            return @"education";
        case CategoryEventServices:
            return @"eventservices";
        case CategoryFinancialServices:
            return @"financialservices";
        case CategoryFood:
            return @"food";
        case CategoryHealth:
            return @"health";
        case CategoryHomeServices:
            return @"homeservices";
        case CategoryHotelsTravel:
            return @"hotelstravel";
        case CategoryLocalFlavor:
            return @"localflavor";
        case CategoryLocalServices:
            return @"localservices";
        case CategoryMassMedia:
            return @"massmedia";
        case CategoryNightlife:
            return @"nightlife";
        case CategoryPets:
            return @"pets";
        case CategoryProfessional:
            return @"professionalservices";
        case CategoryPublicServicesGovt:
            return @"publicservicesgovt";
        case CategoryRealEstate:
            return @"realestate";
        case CategoryReligiousOrgs:
            return @"religiousorgs";
        case CategoryRestaurants:
            return @"restaurants";
        case CategoryShopping:
            return @"shopping";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid category" userInfo:nil];
    }
}

+ (NSString *)headerTitleForFilterType:(FilterType)filterType {
    switch (filterType) {
        case FilterTypeDistance:
            return @"Distance";
        case FilterTypeSort:
            return @"Sort By";
        case FilterTypeDeals:
            return @"Deals";
        case FilterTypeCategory:
            return @"Categories";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid filter type" userInfo:nil];
    }
}

+ (NSString *)displayStringForDistance:(Distance)distance
{
    switch (distance) {
        case DistanceAuto:
            return @"Auto";
        case Distance100M:
            return @"100 meters";
        case Distance1000M:
            return @"1 kilometer";
        case Distance5000M:
            return @"5 kilometers";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid distance" userInfo:nil];
    }
}

+ (NSString *)displayStringForSortType:(SortType)sortType
{
    switch (sortType) {
        case SortTypeBestMatch:
            return @"Best Match";
        case SortTypeDistance:
            return @"Distance";
        case SortTypeRating:
            return @"Rating";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid sort type" userInfo:nil];
    }
}

+ (NSString *)displayStringForCategory:(Category)category
{
    switch (category) {
        case CategoryActive:
            return @"Active Life";
        case CategoryArts:
            return @"Arts & Entertainment";
        case CategoryAuto:
            return @"Automotive";
        case CategoryBeautySvc:
            return @"Beauty & Spas";
        case CategoryEducation:
            return @"Education";
        case CategoryEventServices:
            return @"Event Planning & Services";
        case CategoryFinancialServices:
            return @"Financial Services";
        case CategoryFood:
            return @"Food";
        case CategoryHealth:
            return @"Health & Medical";
        case CategoryHomeServices:
            return @"Home Services";
        case CategoryHotelsTravel:
            return @"Hotels & Travel";
        case CategoryLocalFlavor:
            return @"Local Flavor";
        case CategoryLocalServices:
            return @"Local Services";
        case CategoryMassMedia:
            return @"Mass Media";
        case CategoryNightlife:
            return @"Nightlife";
        case CategoryPets:
            return @"Pets";
        case CategoryProfessional:
            return @"Professional Services";
        case CategoryPublicServicesGovt:
            return @"Public Services & Government";
        case CategoryRealEstate:
            return @"Real Estate";
        case CategoryReligiousOrgs:
            return @"Religious Organizations";
        case CategoryRestaurants:
            return @"Restaurants";
        case CategoryShopping:
            return @"Shopping";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid category" userInfo:nil];
    }
}

@end

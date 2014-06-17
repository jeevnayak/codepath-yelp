//
//  SearchFilters.h
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFilters : NSObject <NSCopying>

typedef NS_ENUM(NSInteger, FilterType) {
    FilterTypeDistance,
    FilterTypeSort,
    FilterTypeDeals,
    FilterTypeCategory,
    FilterTypeCount,
};

typedef NS_ENUM(NSInteger, Distance) {
    DistanceAuto,
    Distance100M,
    Distance1000M,
    Distance5000M,
    DistanceCount,
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeBestMatch,
    SortTypeDistance,
    SortTypeRating,
    SortTypeCount,
};

typedef NS_ENUM(NSInteger, Category) {
    CategoryActive,
    CategoryArts,
    CategoryAuto,
    CategoryBeautySvc,
    CategoryEducation,
    CategoryEventServices,
    CategoryFinancialServices,
    CategoryFood,
    CategoryHealth,
    CategoryHomeServices,
    CategoryHotelsTravel,
    CategoryLocalFlavor,
    CategoryLocalServices,
    CategoryMassMedia,
    CategoryNightlife,
    CategoryPets,
    CategoryProfessional,
    CategoryPublicServicesGovt,
    CategoryRealEstate,
    CategoryReligiousOrgs,
    CategoryRestaurants,
    CategoryShopping,
    CategoryCount,
};

@property (nonatomic, copy) NSString *searchTerm;
@property (nonatomic) Distance distance;
@property (nonatomic) SortType sortType;
@property (nonatomic) BOOL dealsOnly;
@property (nonatomic, strong) NSMutableSet *categories;

- (id)initWithDefaults;
- (NSDictionary *)searchParams;

+ (NSString *)headerTitleForFilterType:(FilterType)filterType;
+ (NSString *)displayStringForDistance:(Distance)distance;
+ (NSString *)displayStringForSortType:(SortType)sortType;
+ (NSString *)displayStringForCategory:(Category)category;

@end

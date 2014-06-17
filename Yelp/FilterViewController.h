//
//  FilterViewController.h
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFilters.h"

@protocol FilterViewControllerDelegate <NSObject>

- (void)searchWithNewFilters:(SearchFilters *)filters;

@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) SearchFilters *filters;
@property (nonatomic, strong) id <FilterViewControllerDelegate> delegate;

@end


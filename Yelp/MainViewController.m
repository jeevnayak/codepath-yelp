//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "SearchResults.h"
#import "SearchFilters.h"
#import "YelpMapView.h"

#import <MTLJSONAdapter.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet YelpMapView *mapView;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *mapButton;

@property (nonatomic, strong) BusinessCell *prototypeCell;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) SearchResults *searchResults;
@property (nonatomic, strong) SearchFilters *filters;
@property (nonatomic) BOOL showingMap;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        self.filters = [[SearchFilters alloc] initWithDefaults];
        self.showingMap = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the nav bar components
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = [UIColor blackColor];
    searchBar.delegate = self;
    self.filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.filterButton.enabled = NO;
    self.mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButton)];
    self.mapButton.enabled = NO;

    // init the nav bar
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = self.filterButton;
    self.navigationItem.rightBarButtonItem = self.mapButton;

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *businessCellNib = [UINib nibWithNibName:@"BusinessCell" bundle:nil];
    [self.tableView registerNib:businessCellNib forCellReuseIdentifier:@"BusinessCell"];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];

    [self performSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    cell.business = self.searchResults.businesses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.business = self.searchResults.businesses[indexPath.row];
    [self.prototypeCell layoutSubviews];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94; // height of a row without wrapping title text
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // hide keyboard
    [searchBar resignFirstResponder];

    self.filters.searchTerm = searchBar.text;
    [self performSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // hide keyboard
    [searchBar resignFirstResponder];
}

- (void)searchWithNewFilters:(SearchFilters *)filters
{
    self.filters = [filters copy];
    [self performSearch];
}

- (void)onFilterButton
{
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.filters = self.filters;
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onMapButton
{
    if (self.showingMap) {
        // flip back to the list
        [UIView transitionFromView:self.mapView
                            toView:self.tableView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionShowHideTransitionViews
                        completion:nil];
        self.mapButton.title = @"Map";
        self.showingMap = NO;
    } else {
        // flip to the map
        [UIView transitionFromView:self.tableView
                            toView:self.mapView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionShowHideTransitionViews
                        completion:nil];
        self.mapButton.title = @"List";
        self.showingMap = YES;
    }
}

- (void)performSearch
{
    // show loading spinner and kick off search
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithFilters:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
        // parse new results and refresh views
        self.searchResults = [[SearchResults alloc] initWithResponse:response];
        [self.tableView reloadData];
        self.mapView.searchResults = self.searchResults;

        // update loading spinner and buttons
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.filterButton.enabled = YES;
        self.mapButton.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end

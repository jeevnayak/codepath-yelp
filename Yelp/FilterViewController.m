//
//  FilterViewController.m
//  Yelp
//
//  Created by Rajeev Nayak on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SearchFilters.h"

NSInteger const kInitNumCategoriesToShow = 3;

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *expandedSections;
@property (nonatomic, strong) UISwitch *dealsSwitch;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Filters";
        self.expandedSections = [NSMutableDictionary dictionary];
        self.dealsSwitch = [[UISwitch alloc] init];
        [self.dealsSwitch addTarget:self action:@selector(onDealsSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the nav bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(onSearchButton)];

    // init table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StandardCell"];

    // init deals switch
    self.dealsSwitch.on = self.filters.dealsOnly;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FilterTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case FilterTypeDistance:
            if ([self isSectionExpanded:section]) {
                return DistanceCount;
            } else {
                return 1;
            }
        case FilterTypeSort:
            if ([self isSectionExpanded:section]) {
                return SortTypeCount;
            } else {
                return 1;
            }
        case FilterTypeDeals:
            return 1;
        case FilterTypeCategory:
            if ([self isSectionExpanded:section]) {
                return CategoryCount;
            } else {
                // +1 to account for the See All row
                return kInitNumCategoriesToShow + 1;
            }
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get cell and clear existing accessories
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    switch (section) {
        case FilterTypeDistance:
        {
            Distance distance;
            if ([self isSectionExpanded:section]) {
                distance = row;
                if (distance == self.filters.distance) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                NSAssert(row == 0, @"collapsed sections should only have 1 row");
                distance = self.filters.distance;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell Expander"]];
            }
            cell.textLabel.text = [SearchFilters displayStringForDistance:distance];

            return cell;
        }
        case FilterTypeSort:
        {
            SortType sortType;
            if ([self isSectionExpanded:section]) {
                sortType = row;
                if (sortType == self.filters.sortType) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                NSAssert(row == 0, @"collapsed sections should only have 1 row");
                sortType = self.filters.sortType;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell Expander"]];
            }
            cell.textLabel.text = [SearchFilters displayStringForSortType:sortType];
            
            return cell;
        }
        case FilterTypeDeals:
        {
            cell.textLabel.text = @"Offering a Deal";
            cell.accessoryView = self.dealsSwitch;
            return cell;
        }
        case FilterTypeCategory:
        {
            // special case the See All row
            if (![self isSectionExpanded:section] &&
                row == kInitNumCategoriesToShow) {
                cell.textLabel.text = @"See All";
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell Expander"]];
                return cell;
            }

            Category category = row;
            cell.textLabel.text = [SearchFilters displayStringForCategory:category];
            if ([self.filters.categories containsObject:[NSNumber numberWithInt:category]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            return cell;
        }
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [SearchFilters headerTitleForFilterType:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    switch (section) {
        case FilterTypeDistance:
        case FilterTypeSort:
            if ([self isSectionExpanded:section]) {
                [self collapseSection:section selectedRow:indexPath.row];
            } else {
                [self expandSection:section];
            }
            break;
        case FilterTypeDeals:
            // no-op
            break;
        case FilterTypeCategory:
            // special case the See All row
            if (![self isSectionExpanded:section] &&
                row == kInitNumCategoriesToShow) {
                [self expandSection:section];
            } else {
                Category category = row;
                [self toggleCategory:category];
            }
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (void)onDealsSwitch
{
    self.filters.dealsOnly = self.dealsSwitch.on;
}

- (void)onCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSearchButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate searchWithNewFilters:self.filters];
}

- (BOOL)isSectionExpanded:(NSInteger)section
{
    return [self.expandedSections[@(section)] boolValue];
}

- (void)expandSection:(NSInteger)section
{
    self.expandedSections[@(section)] = @YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)collapseSection:(NSInteger)section selectedRow:(NSInteger)row
{
    // update the filters
    NSIndexPath *prevSelectedIndexPath;
    switch (section) {
        case FilterTypeDistance:
            prevSelectedIndexPath = [NSIndexPath indexPathForRow:self.filters.distance inSection:section];
            self.filters.distance = row;
            break;
        case FilterTypeSort:
            prevSelectedIndexPath = [NSIndexPath indexPathForRow:self.filters.sortType inSection:section];
            self.filters.sortType = row;
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"not a collapsible section" userInfo:nil];
    }

    // move the checkmark to the newly selected cell
    UITableViewCell *prevSelectedCell = [self.tableView cellForRowAtIndexPath:prevSelectedIndexPath];
    prevSelectedCell.accessoryType = UITableViewCellAccessoryNone;
    NSIndexPath *newSelectedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *newSelectedCell = [self.tableView cellForRowAtIndexPath:newSelectedIndexPath];
    newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

    // mark the section as collapsed and refresh
    self.expandedSections[@(section)] = @NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleCategory:(Category)category {
    // get the cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:category inSection:FilterTypeCategory];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    // toggle the category and the checkmark in the cell
    NSNumber *categoryNumber = [NSNumber numberWithInt:category];
    if ([self.filters.categories containsObject:categoryNumber]) {
        [self.filters.categories removeObject:categoryNumber];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.filters.categories addObject:categoryNumber];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end

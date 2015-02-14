//
//  FiltersViewController.m
//  Yelp
//
//  Created by Dan Hipschman on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SegmentCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, assign) NSInteger sortByFilter;

@property (nonatomic, readonly) NSArray *sections;

- (void)initCategories;

@end

@implementation FiltersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        self.sortByFilter = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentCell" bundle:nil] forCellReuseIdentifier:@"SegmentCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

typedef enum {
    SortBy, Categories
} SectionCodes;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section][@"rows"] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self.sections[indexPath.section][@"code"] integerValue]) {
        case SortBy:
            return [self tableView:tableView sortByCellForIndexPath:indexPath];
        case Categories:
            return [self tableView:tableView categoryCellForIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - Segmenet cell delegate methods

- (void)segmentCell:(SegmentCell *)cell didUpdate:(NSInteger)value {
    self.sortByFilter = value;
}

#pragma mark - Private methods

- (NSArray *)sections {
    return @[@{@"code": @(SortBy), @"name": @"Sort by", @"rows": @1 },
             @{@"code": @(Categories), @"name": @"Categories", @"rows": @(self.categories.count) }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView categoryCellForIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView sortByCellForIndexPath:(NSIndexPath *)indexPath {
    SegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCell"];
    
    [cell.segmentControl setTitle:@"Best Match" forSegmentAtIndex:0];
    [cell.segmentControl setTitle:@"Distance" forSegmentAtIndex:1];
    [cell.segmentControl setTitle:@"Highest Rated" forSegmentAtIndex:2];
    cell.delegate = self;
    
    return cell;
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    [filters setObject:@(self.sortByFilter) forKey:@"sort"];
    
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories {
    self.categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                        @{@"name" : @"African", @"code": @"african" },
                        @{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Arabian", @"code": @"arabian" },
                        @{@"name" : @"Argentine", @"code": @"argentine" },
                        @{@"name" : @"Armenian", @"code": @"armenian" },
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                        @{@"name" : @"Asturian", @"code": @"asturian" },
                        @{@"name" : @"Australian", @"code": @"australian" },
                        @{@"name" : @"Austrian", @"code": @"austrian" },
                        @{@"name" : @"Baguettes", @"code": @"baguettes" },
                        @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                        @{@"name" : @"Barbeque", @"code": @"bbq" }];
}

@end

//
//  GJEntranceTableViewController.m
//  GJStockListView_Example
//
//  Created by 陈俊峰 on 2021/4/7.
//  Copyright © 2021 jufn. All rights reserved.
//

#import "GJEntranceTableViewController.h"
#import "GJMainRACDemoViewController.h"

@interface GJEntranceTableViewController ()

@property (nonatomic, copy) NSArray *data;

@end

@implementation GJEntranceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.data = @[@"RAC"];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.data[indexPath.row];
    
    if ([text isEqualToString:@"RAC"]) {
        [self.navigationController pushViewController:GJMainRACDemoViewController.new animated:YES];
    }
}

@end

//
//  OnGoSubTableViewController.m
//  JanewayApp
//
//  Created by winemocol on 2016-06-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "OnGoSubTableViewController.h"
#import "FirstTableViewCell.h"
#import "ImageTableViewCell.h"
#import "WebTableViewCell.h"

@interface OnGoSubTableViewController ()

@property (nonatomic, strong) NSString *descriptionSubView;

@property (nonatomic) NSInteger numberOfCell;

@property (nonatomic, strong) NSArray *webPageArray;

@end

@implementation OnGoSubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Go";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    if([self.title isEqualToString:@"Car seat safety"]) {
        
        self.descriptionSubView = @"Car seats are designed to protect children from injury during a collision. The type of seat your child needs depends on your child’s age and size.";
        self.numberOfCell = 3;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Stroller safety"]) {
        
        self.descriptionSubView = @"Stroller safety begins with choosing the proper stroller to fit you and your child’s lifestyle and needs.";
        self.numberOfCell = 3;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Playground safety"]) {
        self.descriptionSubView = @"Here are some useful tips to make your trips to the playground with your child fun and injury free.";
        self.numberOfCell = 3;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Baby slings and carriers"]) {
        
        self.descriptionSubView = @"Baby slings and carriers allow parents to keep their children close as they go about their routines but improper use can lead to injury. Here are some tips to safely use a sling/carrier.";
        self.numberOfCell = 3;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Travelling with children"]) {
        
        self.descriptionSubView = @"It is important to plan out a trip when travelling with children. See below for some tips on how to make flying a pleasant experience for you and your child.";
        self.numberOfCell = 3;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Driveway/backyard"]) {
        
        self.numberOfCell = 1;
        self.webPageArray = @[];
        
    } else if ([self.title isEqualToString:@"Additional information"]) {
        
        self.numberOfCell = 1;
        self.webPageArray = @[];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.numberOfCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if(self.numberOfCell == 3) {
        
        if (indexPath.row == 0) {
            FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoSubFirstCell" forIndexPath:indexPath];
            [self setUpCell:cell atIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
            return cell;
        } else if (indexPath.row == 1) {
            ImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
            return cell;
        } else {
            WebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell" forIndexPath:indexPath];
            
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Google" ofType:@"html"];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [cell.webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
            return cell;

        }
    } else {
        

            WebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell" forIndexPath:indexPath];
            [self setUpWebCell:cell atIndexPath:indexPath];
            return cell;
        
    }
        
}


- (void)setUpWebCell:(WebTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Google" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [cell.webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
}

- (void)setUpCell:(FirstTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.descriptionLabel.text = self.descriptionSubView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.numberOfCell == 3) {
        
        if(indexPath.row == 0)
        {
            return [self heightForFirstTableCell:indexPath]+10;
            
        } else if(indexPath.row == 1){
            
            return 20;
            
        } else {
            
            return 700;//[self heightForWebTableCell:indexPath]+10;
        }
    } else {
        return 900;//[self heightForWebTableCell:indexPath]+10;
 
    }

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.numberOfCell == 3) {
        
        if(indexPath.row == 0)
        {
            return 180;
            
        } else if(indexPath.row == 1){
            
            return 20;
            
        } else {
            
            return 500;
        }
    } else {
        
            return 500;
    }
}

- (CGFloat)heightForWebTableCell:(NSIndexPath *)indexPath {
    
    static WebTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"webCell" forIndexPath:indexPath];
    });
    [self setUpWebCell:cell atIndexPath:indexPath];
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)heightForFirstTableCell:(NSIndexPath *)indexPath {
    
    static FirstTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"OnGoSubFirstCell"];
    });
    [self setUpCell:cell atIndexPath:indexPath];
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end

//
//  OnGoTableViewController.m
//  JanewayApp
//
//  Created by winemocol on 2016-06-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "OnGoTableViewController.h"
#import "FirstTableViewCell.h"
#import "RemainTableViewCell.h"
#import "WebViewController.h"
@interface OnGoTableViewController ()
@property (nonatomic, strong) NSArray *webPageArray;
@end

@implementation OnGoTableViewController

@synthesize titleData;
@synthesize descriptionData;
@synthesize linkData;
@synthesize xMLString;
@synthesize dictionary_onGO;
//http://codebeautify.org/xmlviewer
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startParsing];
    
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.topItem.title = @"Safety Concerns on the Go";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - Parse XML files
- (void)startParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"onGo" ofType:@"xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithData:data] ;
    [xmlparser setDelegate:self];
    [xmlparser parse];
    if (titleData.count != 0) {
        [self.tableView reloadData];
    }
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"rss"]) {
        titleData = [[NSMutableArray alloc] init];
        descriptionData = [[NSMutableArray alloc] init];
        linkData = [[NSMutableArray alloc] init];
    }
    
    
    if([elementName isEqualToString:@"title"]|| [elementName isEqualToString:@"description"]|| [elementName isEqualToString:@"link"])
        dictionary_onGO = [[NSMutableDictionary alloc] init];
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!xMLString)
        xMLString = [[NSMutableString alloc] initWithString:string];
    else
        [xMLString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"title"]) {
        
        [dictionary_onGO setObject:xMLString forKey:elementName];
        [titleData addObject:dictionary_onGO];
        
    } else if([elementName isEqualToString:@"description"]) {
        
        [dictionary_onGO setObject:xMLString forKey:elementName];
        [descriptionData addObject:dictionary_onGO];
        
    } else if ([elementName isEqualToString:@"link"]) {
        
        [dictionary_onGO setObject:xMLString forKey:elementName];
        [linkData addObject:dictionary_onGO];
        
    }

    xMLString = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"onGoSubview"]) {
        
        WebViewController *webViewController = segue.destinationViewController;
        RemainTableViewCell *cell = sender;
        webViewController.title = cell.cellTitle.text;
        webViewController.webFileName = cell.cellWebFileName;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 200;
        
    } else {
        return 80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *title = [titleData objectAtIndex:indexPath.row];
    NSString* titleString = [[title objectForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *descrition_onGo = [descriptionData objectAtIndex:indexPath.row];
    NSString* descrition_onGoString = [[descrition_onGo objectForKey:@"description"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSLog(@"titleString = %@",titleString);
    if (indexPath.row == 0) {
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoFirstCell" forIndexPath:indexPath];
        cell.descriptionLabel.text = descrition_onGoString;
        return cell;
    } else if(indexPath.row == 1){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"CarSeat"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    } else if(indexPath.row == 2){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text =titleString;
        cell.cellImage.image = [UIImage imageNamed:@"StrollerSafety"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    } else if(indexPath.row == 3){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"PlaySafety"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    }
    else if(indexPath.row == 4){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"BabySlings"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    } else if(indexPath.row == 5){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"TravelingChildren"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    } else if(indexPath.row == 6){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Driveway"];
        cell.cellDetail.text = descrition_onGoString;
        cell.cellWebFileName =[[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    } else {
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnGoRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"links"];
        cell.cellDetail.text = @"Web link";
        cell.cellWebFileName = [[[linkData objectAtIndex:indexPath.row-1] objectForKey:@"link"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cell;
    }

    
}


@end

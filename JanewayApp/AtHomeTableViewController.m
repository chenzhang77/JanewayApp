//
//  AtHomeTableViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "AtHomeTableViewController.h"
#import "FirstTableViewCell.h"
#import "RemainTableViewCell.h"
#import "SubTableViewController.h"
#import "WebViewController.h"

@interface AtHomeTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AtHomeTableViewController

@synthesize titleData;
@synthesize descriptionData;
@synthesize xMLString;
@synthesize dictionary_onGO;

@synthesize dictionary_item;
@synthesize itemData;
@synthesize subTitleData;
@synthesize subLiinkData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startParsing];
    
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.topItem.title = @"Safety Concerns at Home";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];

    
}


#pragma mark - Parse XML files
- (void)startParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"atHome" ofType:@"xml"];
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
    }
    
    if([elementName isEqualToString:@"title"]|| [elementName isEqualToString:@"description"]|| [elementName isEqualToString:@"link"])
        dictionary_onGO = [[NSMutableDictionary alloc] init];
    
    if([elementName isEqualToString:@"subSection"]) {
        dictionary_item = [[NSMutableDictionary alloc] init];//subSection
        itemData = [[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"subtitle"]) {
        subTitleData = [[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"link"]) {
        subLiinkData = [[NSMutableArray alloc] init];
    }
    
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
    }else if([elementName isEqualToString:@"subtitle"]) {
        [subTitleData addObject:xMLString];
    }else if([elementName isEqualToString:@"link"]) {
        [subLiinkData addObject:xMLString];
    }else if ([elementName isEqualToString:@"subSection"]) {
        [dictionary_item setObject:subTitleData forKey:@"title"];
        [dictionary_item setObject:subLiinkData forKey:@"link"];
        [itemData addObject:dictionary_item];
    }
    
    xMLString = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"subview"]) {
        
        SubTableViewController *mySubLevelViewController = segue.destinationViewController;
        RemainTableViewCell *cell = sender;
        mySubLevelViewController.title = cell.cellTitle.text;
    } else if ([segue.identifier isEqualToString:@"lastview"]) {
        
        WebViewController *webViewController = segue.destinationViewController;
        RemainTableViewCell *cell = sender;
        webViewController.title = cell.cellTitle.text;
        webViewController.webFileName = @"PageFireSafety";
    }
        
        
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sectionIDDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionID" ascending:YES];
    NSArray *sortDescriptors = @[sectionIDDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:NULL cacheName:NULL];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //NSLog(@"numberOfSectionsInTableView = %lu",[[self.fetchedResultsController sections] count]);
    return 1;//[[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //NSLog(@" numberOfRowsInSection = %lu",[sectionInfo numberOfObjects]);
    return [titleData count];//[sectionInfo numberOfObjects];
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
    
    
    if (indexPath.row == 0) {
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        cell.descriptionLabel.text = descrition_onGoString;//@"Most injuries to young children happen at home. Get on your hands and knees and look at your home from your child’s point of view. Look for possible dangers and remove them. What’s dangerous in a home depends on a child’s age and abilities.";
        return cell;
    } else if(indexPath.row == 1){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Bathroom"];
        cell.cellDetail.text = descrition_onGoString;//@"Keep the bathroom door shut when not in use and consider applying a safety cover over the doorknob. Here are a few tips to help keep your child safe and injury free in the bathroom.";
        return cell;
    } else if(indexPath.row == 2){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Kitchen"];
        cell.cellDetail.text = descrition_onGoString;//@"Most childhood injuries occur in the kitchen. You can keep your child behind a safety gate or secure in a highchair when you are cleaning, cooking or making hot drinks to keep them safe.";
        return cell;
    } else if(indexPath.row == 3){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Livingroom"];
        cell.cellDetail.text = descrition_onGoString;//@"The living room is a common gathering room for family members of all ages, thus making it prone for injuries in children.";
        return cell;
    }
    else if(indexPath.row == 4){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Nursery"];
        cell.cellDetail.text = descrition_onGoString;//@"When preparing your child nursery or bedroom, the important thing to remember is to make sure that children are sleeping where they are safe.";
        return cell;
    } else if(indexPath.row == 5){
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Laundry"];
        cell.cellDetail.text = descrition_onGoString;//@"Children like to explore and once they are mobile it is especially important to keep all areas of the home safe for your child.";
        return cell;
    } else {
        RemainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LastRemainCell" forIndexPath:indexPath];
        cell.cellTitle.text = titleString;
        cell.cellImage.image = [UIImage imageNamed:@"Fire"];
        cell.cellDetail.text = descrition_onGoString;//@"You should be aware of the potential hazards in your home that can cause a fire. The safest thing you can do to prepare is to be aware of these fire hazards and take steps to prevent a fire from happening in your home.";
        return cell;
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


@end

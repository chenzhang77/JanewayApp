//
//  SubTableViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "SubTableViewController.h"
#import "subTableViewCell.h"
#import "FirstTableViewCell.h"
#import "WebViewController.h"
@interface SubTableViewController ()

@property (nonatomic, strong) NSString *descriptionSubView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSArray *ImageArray;
@property (nonatomic, strong) NSArray *webPageArray;

@property (nonatomic, strong) NSString *titleInXML;

@end

@implementation SubTableViewController



@synthesize xMLString;
@synthesize subTitleData;
@synthesize subLiinkData;
@synthesize description_firstCell;
@synthesize title_firstCell;
@synthesize dictionary_atHome;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startParsing];
    
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Home";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    if([self.title isEqualToString:@"Bathroom"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;
        self.ImageArray = @[@"Burn",@"Fall",@"Drowning",@"Cut",@"links"];
        self.webPageArray = subLiinkData;
        
    } else if ([self.title isEqualToString:@"Kitchen"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;
        self.ImageArray = @[@"Burn",@"Highchairs",@"Choking",@"Ingestion",@"Fall",@"links"];
        self.webPageArray = subLiinkData;
        
    } else if ([self.title isEqualToString:@"Living room"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;   
        self.ImageArray = @[@"Fall",@"Choking",@"Playpen",@"Burn",@"links"];
        self.webPageArray = subLiinkData;
        
    } else if ([self.title isEqualToString:@"Nursery/bedroom"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;
        self.ImageArray = @[@"Sleep",@"Crib",@"Fall",@"OtherBedroom"];
        self.webPageArray = subLiinkData;
        
    } else if ([self.title isEqualToString:@"Laundry room, stairs and garage"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;
        self.ImageArray = @[@"Fall",@"Ingestion",@"SafetyTrip"];
        self.webPageArray = subLiinkData;
        
    } else if ([self.title isEqualToString:@"Fire safety"]) {
        
        self.descriptionSubView = description_firstCell;
        self.titleArray = subTitleData;
        self.ImageArray = @[@"Fire"];
        self.webPageArray = subLiinkData;
        
    }
}


#pragma mark - Parse XML files
- (void)startParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"atHome" ofType:@"xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithData:data] ;
    [xmlparser setDelegate:self];
    [xmlparser parse];
    if (subTitleData.count != 0) {
        [self.tableView reloadData];
    }
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
    subTitleData = [[NSMutableArray alloc] init];
    subLiinkData = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!xMLString)
        xMLString = [[NSMutableString alloc] initWithString:string];
    else
        [xMLString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"title"]) {
       
        _titleInXML =[xMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"title=%@",_titleInXML);
         NSLog(@"title=%@",self.title);
    }
    
    if([_titleInXML isEqualToString:self.title]) {
        
        NSLog(@"coming title=%@",self.title);
        
        if([elementName isEqualToString:@"title"]) {
            title_firstCell = [xMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        
        if([elementName isEqualToString:@"description"]) {
            description_firstCell = [xMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        
        if([elementName isEqualToString:@"subtitle"]) {
             NSLog(@"subtitle coming title=%@",xMLString);
            [subTitleData addObject:[xMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
        if([elementName isEqualToString:@"link"]) {
            [subLiinkData addObject:[xMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
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
    
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        WebViewController *webViewController = segue.destinationViewController;
        subTableViewCell *cell = sender;
        webViewController.title = cell.cellTitle.text;
        webViewController.webFileName = cell.cellWebFileName;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubFirstCell" forIndexPath:indexPath];
        [self setUpCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        subTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subTableCell" forIndexPath:indexPath];
        cell.cellTitle.text = [self.titleArray objectAtIndex:indexPath.row-1];
        cell.subTitle.text = [self.subTitleArray objectAtIndex:indexPath.row-1];
        cell.cellImage.image = [UIImage imageNamed:[self.ImageArray objectAtIndex:indexPath.row-1]];
        
        if(self.webPageArray == NULL || [self.webPageArray count] == 0) {
            
            cell.cellWebFileName = @"Google";
            
        } else {
            
            cell.cellWebFileName = [self.webPageArray objectAtIndex:indexPath.row-1];
            
        }
        
        return cell;
    }
}


- (void)setUpCell:(FirstTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.descriptionLabel.text = self.descriptionSubView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [self heightForFirstTableCell:indexPath]+50;
    } else {
        return 49;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
    {
        return 180.0f;
    } else {
        return 62.0f;
    }
}

- (CGFloat)heightForFirstTableCell:(NSIndexPath *)indexPath {
    
    static FirstTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"SubFirstCell"];
    });
    [self setUpCell:cell atIndexPath:indexPath];
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

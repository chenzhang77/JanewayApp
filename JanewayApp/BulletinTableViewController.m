//
//  BulletinTableViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2016-07-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "BulletinTableViewController.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "MessageTableViewCell.h"
#import "MessageViewController.h"


@interface BulletinTableViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>


@property (nonatomic, strong) UISearchController *searchController;

//@property (nonatomic, strong) ResultsTableViewController *resultsTableController;


//// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *readArray;
@property (nonatomic, strong) NSString* displayTime;
@property (nonatomic) Boolean scrollToLast;
@property (nonatomic) NSInteger lastRow;

@property (nonatomic, strong) NSMutableArray *idSearchResults;
@property (nonatomic, strong) NSMutableArray *timeSearchResults;
@property (nonatomic, strong) NSMutableArray *detailSearchResults;
@property (nonatomic, strong) NSMutableArray *titleSearchResults;
@property (nonatomic, strong) NSMutableArray *readSearchResults;
@property (nonatomic, strong) NSMutableArray *imageSearchResults;


@end

@implementation BulletinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.topItem.title = @"From Your Nurses";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _scrollToLast = 0;
    _idArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    _detailArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _timeArray = [[NSMutableArray alloc] init];
    _readArray = [[NSMutableArray alloc] init];
    _displayTime = @"2010-02-16%2000:00:00";
   
    NSString *path = [self copyDatabaseIfNeeded];
    self.db = [FMDatabase databaseWithPath:path];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(refreshAutoDownload)
                                   userInfo:nil
                                    repeats:YES];

    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [refreshControl addTarget:self action:@selector(refreshDownload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

   
    [self getMessagesFromSqlite];
    [self downloadJsonFile];
    [self initialMessageTimer];
    [self initialSearch];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView setContentOffset:CGPointMake(0, _searchController.searchBar.bounds.size.height)];

    
}
-(void)initialSearch {
    

    //_searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath is called for both tables.
    //self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
}

-(void)initialMessageTimer {
    
    NSString* current = @"2010-02-16 00:00:00";
    NSLog(@"initialMessageTimer ");
    
    
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM lastMessage"];
        FMResultSet *resultSet = [_db executeQuery:sql];
        
        while([resultSet next]) {
            
            NSInteger count = [[resultSet stringForColumn:@"COUNT(*)"] intValue];
            
       
            if (count == 0) {
                
                NSString* sql = @"INSERT INTO lastMessage (time) values (?)";
                NSLog(@"initialMessageTimer = %@",sql);
                
                if ([_db open]) {
                    [_db executeUpdate:sql,current];
                } else {
                    NSLog(@"Fail to open DB !!");
                }
            }
        }
    }
    [_db close];
}

-(void) refreshAutoDownload {
    
    [self downloadJsonFile];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTab)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)updateTab {
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM message where read=0"];
        FMResultSet *resultSet = [_db executeQuery:sql];
        
        while([resultSet next]) {
            
            NSInteger count = [[resultSet stringForColumn:@"COUNT(*)"] intValue];
     
            UITabBarController *myTabBarController = (UITabBarController *) self.tabBarController;
            UITabBar *tabBar = myTabBarController.tabBar;
            UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
            if (count !=0) {
                tabBarItem3.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
           } else {
            [tabBarItem3 setBadgeValue:NULL];
           }
        }
    }
    [_db close];
}



-(void) refreshDownload {
    
    [self downloadJsonFile];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(stopRefresh)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)stopRefresh {
    [self.refreshControl endRefreshing];
}



//-(void) viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//    
//    // restore the searchController's active state
//    if (self.searchControllerWasActive) {
//        self.searchController.active = self.searchControllerWasActive;
//        _searchControllerWasActive = NO;
//        
//        if (self.searchControllerSearchFieldWasFirstResponder) {
//            [self.searchController.searchBar becomeFirstResponder];
//            _searchControllerSearchFieldWasFirstResponder = NO;
//        }
//    }
//
//
//    
//}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text

    NSString *searchText = searchController.searchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(searchText == nil || [searchText isEqualToString: @""]) {
        
        _idSearchResults = _idArray;
        _timeSearchResults = _timeArray;
        _detailSearchResults = _detailArray;
        _titleSearchResults = _titleArray;
        _imageSearchResults = _imageArray;
        _readSearchResults = _readArray;
        [self.tableView reloadData];
    } else {
        
        NSLog(@"updateSearchResultsForSearchController   = %@" , searchText);
        
        _idSearchResults = [[NSMutableArray alloc] init];
        _timeSearchResults = [[NSMutableArray alloc] init];
        _detailSearchResults = [[NSMutableArray alloc] init];
        _titleSearchResults = [[NSMutableArray alloc] init];
        _imageSearchResults = [[NSMutableArray alloc] init];
        _readSearchResults = [[NSMutableArray alloc] init];
        
        //NSArray *allObjects = _titleArray;
        NSInteger totalNumber = [_titleArray count];
        
        for(int i =0; i< totalNumber; i++) {
            
            NSString * titleString = [_titleArray objectAtIndex:i];
            if ([titleString containsString:searchText])
            {
               
                NSLog(@" inner titleString =  %@",titleString);
                [_idSearchResults addObject:[_idArray objectAtIndex:i]];
                [_timeSearchResults addObject:[_timeArray objectAtIndex:i]];
                [_detailSearchResults addObject:[_detailArray objectAtIndex:i]];
                [_titleSearchResults addObject:[_titleArray objectAtIndex:i]];
                [_imageSearchResults addObject:[_imageArray objectAtIndex:i]];
                [_readSearchResults addObject:[_readArray objectAtIndex:i]];
                
            }
        }
        
        [self.tableView reloadData];
    }
    


}


-(void) getMessagesFromSqlite {
    
    NSLog(@"getMessagesFromSqlite");
    if ([_db open]) {

        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM message where time >'%@'ORDER BY time ASC",_displayTime];

        FMResultSet *resultSet = [_db executeQuery:sql];
        while([resultSet next]) {
            NSLog(@"getMessagesFromSqlite insert");
            [_idArray addObject:[resultSet stringForColumn:@"id"]];
            [_titleArray addObject:[resultSet stringForColumn:@"title"]];
            [_detailArray addObject:[resultSet stringForColumn:@"detail"]];
            [_imageArray addObject:[resultSet stringForColumn:@"imageId"]];
            NSString *time = [resultSet stringForColumn:@"time"];

            _displayTime = time;
            [_timeArray addObject:time];
            [_readArray addObject:[resultSet stringForColumn:@"read"]];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
        }
    }
    [_db close];
}

-(void)downloadJsonFile {
    
    NSLog(@"downloadJsonFile");
    
    NSString* current = @"2010-02-16%2000:00:00";
    
    if ([_db open]) {

        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM lastMessage ORDER BY time DESC LIMIT 1"];
        FMResultSet *resultSet = [_db executeQuery:sql];
        while([resultSet next]) {
            current = [resultSet stringForColumn:@"time"];
        }
    }
    [_db close];
    
    NSLog(@"Async JSON: current =%@", current);
    current = [current stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * url = [NSString stringWithFormat:@"http://winemocolnet.ipage.com/janeway/safety/getInfo.php?type=numberofItems&since=%@",current];
    NSLog(@"Async JSON: url %@", url);
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if(data!= NULL) {
                                   json = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:nil];
                            
                                   NSLog(@"Async JSON: %@", json);
                                   NSInteger newMessage = [json[@"count"] intValue];
                                   NSLog(@"newMessage: %ld", newMessage);
                                   if(newMessage > 0) [self downloadMesssageId:current];

                               }
                               
                        

                           }
     
     ];
}

-(void)downloadMesssageId:(NSString*) current {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://winemocolnet.ipage.com/janeway/safety/getInfo.php?type=idarray&since=%@",current]]];
    
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               NSInteger i = [_idArray count] - 1 ;
                               for (NSDictionary *item in json) {
                                   
                                   i++;
                                   
                                   [_idArray addObject:item[@"itemID"]];
                                   [_titleArray addObject:@""];
                                   [_detailArray addObject:@""];
                                   [_imageArray addObject:@""];
                                   [_timeArray addObject:@""];
                                   [_readArray addObject:@""];
                                   
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                   [self.tableView beginUpdates];
                                   [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                   [self.tableView endUpdates];
                                   
                                   
                                   [self downloadMesssageById:item[@"itemID"] atIndex:i];
                                   NSInteger newMessage = [item[@"itemID"] intValue];
                                   NSLog(@"JSON: %ld", (long)newMessage);
                               }
                               
                           }
     ];
}

-(void)downloadMesssageById:(NSString *)id atIndex:(NSInteger) index {
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat :@"http://winemocolnet.ipage.com/janeway/safety/getInfo.php?type=message&id=%@",id]]];
    
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               
                               NSLog(@"test JSON: %@", json);
                               NSString *id = json[@"itemID"];
                               NSString *imageID = json[@"imageId"];
                               NSString *title = json[@"title"] ;
                               NSString *detial = json[@"detail"] ;
                               NSString *time = json[@"time"] ;
                               if(index == [_idArray count]-1){
                                  
                                  _displayTime = time;
                                   NSLog(@"_displayTime = %@",_displayTime);
                               }

                               [_titleArray replaceObjectAtIndex:index withObject:title];
                               [_detailArray replaceObjectAtIndex:index withObject:detial];
                               [_timeArray replaceObjectAtIndex:index withObject:time];
                               [_imageArray replaceObjectAtIndex:index withObject:imageID];
                               
                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_idArray count]-1-index inSection:0];
                               [self.tableView beginUpdates];
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                               [self.tableView endUpdates];

                               NSString* sql = @"INSERT INTO message (id,title,detail,imageId,time) values (?,?,?,?,?)";
                               NSLog(@"downloadMesssageById = %@",sql);
                               if ([_db open]) {
                                    [_db executeUpdate:sql,id,title,detial,imageID,time];
                                   
                                   
                                   NSString *sql_update = [NSString stringWithFormat:@"UPDATE lastMessage set time ='%@' where time < '%@'",time, time];
                                   NSLog(@"sql_update =%@",sql_update);
                                   [_db executeUpdate:sql_update];
                                   
                                   
                               } else {
                                   NSLog(@"Fail to open DB !!");
                               }
                               [_db close];
                           }
     ];
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
    
    if (self.searchController.active)
    {
       return [_idSearchResults count];
    } else {
        return [_idArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BulletinMessage" forIndexPath:indexPath];
    NSString* time;
    NSString *read;
    if (self.searchController.active)
    {
        cell.cellTitle.text =[_titleSearchResults objectAtIndex:[_idSearchResults count]-1 - indexPath.row];
        cell.cellDetail.text =[_detailSearchResults objectAtIndex:[_idSearchResults count]-1 - indexPath.row];
        cell.cellId = [_idSearchResults objectAtIndex:[_idSearchResults count]-1 - indexPath.row];
        time = [_timeSearchResults objectAtIndex:[_idSearchResults count]-1 - indexPath.row];
        read = [_readSearchResults objectAtIndex:[_idSearchResults count]-1 - indexPath.row];
   
    } else {
        cell.cellTitle.text =[_titleArray objectAtIndex:[_titleArray count]-1 - indexPath.row];
        cell.cellDetail.text =[_detailArray objectAtIndex:[_detailArray count]-1 - indexPath.row];
        cell.cellId = [_idArray objectAtIndex:[_titleArray count]-1 - indexPath.row];
        time =[_timeArray objectAtIndex:[_titleArray count]-1 - indexPath.row];
        read = [_readArray objectAtIndex:[_detailArray count]-1 - indexPath.row];
    }
    
    
    
    
    
    NSArray* time_array = [time componentsSeparatedByString: @" "];
    NSString* first_time = [time_array objectAtIndex: 0];
    NSDate *today = [NSDate date];
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:today];
    NSArray* dateString_array = [dateString componentsSeparatedByString: @" "];
    NSString* first_today = [dateString_array objectAtIndex: 0];
    if([first_time isEqualToString:first_today]) {
        NSString* second_time = [time_array objectAtIndex: 1];
        NSString *second_time_sub = [second_time substringToIndex:5];
        cell.cellTime.text = second_time_sub;
        
    } else {
        cell.cellTime.text = first_time;
    }
    cell.cellTimefull.text = time;
    
    NSInteger myInteger = (NSInteger)[read intValue];
    if(myInteger == 1) cell.cellImage.image =  [UIImage imageNamed:@"newMessage"];
    else cell.cellImage.image=  [UIImage imageNamed:@"newMessageNotOpen"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 85;//[self heightForWebTableCell:indexPath]+10;
        
   
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    if ([segue.identifier isEqualToString:@"showMessage"]) {
        NSLog(@"coming into");
        MessageViewController *messageViewController = [segue destinationViewController];
        MessageTableViewCell *cell = sender;
        NSLog(@"coming into  =  %@", cell.cellTimefull.text);
        
        messageViewController.titleString = cell.cellTitle.text;
        messageViewController.detailString = cell.cellDetail.text;
        messageViewController.timeString = cell.cellTime.text;
        //messageViewController.titleMessage.text = cell.cellTitle.text;
        //messageViewController.detailMessage.text = cell.cellDetail.text;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.searchController.active)
    {
        NSInteger myInteger = [_titleSearchResults count]-1 - indexPath.row;
        NSLog(@"myInteger   = %ld", myInteger);
        [_readSearchResults replaceObjectAtIndex:myInteger  withObject:@"1"];
        
        
        NSString* id_change = [_idSearchResults objectAtIndex:myInteger];
        NSInteger total = [_idArray count];
        
        for( int i=0; i< total; i++) {
            
            if([[_idArray objectAtIndex:i] isEqualToString:id_change]) {
                
                 [_readArray replaceObjectAtIndex:i  withObject:@"1"];
                break;
            }
        }
        
    
        
        NSString *id = [_idSearchResults objectAtIndex:myInteger];
        
        if ([_db open]) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE message set read = 1 where id ='%@'",id];
            NSLog(@"coming update sql=%@",sql);
            [_db executeUpdate:sql];
        }
        [_db close];
        
        [self updateTab];
        //[self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
  
        
    } else {
        
        NSInteger myInteger = [_titleArray count]-1 - indexPath.row;
        NSLog(@"myInteger   = %ld", myInteger);
        [_readArray replaceObjectAtIndex:myInteger  withObject:@"1"];
        NSString *id = [_idArray objectAtIndex:myInteger];
        
        
        if ([_db open]) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE message set read = 1 where id ='%@'",id];
            NSLog(@"coming update sql=%@",sql);
            [_db executeUpdate:sql];
        }
        [_db close];
        
        [self updateTab];
        //[self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
       
        
    }
    

    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.searchController.active)
        {
         
            NSLog(@"iself.searchController.activ");
            NSInteger myInteger = [_titleSearchResults count]-1 - indexPath.row;
            NSString *id = [_idSearchResults objectAtIndex:myInteger];
             NSLog(@"here  = %ld", myInteger);
            if ([_db open]) {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM message where id ='%@'",id];
                NSLog(@"coming update sql=%@",sql);
                [_db executeUpdate:sql];
            }
            [_db close];
            
            [_idSearchResults removeObjectAtIndex:myInteger];
            [_titleSearchResults removeObjectAtIndex:myInteger];
            [_detailSearchResults removeObjectAtIndex:myInteger];
            [_timeSearchResults removeObjectAtIndex:myInteger];
            [_imageSearchResults removeObjectAtIndex:myInteger];
            [_readSearchResults removeObjectAtIndex:myInteger];
            
            NSLog(@"here");
 
            NSInteger total = [_idArray count];
            NSLog(@"total = %ld" ,(long)total);
            for( int i=0; i< total; i++) {
                NSLog(@"total  i = %d" ,i);
                
                if([[_idArray objectAtIndex:i] isEqualToString:id]) {
                    
                     NSLog(@"[_idArray objectAtIndex:i]l = %@" ,[_idArray objectAtIndex:i]);
                    
                    
                    [_idArray removeObjectAtIndex:i];
                    [_titleArray removeObjectAtIndex:i];
                    [_detailArray removeObjectAtIndex:i];
                    [_timeArray removeObjectAtIndex:i];
                    [_imageArray removeObjectAtIndex:i];
                    [_readArray removeObjectAtIndex:i];
                    break;
                    
                }
            }
            
            
            
            [self updateTab];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
            
            
        } else {
            
            NSInteger myInteger = [_titleArray count]-1 - indexPath.row;
            NSString *id = [_idArray objectAtIndex:myInteger];
            if ([_db open]) {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM message where id ='%@'",id];
                NSLog(@"coming update sql=%@",sql);
                [_db executeUpdate:sql];
            }
            [_db close];
            
            [_idArray removeObjectAtIndex:myInteger];
            [_titleArray removeObjectAtIndex:myInteger];
            [_detailArray removeObjectAtIndex:myInteger];
            [_timeArray removeObjectAtIndex:myInteger];
            [_imageArray removeObjectAtIndex:myInteger];
            [_readArray removeObjectAtIndex:myInteger];
            
            [self updateTab];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
        }
    }
}


- (NSString*) copyDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"janewayDB.sqlite3"];
        NSLog(@"defaultDBPath : %@",defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    NSLog(@"dbPath : %@",dbPath);
    return dbPath;
}

- (NSString *) getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"janewayDB.sqlite3"];
}

@end

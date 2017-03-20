//
//  AtHomeTableViewController.h
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AtHomeTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,NSXMLParserDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (nonatomic,strong) NSMutableArray *titleData;
@property (nonatomic,strong) NSMutableArray *descriptionData;
@property (nonatomic,strong) NSMutableDictionary *dictionary_onGO;

@property (nonatomic,strong) NSMutableString *xMLString;

@property (nonatomic,strong) NSMutableArray *itemData;
@property (nonatomic,strong) NSMutableArray *subTitleData;
@property (nonatomic,strong) NSMutableArray *subLiinkData;
@property (nonatomic,strong) NSMutableDictionary *dictionary_item;

@end

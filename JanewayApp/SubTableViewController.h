//
//  SubTableViewController.h
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTableViewController : UITableViewController <NSXMLParserDelegate>


@property (nonatomic,strong) NSMutableString *xMLString;


@property (nonatomic,strong) NSMutableArray *subTitleData;
@property (nonatomic,strong) NSMutableArray *subLiinkData;

@property (nonatomic,strong) NSMutableDictionary *dictionary_atHome;
@property (nonatomic,strong) NSString *description_firstCell;
@property (nonatomic,strong) NSString *title_firstCell;
@end

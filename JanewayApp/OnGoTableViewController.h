//
//  OnGoTableViewController.h
//  JanewayApp
//
//  Created by winemocol on 2016-06-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnGoTableViewController : UITableViewController <NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *titleData;
@property (nonatomic,strong) NSMutableArray *descriptionData;
@property (nonatomic,strong) NSMutableArray *linkData;
@property (nonatomic,strong) NSMutableString *xMLString;
@property (nonatomic,strong) NSMutableDictionary *dictionary_onGO;

@end

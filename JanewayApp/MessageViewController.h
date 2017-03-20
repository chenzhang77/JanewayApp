//
//  MessageViewController.h
//  JanewayApp
//
//  Created by cz5670 on 2017-03-17.
//  Copyright © 2017 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *imageMessage;
@property (nonatomic,strong) IBOutlet UILabel *timeMessage;
@property (nonatomic,strong) IBOutlet UILabel *titleMessage;
@property (nonatomic,strong) IBOutlet UITextView *detailMessage;

@property (strong, nonatomic)          NSString *titleString;
@property (strong, nonatomic)          NSString *timeString;
@property (strong, nonatomic)          NSString *detailString;


@property (nonatomic,weak) NSString *imageURL;
@end

//
//  subTableViewCell.h
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *cellImage;
@property (nonatomic,weak) IBOutlet UILabel *cellTitle;
@property (nonatomic,weak) IBOutlet UILabel *subTitle;

@property (nonatomic,strong)NSString *cellWebFileName;

@end

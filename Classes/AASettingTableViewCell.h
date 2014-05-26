//
//  AASettingTableViewCell.h
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AASettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch* onOffSwitch;
@property (weak, nonatomic) IBOutlet UILabel *settingDescription;

@end

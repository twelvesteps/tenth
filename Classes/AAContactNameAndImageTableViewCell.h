//
//  AAContactNameAndImageTableViewCell.h
//  Steps
//
//  Created by tom on 5/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASeparatorTableViewCell.h"

@interface AAContactNameAndImageTableViewCell : AASeparatorTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* contactImageView;
@property (weak, nonatomic) IBOutlet UIButton* editImageButton;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;

@end

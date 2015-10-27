//
//  AnnouncementTableViewCell.m
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/13/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

#import "AnnouncementTableViewCell.h"
#import "Announcement.h"

@interface AnnouncementTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;



@end

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAnnouncement: (Announcement *) msg
{
    self.titleLabel.text = msg.title;
    self.contentLabel.text = msg.content;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [dateFormatter stringFromDate:msg.date];
    
    
}



@end

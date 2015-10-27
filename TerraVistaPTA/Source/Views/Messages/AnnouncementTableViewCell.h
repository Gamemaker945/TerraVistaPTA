//
//  AnnouncementTableViewCell.h
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/13/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Announcement;

@interface AnnouncementTableViewCell : UITableViewCell

- (void) setAnnouncement: (Announcement *) msg;

- (CGFloat)getContentHeight;

@end

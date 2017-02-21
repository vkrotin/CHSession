//
//  CHTableViewCell.h
//  CHSessionSample
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@end

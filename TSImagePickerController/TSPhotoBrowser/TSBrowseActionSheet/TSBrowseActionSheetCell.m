//
//  TSBrowseActionSheetCell.m
//  TSImagePickerController
//
//  Created by tunsuy on 2/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseActionSheetCell.h"

@implementation TSBrowseActionSheetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self generateCell];
    }
    return self;
}

- (void)generateCell {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f];
    [self.contentView addSubview:_bottomLineView];
}

@end

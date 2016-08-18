//
//  JWFolderCell.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWFolderCell.h"

#import "JWFolderModle.h"

@interface JWFolderCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation JWFolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView *tempBottomLine = [UIView new];
    tempBottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self addSubview:tempBottomLine];
    
    JW_WS(this)
    [tempBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(this);
        make.height.equalTo(@0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(this);
        make.left.equalTo(this).with.offset(10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(this);
        make.right.equalTo(this).with.offset(-25);
    }];
}

#pragma mark - Lazy loading
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel)
    {
        self.countLabel = [UILabel new];
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

#pragma mark - Public Method
- (void)configModle:(JWFolderModle *)modle
{
    self.titleLabel.text = modle.folderTitle;
    self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[modle.notes count]];
}

@end

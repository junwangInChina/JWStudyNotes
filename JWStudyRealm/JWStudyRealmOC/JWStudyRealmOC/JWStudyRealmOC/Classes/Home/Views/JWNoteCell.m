//
//  JWNoteCell.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWNoteCell.h"

#import "JWNoteModle.h"

@interface JWNoteCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation JWNoteCell

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
        make.bottom.equalTo(this.mas_centerY);
        make.left.equalTo(this).with.offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(this.mas_centerY);
        make.left.equalTo(this).with.offset(10);
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

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        self.contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

#pragma mark - Public Method
- (void)configModle:(JWNoteModle *)modle
{
    self.titleLabel.text = modle.noteTitle;
    self.contentLabel.text = modle.noteContent;
}


@end

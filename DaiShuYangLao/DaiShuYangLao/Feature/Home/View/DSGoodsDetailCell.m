//
//  DSGoodsDetailCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsDetailCell.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSBrandModel.h"
#import "XHWebImageAutoSize.h"

@implementation DSGoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DSGoodsDetailInfoModel *)model{
    _model = model;
}

@end


@implementation GoodsDetailBaseInfo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //现价
        _currentPriceLabel = [[UILabel alloc]init];
        _currentPriceLabel.font = JXFont(19);
        _currentPriceLabel.textColor = JXColorFromRGB(0xff5000);
        _currentPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_currentPriceLabel];
        
        //原价
        _originalPriceLabel = [[UILabel alloc]init];
        _originalPriceLabel.font = JXFont(11);
        _originalPriceLabel.textColor = JXColorFromRGB(0x3a3737);
        _originalPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_originalPriceLabel];
        
        _companyNameView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _companyNameView.image = ImageString(@"home_goodsdetail_market");
        [self.contentView addSubview:_companyNameView];
        
        //店铺名称
        _companyNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _companyNameLabel.font = JXFont(10);
        _companyNameLabel.textColor = JXColorFromRGB(0xffffff);
        _companyNameLabel.textAlignment = NSTextAlignmentCenter;
        [_companyNameView addSubview:_companyNameLabel];
        
        _membershipGoodsFlag = [[UIImageView alloc]init];
        _membershipGoodsFlag.image = ImageString(@"home_goodsdetail_membershipgoods");
        _membershipGoodsFlag.hidden = YES;
        [self.contentView addSubview:_membershipGoodsFlag];
        
        _goodsTitleLabel = [[UILabel alloc]init];
        _goodsTitleLabel.font = JXFont(15);
        _goodsTitleLabel.textColor = JXColorFromRGB(0x3a3737);
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _goodsTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:_goodsTitleLabel];
        
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xeeeeee);
        [self.contentView addSubview:_seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetUpLayout) {
        
        [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.top.equalTo(self.contentView.mas_top).with.offset(16-kLabelHeightOffset/2.0);
            make.height.mas_equalTo(19+kLabelHeightOffset);
        }];
        
        [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentPriceLabel.mas_right).with.offset(17);
            make.height.mas_equalTo(11+kLabelHeightOffset);
            make.centerY.equalTo(_currentPriceLabel.mas_centerY).with.offset(2);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-58);
        }];
        
        [_companyNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentPriceLabel.mas_left);
            make.height.mas_equalTo(14);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-58);
            make.top.equalTo(_currentPriceLabel.mas_bottom).with.offset(18-kLabelHeightOffset/2.0);
        }];
        
        [_companyNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentPriceLabel.mas_left);
            make.height.mas_equalTo(14);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-58);
            make.top.equalTo(_currentPriceLabel.mas_bottom).with.offset(18-kLabelHeightOffset/2.0);
        }];
        
        [_membershipGoodsFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(68, 14));
            make.left.equalTo(_companyNameView.mas_right).with.offset(15);
            make.centerY.equalTo(_companyNameView);
        }];
        
        [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_companyNameView.mas_left).with.offset(7.5);
            make.right.equalTo(_companyNameView.mas_right).with.offset(-7.5);
            make.height.mas_equalTo(kLabelHeightOffset+10);
            make.centerY.equalTo(_companyNameView.mas_centerY);
        }];
        
        [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentPriceLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).with.offset(-58);
            make.top.equalTo(_companyNameView.mas_bottom).with.offset(9);
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(_goodsTitleLabel.mas_bottom).with.offset(15).priorityLow();
        }];
        
        self.didSetUpLayout = YES;
    }
    [super updateConstraints];
}

- (void)setModel:(DSGoodsDetailInfoModel *)model{
    [super setModel:model];
    self.membershipGoodsFlag.hidden = (model.special.boolValue==1) ? NO:YES;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
    self.originalPriceLabel.attributedText = nil;
    if ([model.originalPrice isNotBlank]) {
        if ([model.originalPrice isEqualToString:@"0"]==NO) {
            self.originalPriceLabel.attributedText = [self addDeleteLineForOrignalPriceString:[NSString stringWithFormat:@"￥%.2f",model.originalPrice.floatValue]];
        }
    }
//    self.originalPriceLabel.text = @"299.00";
    self.goodsTitleLabel.text = model.name;
    self.companyNameLabel.text = model.merchantName;
}

- (NSAttributedString *)addDeleteLineForOrignalPriceString:(NSString *)originalPrice{
    if ([originalPrice isNotBlank]==NO) {
        return nil ;
    }
    NSMutableAttributedString * muAttri = [[NSMutableAttributedString alloc]initWithString:originalPrice];
    
    //设置删除线类型
    [muAttri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0,originalPrice.length)];
    //设置删除线颜色
    [muAttri addAttribute:NSStrikethroughColorAttributeName value:JXColorFromRGB(0x3a3737) range:NSMakeRange(0,originalPrice.length)];
    [muAttri addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0,originalPrice.length)];
    return muAttri;
}

@end

@implementation GoodsDetailNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(14);
        _titleLabel.textColor = JXColorFromRGB(0x929292);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(15);
        _descLabel.textColor = JXColorFromRGB(0x3a3737);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_descLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetUpLayout) {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(14+kLabelHeightOffset);
            make.width.mas_equalTo(33);
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.right.equalTo(self.contentView.mas_right).with.offset(-58);
        }];
        
        self.didSetUpLayout = YES;
    }
    [super updateConstraints];
}


@end

@implementation GoodsDetailImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _detailImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_detailImageView];
        
        _detailsLabel = [[UILabel alloc]init];
        _detailsLabel.font = JXFont(15);
        _detailsLabel.numberOfLines = 0;
        _detailsLabel.textColor = JXColorFromRGB(0X3a3737);
        _detailsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_detailsLabel];
        

        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetUpLayout) {
        
        [_detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        }];
        
        [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        }];
    }
    [super updateConstraints];
}

- (void)setContentModel:(GoodsDetailContentModel *)contentModel{
    _contentModel = contentModel;
    if (contentModel.type.integerValue == 1) {
        self.detailImageView.hidden = YES;
        self.detailsLabel.hidden = NO;
        self.detailsLabel.text = nil;
        if ([contentModel.content isNotBlank]) {
            self.detailsLabel.text = contentModel.content;
        }
    }else{
        self.detailImageView.hidden = NO;
        self.detailsLabel.hidden = YES;
        self.detailImageView.image = nil;
        if ([self.contentModel.content isNotBlank]) {
            [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.content] placeholderImage:ImageString(@"public_longpicture_placeholder") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    /**  缓存image size */
                    [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
                        /** reload */
                        if (result) {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(ds_goodsDetailCell:updateCellHeightWithModel:indexPath:)]) {
                                [self.delegate ds_goodsDetailCell:self updateCellHeightWithModel:_contentModel indexPath:self.indexPath];
                            }
                        }
                    }];
                }
            }];
        }
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
@end



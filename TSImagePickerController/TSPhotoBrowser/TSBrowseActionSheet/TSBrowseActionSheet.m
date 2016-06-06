//
//  TSBrowseActionSheet.m
//  TSImagePickerController
//
//  Created by tunsuy on 2/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseActionSheet.h"
#import "TSBrowseActionSheetCell.h"

#define kBrowseActionSheetSpace 10.0f
#define kBrowseActionSheetCellHeight 44.0f

@interface TSBrowseActionSheet ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) TSBrowseActionSheetDidSelectedAtIndexBlock selectedBlock;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation TSBrowseActionSheet

- (instancetype)initWithTitleArray:(NSArray *)titleArray cancelButtonTitle:(NSString *)cancelTitle didSelectedBlock:(TSBrowseActionSheetDidSelectedAtIndexBlock)selectedBlock {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleArray = titleArray;
        self.cancelTitle  =cancelTitle;
        self.selectedBlock = selectedBlock;
        self.tableViewHeight = ([self.titleArray count] + 1) * kBrowseActionSheetCellHeight + kBrowseActionSheetSpace;
        
        [self generateBrowseActionSheet];
    }
    return self;
}

- (void)generateBrowseActionSheet {
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
    [self addSubview:_maskView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.bounces = NO;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource , UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.titleArray count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return kBrowseActionSheetSpace;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"browseActionSheetCell";
    TSBrowseActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TSBrowseActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.frame = CGRectMake(0, 0, self.ts_Width, kBrowseActionSheetCellHeight);
    cell.bottomLineView.hidden = YES;
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.titleArray[indexPath.row];
        if ([self.titleArray count] > indexPath.row + 1) {
            cell.bottomLineView.frame = CGRectMake(0, kBrowseActionSheetCellHeight - 1, self.ts_Width, 1);
            cell.bottomLineView.hidden = NO;
        }
    }
    else {
        cell.titleLabel.text = self.cancelTitle;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
    }
    [self dismissActionSheet];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissActionSheet];
}

#pragma mark - public method
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.frame = view.bounds;
    self.maskView.frame = view.bounds;
    self.tableView.frame = CGRectMake(0, self.ts_Height, self.ts_Width, self.tableViewHeight);
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.tableView setTs_Y:self.ts_Height - self.tableViewHeight];
                     }];
}

- (void)updateFrame {
    if (self.superview) {
        self.frame = self.superview.bounds;
        self.maskView.frame = self.superview.bounds;
        self.tableView.frame = CGRectMake(0, self.ts_Height - self.tableViewHeight, self.ts_Width, self.tableViewHeight);
        [self.tableView reloadData];
    }
}

#pragma mark - private method
- (void)dismissActionSheet {
    [UIView animateWithDuration: 0.5
                     animations:^{
                         [self.tableView setTs_Y:self.ts_Height];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

@end

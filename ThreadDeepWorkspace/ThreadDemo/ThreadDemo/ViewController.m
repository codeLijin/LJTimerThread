//
//  ViewController.m
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import "ViewController.h"
#import "PushedViewController.h"

#include <pthread.h>

#import "LJTimerThread.h"
@interface ViewController ()<LJThreadDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    LJTimerThread *_thread;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (weak, nonatomic) IBOutlet UISegmentedControl *optationAllSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operationSingleSegment;
@property (weak, nonatomic) IBOutlet UITextField *sourceIDTextField;

// 测试tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite, strong) NSMutableArray<NSString *> *sourceIDs;

@end

@implementation ViewController
- (IBAction)leftItemTapAction:(UIBarButtonItem *)sender {
    
    PushedViewController *firstVc = [[PushedViewController alloc] init];
    [firstVc setThread:_thread];
    [self.navigationController pushViewController:firstVc animated:YES];
}

- (IBAction)rightItemTapAction:(UIBarButtonItem *)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

// 操作全部TimerSource
- (IBAction)operationAllSegmentAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [_thread restartAllTimer];
            break;
        case 1:
            [_thread suspendAllTimer];
            break;
        case 2:
            [_thread cancelAllTimer];
            [self.sourceIDs removeAllObjects];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [sender setSelectedSegmentIndex:sender.numberOfSegments - 1];
}

// 操作单个TimerSource
- (IBAction)operationSingleSegmentAction:(UISegmentedControl *)sender {
    if (!self.sourceIDTextField.text.length && sender.selectedSegmentIndex != 3) return;
    unsigned long long source_id = self.sourceIDTextField.text.longLongValue;
    switch (sender.selectedSegmentIndex) {
        case 0:     // active
            [_thread activeTimer:source_id];
            break;
        case 1:     // suspend
            [_thread suspendTimer:source_id];
            [self.tableView reloadData];
            break;
        case 2:     // drop
            if ([_thread dropTimer:source_id]) {
                [self.sourceIDs removeObject:self.sourceIDTextField.text];
                [self.tableView reloadData];
            }
            break;
        case 3: {   // add
            unsigned long long source_b_id = [_thread addTimerTask:^(LJTaskSourceInfo *latestObj, unsigned long long timer_source_id) {
                NSLog(@"timer block: %llu", timer_source_id);
            } timeInterval:2 runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:(LJTHREADTIMERSTAT_VALID)];
            [self vc_addTimer:source_b_id];
        }
            break;
        default:
            break;
    }
    [sender setSelectedSegmentIndex:sender.numberOfSegments - 1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.operationSingleSegment setSelectedSegmentIndex:self.operationSingleSegment.numberOfSegments - 1];
    [self.optationAllSegment setSelectedSegmentIndex:self.optationAllSegment.numberOfSegments - 1];
    
    _thread = [LJTimerThread threadWithSource:nil callBack:nil];
    // 启动定时器管理
    [_thread start];
    
    // delegate方式添加timer
    unsigned long long timer_source_id = [_thread addTimerDelegate:self timeInterval:3];
    [self vc_addTimer:timer_source_id];
}

- (void)vc_addTimer:(unsigned long long)timer_source_id {
    [self.sourceIDs addObject:[NSString stringWithFormat:@"%llu", timer_source_id]];
    [self.tableView reloadData];
}

#pragma mark - LJThreadDelegate
- (void)threadTimerTriggered:(unsigned long long)timer_source_id latestObj:(LJTaskSourceInfo *)latestObj {
    NSLog(@"block delegate: %llu", timer_source_id);
    
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sourceIDs.count;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:Identifier];
    }
    if (indexPath.section == 0) {
        unsigned long long source_id = [self.sourceIDs[indexPath.row] longLongValue];
        [cell.textLabel setText:self.sourceIDs[indexPath.row]];
        if ([_thread isActive:source_id]) {
            // 激活状态
            [cell.textLabel setTextColor:[UIColor blackColor]];
        } else {
            // 挂起状态
            [cell.textLabel setTextColor:[UIColor redColor]];
        }
    } else {
        [cell.textLabel setText:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [_sourceIDTextField setText:self.sourceIDs[indexPath.row]];
    }
}

#pragma mark - Getter && Setter
- (NSMutableArray<NSString *> *)sourceIDs {
    if (!_sourceIDs) {
        _sourceIDs = [NSMutableArray arrayWithCapacity:10];
    }
    return _sourceIDs;
}

@end

//
//  JWFolderListController.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWFolderListController.h"
#import "JWNoteListController.h"
#import "JWLoginController.h"
#import "JWNavigationController.h"

#import "JWFolderCell.h"

#import "JWFolderModle.h"

static NSString *kFolderCellIdentifier = @"JWFolderViewTableCellIdentifier";

@interface JWFolderListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *folderListTableView;
@property (nonatomic, strong) RLMResults *folderListArray;
@property (nonatomic, strong) RLMNotificationToken *token;

@end

@implementation JWFolderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavButtons];
    
    [self configDatas];
    
    [self configUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavButtons
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addNewFolderAction:)];
}

- (void)configDatas
{
    self.folderListArray = [[JWFolderModle allObjects] sortedResultsUsingProperty:@"folderUpdateDate" ascending:NO];
    
    JW_WS(this)
    self.token = [self.folderListArray addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return ;
        }
        UITableView *tempTable = this.folderListTableView;
        if (!change)
        {
            [tempTable reloadData];
            return;
        }
        
        [tempTable beginUpdates];
        [tempTable deleteRowsAtIndexPaths:[change deletionsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tempTable insertRowsAtIndexPaths:[change insertionsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tempTable reloadRowsAtIndexPaths:[change modificationsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tempTable endUpdates];
        
    }];
}

- (void)configUser
{
    JW_WS(this)
    JWLoginController *loginController = [[JWLoginController alloc] init];
    loginController.complete = ^(BOOL success){
        if (success)
        {
            [this configDatas];
        }
    };
    JWNavigationController *loginNav = [[JWNavigationController alloc] initWithRootViewController:loginController];
    [self.navigationController presentViewController:loginNav animated:YES completion:nil];
}

#pragma mark - Lazy loading
- (UITableView *)folderListTableView
{
    if (!_folderListTableView)
    {
        self.folderListTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                                style:UITableViewStylePlain];
        _folderListTableView.delegate = self;
        _folderListTableView.dataSource = self;
        _folderListTableView.tableFooterView = [UIView new];
        _folderListTableView.backgroundColor = [UIColor whiteColor];
        _folderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_folderListTableView registerClass:[JWFolderCell class]
                     forCellReuseIdentifier:kFolderCellIdentifier];
        [self.view addSubview:_folderListTableView];
        
        JW_WS(this)
        [self.folderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(this.view).insets(UIEdgeInsetsZero);
        }];
    }
    return _folderListTableView;
}

#pragma mark - Action Event
- (void)addNewFolderAction:(id)sender
{
    [self addOrEditNewFolder:nil];
}

- (void)addOrEditNewFolder:(JWFolderModle *)modle
{
    JW_WS(this)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:modle?@"修改":@"新增一个文件夹"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *tempName = [[[alert textFields] firstObject] text];
        if (tempName.length > 0)
        {
            [this addNewFolderWithTitle:tempName modle:modle];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件名";
        textField.text = modle ? modle.folderTitle : @"";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)addNewFolderWithTitle:(NSString *)title modle:(JWFolderModle *)modle
{
    JWFolderModle *tempFolder = [[JWFolderModle alloc] init];
    tempFolder.folderTitle = title;
    
    RLMRealm *tempRealm = [RLMRealm defaultRealm];
    [tempRealm beginWriteTransaction];
    if (modle)
    {
        modle.folderTitle = title;
        modle.folderUpdateDate = [NSDate date];
    }
    else
    {
        [tempRealm addObject:tempFolder];
    }
    [tempRealm commitWriteTransaction];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.folderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:kFolderCellIdentifier
                                                         forIndexPath:indexPath];
    if (self.folderListArray.count > indexPath.row)
    {
        JWFolderModle *tempModle = self.folderListArray[indexPath.row];
        [cell configModle:tempModle];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    JWNoteListController *noteController = [[JWNoteListController alloc] initWithFolder:self.folderListArray[indexPath.row]];
    [self.navigationController pushViewController:noteController animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        JWFolderModle *tempModle = self.folderListArray[indexPath.row];
        RLMRealm *tempRealm = [RLMRealm defaultRealm];
        [tempRealm beginWriteTransaction];
        [tempRealm deleteObjects:tempModle.notes];
        [tempRealm deleteObject:tempModle];
        [tempRealm commitWriteTransaction];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JWFolderModle *tempModle = self.folderListArray[indexPath.row];
        [self addOrEditNewFolder:tempModle];
    }];
    
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JWFolderModle *tempModle = self.folderListArray[indexPath.row];
        [self addNewFolderWithTitle:tempModle.folderTitle modle:tempModle];
    }];
    
    return @[deleteAction,editAction,topAction];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

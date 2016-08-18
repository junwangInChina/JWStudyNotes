//
//  JWNoteListController.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWNoteListController.h"

#import "JWNoteCell.h"

#import "JWFolderModle.h"
#import "JWNoteModle.h"

static NSString *kNoteListCellIdentifier = @"JWNoteListTableCellIdentifier";

@interface JWNoteListController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *noteListTableView;
@property (nonatomic, strong) RLMResults *noteListArray;
@property (nonatomic, strong) RLMNotificationToken *token;
@property (nonatomic, strong) JWFolderModle *folderModle;

@end

@implementation JWNoteListController

- (instancetype)initWithFolder:(JWFolderModle *)modle
{
    self = [super init];
    if (self)
    {
        self.folderModle = modle;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNavButtons];
    
    [self configDatas];
}

- (void)didReceiveMemoryWarning
{
    
}

- (void)configNavButtons
{
    self.title = self.folderModle.folderTitle;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addNewFolderAction:)];
}

- (void)configDatas
{
    self.noteListArray = [self.folderModle.notes sortedResultsUsingProperty:@"noteUpdateDate" ascending:NO];

    JW_WS(this)
    self.token = [self.noteListArray addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return ;
        }
        UITableView *tempTable = this.noteListTableView;
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

#pragma mark - Lazy loading
- (UITableView *)noteListTableView
{
    if (!_noteListTableView)
    {
        self.noteListTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:UITableViewStylePlain];
        _noteListTableView.delegate = self;
        _noteListTableView.dataSource = self;
        _noteListTableView.tableFooterView = [UIView new];
        _noteListTableView.backgroundColor = [UIColor whiteColor];
        _noteListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_noteListTableView registerClass:[JWNoteCell class]
                   forCellReuseIdentifier:kNoteListCellIdentifier];
        [self.view addSubview:_noteListTableView];
        
        JW_WS(this)
        [self.noteListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(this.view).insets(UIEdgeInsetsZero);
        }];
    }
    return _noteListTableView;
}

#pragma mark - Action Event
- (void)addNewFolderAction:(id)sender
{
    [self addOrEditNewFolder:nil];
}

- (void)addOrEditNewFolder:(JWNoteModle *)modle
{
    JW_WS(this)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:modle?@"修改":@"新增一个文件"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *tempName = [[[alert textFields] firstObject] text];
        NSString *tempContent = [[[alert textFields] lastObject] text];
        if (tempName.length > 0 && tempContent.length > 0)
        {
            [this addNewFolderWithTitle:tempName
                                content:tempContent
                                  modle:modle];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件名";
        textField.text = modle ? modle.noteTitle : @"";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
        textField.text = modle ? modle.noteContent : @"";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)addNewFolderWithTitle:(NSString *)title
                      content:(NSString *)content
                        modle:(JWNoteModle *)modle
{
    JWNoteModle *tempNote = [[JWNoteModle alloc] init];
    tempNote.noteTitle = title;
    tempNote.noteContent = content;
    
    RLMRealm *tempRealm = [RLMRealm defaultRealm];
    [tempRealm beginWriteTransaction];
    if (modle)
    {
        modle.noteTitle = title;
        modle.noteContent = content;
        modle.noteUpdateDate = [NSDate date];
        self.folderModle.folderUpdateDate = [NSDate date];
    }
    else
    {
        self.folderModle.folderUpdateDate = [NSDate date];
        [self.folderModle.notes addObject:tempNote];
        [tempRealm addObject:tempNote];
    }
    [tempRealm commitWriteTransaction];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteListCellIdentifier
                                                            forIndexPath:indexPath];
    if (self.noteListArray.count > indexPath.row)
    {
        JWNoteModle *tempModle = self.noteListArray[indexPath.row];
        [cell configModle:tempModle];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        JWFolderModle *tempModle = self.noteListArray[indexPath.row];
        RLMRealm *tempRealm = [RLMRealm defaultRealm];
        /* 两种方式都可以执行，需要Error信息也可以加上Error
        [tempRealm beginWriteTransaction];
        [tempRealm deleteObject:tempModle];
        [tempRealm commitWriteTransaction];
         */
        [tempRealm transactionWithBlock:^{
            [tempRealm deleteObject:tempModle];
        }];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JWNoteModle *tempModle = self.noteListArray[indexPath.row];
        [self addOrEditNewFolder:tempModle];
    }];
    
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JWNoteModle *tempModle = self.noteListArray[indexPath.row];
        [self addNewFolderWithTitle:tempModle.noteTitle
                            content:tempModle.noteContent
                              modle:tempModle];
    }];
    
    return @[deleteAction,editAction,topAction];
}

@end

//
//  KawalReportPageViewController.m
//  PeSankita
//
//  Created by Admin on 4/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalReportPageViewController.h"
#import "KawalCreateReportViewController.h"
#import "ReportPageTableViewCell.h"
#import "EmptyTableViewCell.h"
#import "DataManager.h"
@interface KawalReportPageViewController()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *reportButtonView;

@property (strong, nonatomic) NSArray<NSDictionary*> *submisionArray;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<NSDictionary*>*> *sortedArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation KawalReportPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view from its nib.
    self.tableView.contentInset = UIEdgeInsetsMake(16.0f, 0.0f, 0.0f, 0.0f);
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        [self.tableView addSubview:self.refreshControl];
    }
    self.reportButtonView.layer.cornerRadius = 25.0f;
    self.reportButtonView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    _sortedArray = [NSMutableArray<NSMutableArray<NSDictionary*>*> new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTable];
}
#pragma mark - Data Source
#pragma mark UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.submisionArray count] != 0){
        UINib *cellNib = [UINib nibWithNibName:[ReportPageTableViewCell description] bundle:nil];
        [tableView registerNib:cellNib forCellReuseIdentifier:[ReportPageTableViewCell description]];
        ReportPageTableViewCell *cell = (ReportPageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ReportPageTableViewCell description]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *currentDict = [[self.sortedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.tpsLabel.text = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"notps"]];
        cell.paslon1Label.text = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"count1"]];
        cell.paslon2Label.text = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"count2"]];
        cell.eligibleLabel.text = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"s1"]];
        cell.errorLabel.text = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"n1"]];
        return cell;
    }
    else {
        UINib *cellNib = [UINib nibWithNibName:[EmptyTableViewCell description] bundle:nil];
        [tableView registerNib:cellNib forCellReuseIdentifier:[EmptyTableViewCell description]];
        EmptyTableViewCell *cell = (EmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[EmptyTableViewCell description]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.emptyLabel.text = @"Data tidak ditemukan";
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.submisionArray count] != 0){
        return 75;
    }
    return CGRectGetHeight([UIScreen mainScreen].bounds)- 16.0f - 44.0f;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.submisionArray count] == 0){
        return 1;
    }
    return [self.sortedArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.submisionArray count] == 0){
        return 1;
    }
    return [[self.sortedArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self.submisionArray count] == 0){
        return FLT_MIN;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self.submisionArray count] == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds),60.0f)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame: CGRectMake(10.0, 10.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 20.0f, 40.0f)];
    headerLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    headerLabel.numberOfLines = 0;
    headerLabel.textColor = [UIColor orangeColor];
    NSDictionary *currentDict = [[self.sortedArray objectAtIndex:section] objectAtIndex:0];
    headerLabel.text = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",[currentDict objectForKey:@"nmprov"],[currentDict objectForKey:@"nmkab"],[currentDict objectForKey:@"nmkec"],[currentDict objectForKey:@"nmkel"]];
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSDictionary *currentDict = [[self.sortedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    KawalCreateReportViewController *kawalCreateReportViewController = [[KawalCreateReportViewController alloc]init];
    kawalCreateReportViewController.type = KawalCreateReportViewControllerTypePreview;
    kawalCreateReportViewController.filledDictionary = currentDict;
    kawalCreateReportViewController.imageURL = [NSString stringWithFormat:@"https:///%@",[currentDict objectForKey:@"c1"]];
    [self.navigationController pushViewController:kawalCreateReportViewController animated:YES];
}

- (IBAction)closeButtonDidTapped:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshTable {
    //TODO: refresh your data
    [DataManager callAPIGetSubmisionWithSuccess:^(NSDictionary *success) {
        [self.sortedArray removeAllObjects];
        self.submisionArray = [success objectForKey:@"data"];
        for (NSInteger i = 0 ;  i < [self.submisionArray count] ; i++){
            if([self.sortedArray count] == 0){
                NSMutableArray<NSDictionary*> *arr = [NSMutableArray<NSDictionary*> new];
                [arr addObject:[self.submisionArray objectAtIndex:i]];
                [self.sortedArray addObject:arr];
            }
            else {
                for(NSInteger j = 0 ;  j < [self.sortedArray count] ; j++){
                    NSMutableArray<NSDictionary*> *array = [self.sortedArray objectAtIndex:j];
                    for(NSInteger k = 0; k < [array count] ; k++){
                        NSDictionary *d = [array objectAtIndex:k];
                        if([[d objectForKey:@"idkel"] isEqualToString:[[self.submisionArray objectAtIndex:i] objectForKey:@"idkel"]]){
                            [array addObject:[self.submisionArray objectAtIndex:i]];
                            break;
                        }
                        else {
                            NSMutableArray *arr = [NSMutableArray new];
                            [arr addObject:[self.submisionArray objectAtIndex:i]];
                            [self.sortedArray addObject:arr];
                            break;
                        }
                    }
                    break;
                }
            }
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pengambilan Data Gagal"
                                                                                 message:error.localizedDescription
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertViewStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                            [self.refreshControl endRefreshing];}];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (IBAction)reportButtonDidTapped:(id)sender{
    KawalCreateReportViewController *kawalCreateReportViewController = [[KawalCreateReportViewController alloc]init];
    kawalCreateReportViewController.type = KawalCreateReportViewControllerTypeDefault;
    [self.navigationController pushViewController:kawalCreateReportViewController animated:YES];
}
@end

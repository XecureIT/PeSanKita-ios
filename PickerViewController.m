//
//  PickerViewController.m
//  PeSankita
//
//  Created by Admin on 8/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "PickerViewController.h"
#import "EmptyTableViewCell.h"

@interface PickerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Data Source
#pragma mark UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UINib *cellNib = [UINib nibWithNibName:[EmptyTableViewCell description] bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:[EmptyTableViewCell description]];
    EmptyTableViewCell *cell = (EmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[EmptyTableViewCell description]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *cityName = [[self.masterArray objectAtIndex:indexPath.row] objectForKey:@"nama"];
    cell.emptyLabel.text = cityName;
    self.titleLabel.text = self.titleString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.masterArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSString *cityName = [[self.masterArray objectAtIndex:indexPath.row] objectForKey:@"nama"];
    NSString *cityID = [[self.masterArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    if([self.delegate respondsToSelector:@selector(itemTappedPickerViewControllerDelegate:pickedID:pickedName:)]){
        [self.delegate itemTappedPickerViewControllerDelegate:self.type pickedID:cityID pickedName:cityName];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)closeButtonDidTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.tableView.contentOffset.y < -100){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end

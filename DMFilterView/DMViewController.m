//
//  DMViewController.m
//  DMFilterView
//
//  Created by Thomas Ricouard on 19/04/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "DMViewController.h"

@interface DMViewController ()
@end

@implementation DMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    _filterView = [[DMFilterView alloc]initWithStrings:@[@"ABC", @"Filter 1", @"Filter 2"] containerView:self.view];
    [self.filterView attachToContainerView];
    [self.filterView setDelegate:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Default style";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"Images style";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"Colors style";
    }
    else{
      cell.textLabel.text = @"SCROOOOL";
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.filterView applyDefaultStyle];
        [self.filterView setDraggable:YES];
    }
    else if (indexPath.row == 1){
        [self.filterView setSelectedItemBackgroundImage:[UIImage imageNamed:@"tabbar_select"]];
        [self.filterView setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
        UIColor *mColor = [UIColor colorWithRed:240/255.0
                                          green:130/255.0
                                           blue:76/255.0
                                          alpha:1.0];
        [self.filterView setTitlesColor:mColor];
        [self.filterView setTitlesFont:[UIFont systemFontOfSize:14]];
        [self.filterView setTitleInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
        [self.filterView setDraggable:YES];
    }
    else if (indexPath.row == 2){
        [self.filterView setSelectedItemTopBackgroundColor:[UIColor grayColor]];
        [self.filterView setSelectedItemTopBackroundColorHeight:5];
        [self.filterView setSelectedItemBackgroundColor:[UIColor lightGrayColor]];
        [self.filterView setBackgroundColor:[UIColor underPageBackgroundColor]];
        [self.filterView setTitlesFont:[UIFont boldSystemFontOfSize:19]];
        [self.filterView setTitlesColor:[UIColor blueColor]];
        [self.filterView setTitleInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.filterView setDraggable:NO];
    }
}

#pragma mark - ScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.filterView hide:YES animated:YES animationCompletion:^{
        
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.filterView hide:NO animated:YES animationCompletion:^{

    }];
}

#pragma mark - FilterVie delegate
- (void)filterView:(DMFilterView *)filterView didSelectedAtIndex:(NSInteger)index
{
    NSLog(@"%d", index);
}

- (CGFloat )filterViewSelectionAnimationSpeed:(DMFilterView *)filterView
{
    //return the default value as example, you don't have to implement this delegate
    //if you don't want to modify the selection speed
    //Or you can return 0.0 to disable the animation totally
    return kAnimationSpeed;
}


@end

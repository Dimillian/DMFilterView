//
//  DMViewController.m
//  DMFilterView
//
//  Created by Thomas Ricouard on 19/04/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "DMViewController.h"

@interface DMViewController ()
{
    BOOL _isColors;
}
@end

@implementation DMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isColors = NO;
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
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isColors){
        [self.filterView setSelectedBackgroundImage:[UIImage imageNamed:@"tabbar_select"]];
        [self.filterView setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
        UIColor *mColor = [UIColor colorWithRed:240/255.0
                                          green:130/255.0
                                           blue:76/255.0
                                          alpha:1.0];
        [self.filterView setTitlesColor:mColor];
        [self.filterView setTitlesFont:[UIFont systemFontOfSize:14]];
    }
    else{
        [self.filterView setSelectedTopBackgroundColor:[UIColor grayColor]];
        [self.filterView setSelectedTopBackroundColorHeight:5];
        [self.filterView setSelectedBackgroundColor:[UIColor lightGrayColor]];
        [self.filterView setBackgroundColor:[UIColor underPageBackgroundColor]];
        [self.filterView setTitlesFont:[UIFont boldSystemFontOfSize:19]];
        [self.filterView setTitlesColor:[UIColor blueColor]];
    }
    _isColors =! _isColors;
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


@end

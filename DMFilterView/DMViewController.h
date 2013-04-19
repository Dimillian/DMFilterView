//
//  DMViewController.h
//  DMFilterView
//
//  Created by Thomas Ricouard on 19/04/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMFilterView.h"

@interface DMViewController : UIViewController <DMFilterViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DMFilterView *filterView;
@property (nonatomic, strong) UITableView *tableView;
@end

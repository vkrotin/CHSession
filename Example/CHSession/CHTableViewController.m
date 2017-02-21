//
//  CHTableViewController.m
//  CHSessionSample
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "CHTableViewController.h"

#import "CHSessionManager.h"

@interface CHTableViewController ()

@property(nonatomic, strong) NSArray *cats;

@end

@implementation CHTableViewController

static NSString *reuseIndex = @"imageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cats = [NSArray arrayWithObjects:
                 @"https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_960_720.png",
                 @"https://cdn.pixabay.com/photo/2016/11/03/22/14/mieze-1796423_960_720.jpg",
                 @"https://cdn.pixabay.com/photo/2013/09/12/08/06/cat-181608_960_720.jpg",
                 @"https://cdn.pixabay.com/photo/2015/11/15/20/21/cat-1044750_960_720.jpg",
                 @"https://cdn.pixabay.com/photo/2016/11/28/15/23/cat-1865263_960_720.jpg",
                 @"https://cdn.pixabay.com/photo/2016/05/07/17/47/cat-1377906_960_720.jpg",
                 nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cats.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndex forIndexPath:indexPath];
    cell.catImageView.image = nil;
    
    __weak __typeof(self)wself = self;
    [CHSessionManager getUrl:self.cats[indexPath.row]
                  parameters:nil
             timeoutInterval:HTTP_DEFAULT_TIMEOUT
                  cachPolicy:CHRequestReturnCacheDataElseLoad
           completionHandler:^(NSData *data, NSURLResponse *response){
               CHTableViewCell *loadCell =  [wself.tableView cellForRowAtIndexPath:indexPath];
               loadCell.catImageView.image = [UIImage imageWithData:data];
           }errorHandler:^(NSError *error){
               NSLog(@"error %@",error);
           }];
    
    [CHSessionManager headUrl:self.cats[indexPath.row]
                   parameters:nil
              timeoutInterval:HTTP_DEFAULT_TIMEOUT
            completionHandler:^(NSDictionary *headDictionary, NSURLResponse *responce){
                NSLog(@"Head: %@", headDictionary.debugDescription );
                CGFloat fSize = [headDictionary[@"Content-Length"] floatValue];
                CHTableViewCell *loadCell =  [wself.tableView cellForRowAtIndexPath:indexPath];
                loadCell.sizeLabel.text= [NSString stringWithFormat:@"File size is : %.3f MB",fSize/1024.0f/1024.0f];
            }errorHandler:nil];
    

    
   

    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

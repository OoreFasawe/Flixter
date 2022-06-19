//
//  GridViewController.m
//  Flixter
//
//  Created by Oore Fasawe on 6/17/22.
//
#import "GridViewController.h"
#import "GridCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface GridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.gridView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)fetchMovies {
    self.filteredData = self.movies;
    
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
    }];
    
    [networkAlert addAction:tryAgainAction];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=dd212af52115fe9e7e8656d91cd531d8"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //Alert UI
               [self presentViewController:networkAlert animated:YES completion:^{
                   //optional code for what happens after the alert controller has finished presenting
               }];
           }
           else {
               // TODO: Get the array of movies
               [self.activityIndicator stopAnimating];
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               //print dictionary
               //NSLog(@"%@", dataDictionary);

               // TODO: Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               self.filteredData = dataDictionary[@"results"];
               //NSLog(@"%@", self.movies);
               // TODO: Reload your table view data
               [self.gridView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];

    
    NSDictionary *movie = self.movies[indexPath.row];
   
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterImage.image = nil;
    [cell.posterImage setImageWithURL:posterURL];
    
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    UICollectionViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.gridView indexPathForCell:cell];
    // Pass the selected object to the new view controller.
    NSDictionary *dataToPass = self.filteredData[myIndexPath.item];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end

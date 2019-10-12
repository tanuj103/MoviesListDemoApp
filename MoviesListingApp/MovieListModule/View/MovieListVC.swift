//
//  MovieListVC.swift
//  MoviesListingApp
//
//  Created by tanuj on 12/10/19.
//  Copyright © 2019 Tanuj Sharma. All rights reserved.
//

import UIKit
private let TitleText           = "Movies List";
private let NoDataFoundText     = "No data found";
private let MovieCellIdentifier = "movieCollectionViewCell";

class MovieListVC: UIViewController, UISearchBarDelegate {
    
    struct CellSize {
        static let lineSpacing: CGFloat = 10
        static let itemSpacing: CGFloat = 10
        static let edgeInset:   CGFloat = 10
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    public var movieListModel: MoviesListModel?
    private var moviesDataSource: Array? = []
    private var totalNoOfPages : NSInteger = 0
    private var pageNo : NSInteger = 1
    private var pageSize : NSInteger = 10
    private var searchingText : String = ""
    var isLoading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI()
    {
        self.title = TitleText
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearchWithText(searchText: searchBar.text!)
    }
    
    // MARK: - Private Method
    private func performSearchWithText(searchText: String) {
        searchingText = searchText
        apiCallToFetchMoviesListForSearchText(searchText: searchText, page: pageNo)
    }
    
    // MARK: - Api to fetch movies list for search Method
    func apiCallToFetchMoviesListForSearchText(searchText : String , page : NSInteger)
    {
        //Initiate FetchMoviesListForSearchText Api Call
        MovieListViewModel().apiCallForMoviesList(using: searchText, pageNumber : page) {(dataSource) in
            self.moviesDataSource?.append(contentsOf: dataSource.search)
            if self.moviesDataSource?.count == 0
            {
                DispatchQueue.main.async {
                    self.showAlertOnNoDataAvailable()
                }
                return
            }
            
            //Calculate total number of pages
            let value : CGFloat = CGFloat(Int(dataSource.totalResults)!/self.pageSize)
            self.totalNoOfPages = NSInteger(ceil(value))
            DispatchQueue.main.async(execute: { () -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.title = searchText
                self.collectionView.reloadData()
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String)
    {
        if searchText.isEmpty {
            resetSearch()
        }
    }
    
    func resetSearch()
    {
        self.title = TitleText
        searchingText = ""
        totalNoOfPages = 0
        pageNo = 1
        isLoading = false
        self.moviesDataSource?.removeAll()
        self.collectionView.reloadData()
    }
    
    private func showAlertOnNoDataAvailable() {
        let alertController = UIAlertController(title: nil, message: NoDataFoundText , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension MovieListVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieCount = self.moviesDataSource?.count else {
            return 0
        }
        return movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            let searchMovie = self.moviesDataSource![indexPath.row] as! Search
            cell.configUIWithData(searchdataSource: searchMovie)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - 40) * 0.33,
                      height: (collectionView.bounds.size.height) * 0.33)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CellSize.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CellSize.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CellSize.edgeInset,
                            left: CellSize.edgeInset,
                            bottom: CellSize.edgeInset,
                            right: CellSize.edgeInset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && self.moviesDataSource!.count > 0 && scrollView.contentOffset.y > 0
        {
            if isLoading == false
            {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.loadMoreData()
                }
            }
        }
    }
    
    func loadMoreData()
    {
        if (pageNo <= totalNoOfPages)
        {
            pageNo += 1;
            apiCallToFetchMoviesListForSearchText(searchText: searchingText, page: pageNo)
        }
    }
}


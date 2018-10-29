//
//  CountryPickerViewController.swift
//  Planet
//
//  Created by Mikael Konutgan on 08/07/16.
//  Copyright © 2016 kWallet GmbH. All rights reserved.
//

import UIKit
fileprivate let idCell = "CountryCell"
public class CountryPickerViewController: UITableViewController {
    public weak var delegate: CountryPickerViewControllerDelegate?
    
    public var currentCountry: Country? {
        return countryDataSource.currentCountry
    }
    
    public var showsCallingCodes = true
    
    public var showsCancelButton = true
    
    public var locale: Locale {
        get {
            return countryDataSource.locale
        }
        
        set(newLocale) {
            countryDataSource = CountryDataSource(locale: newLocale, countryCodes: countryCodes)
            tableView.reloadData()
        }
    }
    
    public var countryCodes: [String] {
        get {
            return countryDataSource.countryCodes
        }
        
        set(newCountryCodes) {
            countryDataSource = CountryDataSource(locale: locale, countryCodes: newCountryCodes)
            tableView.reloadData()
        }
    }
    
    fileprivate var countryDataSource = CountryDataSource()
    
    fileprivate var searchResults: [Country]?
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate func findCountry(_ indexPath: IndexPath) -> Country {
        if let searchResults = searchResults {
            return searchResults[(indexPath as NSIndexPath).row]
        } else {
            return countryDataSource.find(indexPath)
        }
    }
    
    @objc fileprivate dynamic func cancelButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.countryPickerViewControllerDidCancel(self)
    }
    
//    fileprivate func tableFooterView() -> UIView {
//        let tableFooterView = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
//        tableFooterView.text = NSLocalizedString("Icons by emojione.com", comment: "Icons by emojione.com")
//        tableFooterView.textAlignment = .center
//        tableFooterView.textColor = UIColor(white: 0.500, alpha: 1.0)
//        tableFooterView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
//
//        return tableFooterView
//    }

    deinit {
        // workaround for http://www.openradar.me/22250107 which results in a warning like:
        // [Warning] Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7fdecbe03580>)
        searchController.loadViewIfNeeded()
    }
}

// MARK: UIViewController

public extension CountryPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if showsCancelButton {
            let action = #selector(cancelButtonTapped)
            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backmenu"), style: .plain, target: self, action: action)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        navigationController?.navigationBar.barTintColor = FGColor.primary
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
//        navigationItem.titleView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true

        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        self.tableView.register(UINib.init(nibName: idCell, bundle: nil), forCellReuseIdentifier: idCell)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = FGColor.primary
        
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

public extension CountryPickerViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = searchResults {
            return 1
        } else {
            return countryDataSource.sectionCount()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = searchResults {
            return searchResults.count
        } else {
            return countryDataSource.count(section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! CountryCell
        
        let country = findCountry(indexPath)
        
        cell.flag?.image = country.image
        cell.lblName?.text = country.name + "(\(country.isoCode))"
//
//        if showsCallingCodes {
//            cell.detailTextLabel?.text = country.callingCode
//        }
//
       cell.lblCode.text = country.callingCode
        cell.contentView.backgroundColor = FGColor.primary
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.countryPickerViewController(self, didSelectCountry: findCountry(indexPath))
    }
}

// MARK: UISearchResultsUpdating

extension CountryPickerViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text , !text.isEmpty {
            searchResults = countryDataSource.find(text)
        } else {
            searchResults = nil
        }
        
        tableView.reloadData()
    }
}

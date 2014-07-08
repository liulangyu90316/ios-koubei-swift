//
//  IndexViewController.swift
//  koubei
//
//  Created by michael on 14-7-1.
//  Copyright (c) 2014 michael. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView : UICollectionView
    
    @IBOutlet var favCollectionView : UICollectionView
    
    var tradeListData: NSArray! = []
    var favListData: NSArray! = []
    var localeCH:NSDictionary = Locale.getLocaleCH()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
//        super.viewDidLoad()
        // registerClass
        // TODO why can't get property from collectioncell when use registerClass???
        self.collectionView.registerClass(TradeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        var nibName = UINib(nibName: "TradeCollectionViewCell", bundle:nil)
//        self.collectionView.registerNib(nibName, forCellWithReuseIdentifier: "cell")
        self.favCollectionView.registerClass(FavCollectionViewCell.self, forCellWithReuseIdentifier: "favCell")
        // get trades
        getTradeList()
        getFavList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get trade data
    func getTradeList() {
        var url: NSString! = String(Conf.getRequestHost()) + "/getsitetradeajax"
        let request = YYHRequest(url: NSURL(string: url))
        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                // handle error
                println("error")
            }
            else if let actualResponse = response {
                var httpResponse = response as NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                    if obj.objectForKey("status") as NSObject == 0 {
                        var renderFunc = self.renderTradeList
                        dispatch_async(dispatch_get_main_queue()) {
                            renderFunc(obj.objectForKey("data") as NSArray)
                        }
                    }
                }
            }
        }
    }
    
    // render TradeList
    func renderTradeList(data: NSArray) {
        self.tradeListData = data
        self.collectionView.reloadData()
    }
    
    // get fav list
    func getFavList() {
        var url: NSString! = String(Conf.getRequestHost()) + "/getfavoratesitesajax"
        let request = YYHRequest(url: NSURL(string: url))
        request.loadWithCompletion {response, data, error in
            if let actualError = error {
                // handle error
                println("error")
            }
            else if let actualResponse = response {
                var httpResponse = response as NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                    if obj.objectForKey("status") as NSObject == 0 {
                        var renderFunc = self.renderFavList
                        dispatch_async(dispatch_get_main_queue()) {
                            renderFunc(obj.objectForKey("data") as NSArray)
                        }
                    }
                }
            }
        }
    }
    
    // render FavList
    func renderFavList(data: NSArray) {
        self.favListData = data
        self.favCollectionView.reloadData()
    }
    
    // protocol
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.collectionView) {
            return self.tradeListData.count
        }
        else if (collectionView == self.favCollectionView) {
            return self.favListData.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        if (collectionView == self.collectionView) {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as TradeCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            // TODO why label not ok in TradeCollectionViewCell???
            var label = UILabel(frame: CGRectMake(4, 4, 54, 20))
            var obj = self.tradeListData[indexPath.row] as NSDictionary
            var name = obj["tname"] as NSString
            label.text = "\(name)"
            label.textColor = UIColor.blueColor()
            label.font = UIFont.systemFontOfSize(13)
            cell.addSubview(label)
            println(cell.titleLabel)
            
            // why???
//            cell.titleLabel.text = "XXXXXXXX"
            
            return cell
        }
        else if (collectionView == self.favCollectionView) {
            println("praise")
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("favCell", forIndexPath: indexPath) as FavCollectionViewCell
            var obj = self.favListData[indexPath.row] as NSDictionary
            cell.backgroundColor = UIColor.whiteColor()
            var siteName = UILabel(frame: CGRectMake(4, 4, 120, 25))
            siteName.text = obj["sitename"] as NSString
            var webSite = UILabel(frame: CGRectMake(4, 30, 120, 20))
            webSite.text = obj["website"] as NSString
            var praise = UILabel(frame: CGRectMake(4, 50, 50, 20))
            var pr = obj["praise"] as NSNumber
            praise.text = "\(pr)%"
            praise.tintColor = UIColor.orangeColor()
            var haoPing = UILabel(frame: CGRectMake(45, 50, 50, 20))
            haoPing.text = localeCH["GOOD_COMT"] as NSString
            
            var addComt = UIButton(frame: CGRectMake(0, 80, 134, 25))
            addComt.setTitle(localeCH["WANNA_COMT"] as NSString, forState: UIControlState.Normal)
            addComt.tintColor = UIColor.blueColor()
            addComt.backgroundColor = UIColor.lightGrayColor()
            
//            addComt.addTarget(AnyObject, action: ".action", forControlEvents: UIControlEvents.)
            
            
            cell.addSubview(siteName)
            cell.addSubview(webSite)
            cell.addSubview(praise)
            cell.addSubview(haoPing)
            cell.addSubview(addComt)
            
            return cell
        }
        return nil
    }
    
    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
//         Get the new view controller using [segue destinationViewController].
//         Pass the selected object to the new view controller.
        println(123123)
    }


}

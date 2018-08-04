//
//  ViewController.swift
//  Vocabulary
//
//  Created by Tang Jiasheng on 2018/7/24.
//  Copyright © 2018 Jiasheng Tang. All rights reserved.
//

import UIKit

var vocabs = [Vocab]()
var chapters = [[Dictionary<String, Any>]]()
var topics = [Dictionary<String, Any>]()

let fontName = "Milliard-BookDEMO"

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var topicsCollectionView: UICollectionView!
    
    var completedTopics = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        settingsButton.tintColor = UIColor.white
        topicsCollectionView.backgroundColor = UIColor.clear
        
        // CollectionView layout
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        topicsCollectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: "TopicCell")
//        topicsCollectionView.register(UICollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        topicsCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        // Parse vocabs.json to chapters
        if chapters.isEmpty {
            parseJSON()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // TODO: sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: topicsCollectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            reusableview = header
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let flowLayout = topicsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let side = self.view.frame.width / 4
            flowLayout.itemSize = CGSize(width: side, height: side)
            flowLayout.minimumLineSpacing = 30
        }
        
        
        let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicCollectionViewCell
        
        let topic = chapters[indexPath.section][indexPath.row]
        print(cell.topicTitleLabel)
        cell.topicTitleLabel.text = topic["title"] as? String
        cell.topicTitleLabel.textColor = UIColor.white
        cell.topicTitleLabel.alpha = 0.7
        
        cell.topicIcon.image = UIImage(named: (topic["image"] as? String)!)
        if completedTopics.contains(cell.topicTitleLabel.text!) {
            cell.topicIcon.tintColor = UIColor.yellow
        } else {
            cell.topicIcon.tintColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Topic Unavailable
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuiz" {
            let cell = sender as! TopicCollectionViewCell
            let indexPath = topicsCollectionView.indexPath(for: cell)
            let rvc = segue.destination as! RootViewController
            rvc.topic = topics[indexPath!.row]
        }
    }
    
}





//
//  ViewController.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import UIKit
import HPElectronicProgramGuide

class ViewController: UIViewController {
    // MARK: Constants
    private let totalSecondsOfDay = 86400
    
    // MARK: - Properties
    private lazy var playIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "play")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .white
        return icon
    }()
    private lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var collectionView: HPEpgCollectionView = {
        let collectionView = HPEpgCollectionView(channelCellSize: CGSize(width: 100, height: 40),
                                                 timeCellSize: CGSize(width: 160, height: 40))
        collectionView.epgDelegate = self
        collectionView.epgDataSource = self
        collectionView.register(cellClass: ChannelCell.self)
        collectionView.register(cellClass: TimeIntervalCell.self)
        collectionView.register(cellClass: ProgramCell.self)
        collectionView.register(cellClass: DateCell.self)
        collectionView.register(cellClass: TimeIndicatorCell.self)
        collectionView.backgroundColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        
        return collectionView
    }()
    private let sampleData = EpgSampleData()
    private var channels: [String] {
        return sampleData.channels
    }
    private var programs: [[EpgProgram]] {
        return sampleData.programs
    }
    private var timer: Timer?
    private var counter = 0
    private var currentSelectedProgramIndex: (channelIndex: Int, programIndex: Int)?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        runTimer()
    }
    // MARK: - Private methods
    
    private func setupViews() {
        self.view.addSubview(playerView)
        playerView.addSubview(playIcon)
        self.view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        playerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        playIcon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func updateTime() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let secondOfDay = seconds + 60 * minutes + 3600 * hour
        
        collectionView.setTimeIndicator(at: secondOfDay)
        let timeIndicatorCell = collectionView.cellForItem(at: collectionView.getTimeIndicatorIndexPath()) as? TimeIndicatorCell
        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        timeIndicatorCell?.updateTimeLabel("\(hourStr):\(minuteStr)")
    }
    
}
extension ViewController: HPEpgCollectionViewDataSource {
    func numberOfChannel() -> Int {
        return channels.count
    }
    
    func numberOfProgram(inChannel channelIndex: Int) -> Int {
        return programs.get(channelIndex)?.count ?? 0
    }
    
    func cellForCrossView(indexPath: IndexPath) -> HPEpgCollectionViewCell {
        let cell = collectionView.dequeue(cellClass: DateCell.self, forIndexPath: indexPath)
        cell.setTitle("Today")
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func cellForTime(timeInterval: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell {
        let cell = collectionView.dequeue(cellClass: TimeIntervalCell.self, forIndexPath: indexPath)
        
        let hour = timeInterval / 3600
        let remainingTimeInterval = timeInterval - hour * 3600
        let minute = remainingTimeInterval / 60
        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        cell.setTitle("\(hourStr):\(minuteStr)")
        
        return cell
    }
    
    func cellForChannel(at index: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell {
        let cell = collectionView.dequeue(cellClass: ChannelCell.self, forIndexPath: indexPath)
        cell.setTitle(channels[index])
        cell.setShouldHighlight(currentSelectedProgramIndex?.channelIndex == index)
        return cell
    }
    
    func cellForProgram(at index: Int, inChannel channelIndex: Int, indexPath: IndexPath) -> HPProgramCollectionViewCell {
        let cell = collectionView.dequeue(cellClass: ProgramCell.self, forIndexPath: indexPath)
        cell.setTitle(programs.get(channelIndex)!.get(index)!.programName)
        let shouldBorder = currentSelectedProgramIndex?.channelIndex == channelIndex && currentSelectedProgramIndex?.programIndex == index
        cell.setShouldHighlight(currentSelectedProgramIndex?.channelIndex == channelIndex,
                                border: shouldBorder)
        return cell
    }
    
    func cellForTimeIndicator(indexPath: IndexPath) -> HPTimeIndicatorContainerCell {
        let cell = collectionView.dequeue(cellClass: TimeIndicatorCell.self, forIndexPath: indexPath)
        return cell
    }
    
    func startSecondOfProgram(at index: Int, inChannel channelIndex: Int) -> Int {
        return programs.get(channelIndex)?.get(index)?.fromSecond ?? 0
    }
    
    func endSecondOfProgram(at index: Int, inChannel channelIndex: Int) -> Int {
        return programs.get(channelIndex)?.get(index)?.toSecond ?? 0
    }
}

extension ViewController: HPEpgCollectionViewDelegate {
    func didScrollToTimeRange(from: Int, to: Int) {
        
    }
    
    func didSelectChannel(at index: Int, indexPath: IndexPath) {
        print(channels[index])
    }
    
    func didSelectProgram(at index: Int, inChannel channelIndex: Int, indexPath: IndexPath) {
        currentSelectedProgramIndex = (channelIndex, index)
        collectionView.reloadData()
    }
}

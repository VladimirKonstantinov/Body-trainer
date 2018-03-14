//
//  vcExerciseDetailTableViewController.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 13.12.16.
//  Copyright © 2016 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcExerciseDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TimerCountDownProtocol {

    public weak var okAction:UIAlertAction?

    @IBOutlet weak var sgmSources: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var reorderButton: UIBarButtonItem!
    
    @IBOutlet weak var vExerciseInfo: UIView!
    @IBOutlet weak var lExerciseItemsTotalTime: UILabel!
    @IBOutlet weak var lExerciseTotalTime: UILabel!
    

    var delegate:vcGroupTableViewController!
    var exercise:Exercise!
    var currentTimer:TimerCountdown?
    var exerciseTimer:Timer?
    
    let strDefaultExerciseItemsTotalTimeString="Длительность упражнения: 00:00:00"
    let strDefaultExerciseTotalTimeString="Затрачено времени: 00:00:00"
    
    private var selectedRow:Int?
    private var infoView:UIView!
    
    lazy var blockExerciseTotalTimePased:(_ theTimer:Timer)->Void = {[unowned self] _ in
            let timerCount=Date.init()
            let calendar=Calendar.current
            let deltaComponents = calendar.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: self.exercise.timeStarted!, to:timerCount )
            var dateTime:Date
            let timeFormatter=DateFormatter()
            timeFormatter.locale=NSLocale.current
            timeFormatter.dateFormat = "HH:mm:ss"
            //        if (deltaComponents.hour!*60*60+deltaComponents.minute!*60+deltaComponents.second!)>=beginTimerInterval {
            //            return getTimerStringFromInterval(beginTimerInterval)
            //        }
            dateTime=timeFormatter.date(from: "\(deltaComponents.hour!):\(deltaComponents.minute!):\(deltaComponents.second!)")!
            self.lExerciseTotalTime.text="Затрачено времени: "+timeFormatter.string(from: dateTime)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.prompt=exercise.name
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedRow=nil
        switch self.sgmSources.selectedSegmentIndex {
        case 0:
            return exercise.exerciseExecutions.count
        case 1:
            return exercise.exerciseInformation.count
        default:
            return 0
        }
    }

    
    func configureDetailCellAtIndex(_ indexPath:IndexPath, atTableView tableView:UITableView) -> UITableViewCell {
        if sgmSources.selectedSegmentIndex==0 {
        let item=exercise.exerciseExecutions[indexPath.row]
        let cellIdentifier=String("\(item)").components(separatedBy: ".").last!
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        switch item {
        case is ExerciseTimebreak:
            configureTimebreakCell(cell as! vcExerciseTimebreakCell, withTimebreak: item as! ExerciseTimebreak)
        case is ExerciseExecution:
            configureExecutionCell(cell as! vcExerciseExecutionCell, withExecution: item as! ExerciseExecution)
        default: break
        }
        return cell
        }
        else {
            let item=exercise.exerciseInformation[indexPath.row]
            let cellIdentifier=String("\(item)").components(separatedBy: ".").last!
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            switch item {
            case is InformationText:
                configureInformationTextCell(cell as! vcInformationTextCell, withInformation: item as! InformationText)
            case is InformationImage:
//                configureInformationImageCell(cell as! vcInformationImageCell, withInformation: item as! InformationImage, forController:self, withSelector:#selector(imageTappedAction), andDissmissSelector:#selector(dissmissFullscreenAction))
                configureInformationImageCell(cell as! vcInformationImageCell, withInformation: item as! InformationImage, forController:self, withSelector:#selector(imageTappedAction))
            case is InformationVideo:
                configureInformationVideoCell(cell as! vcInformationVideoCell, withInformation: item as! InformationVideo, forController:self, withSelector:#selector(videoTappedAction))
            default: break
            }
            return cell
        }
   }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureDetailCellAtIndex(indexPath, atTableView:tableView)
    }

    func getCellHeightAtIndex(_ indexPath:IndexPath, atTableView tableView:UITableView) -> CGFloat {
        if sgmSources.selectedSegmentIndex==0 {
        let item=exercise.exerciseExecutions[indexPath.row]
        switch item {
        case is ExerciseTimebreak:
            return 125
        case is ExerciseExecution:
            return 136
        default: return 100
        }
        }
            else {
                let item=exercise.exerciseInformation[indexPath.row]
                switch item {
                case is InformationText:
                    if (item as! InformationText).textDescription.characters.count>getAverageInformationTextCellHeight() {
                        return (item as! InformationText).expanded ? UITableViewAutomaticDimension : CGFloat(getAverageInformationTextCellHeight())
                    }
                    else {
                      return UITableViewAutomaticDimension
                    }
                case is InformationImage:
                        return 280
                case is InformationVideo:
                        return 280
                default: return 100
                }
            }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sgmSources.selectedSegmentIndex == 1 {
            let item=exercise.exerciseInformation[indexPath.row]
            switch item {
            case is InformationText:
                (item as! InformationText).expanded = !(item as! InformationText).expanded
                tableView.reloadRows(at: [indexPath], with: .automatic)
            default: break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeightAtIndex(indexPath, atTableView:tableView)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeightAtIndex(indexPath, atTableView:tableView)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if fromIndexPath.row==to.row {
            return
        }
        moveDetailRowForItem(exercise, withType: sgmSources.selectedSegmentIndex, atIndex: fromIndexPath.row, toIndex: to.row);
        self.tableView.reloadData()

    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    @IBAction func addItemPress(_ sender: AnyObject) {
        switch sgmSources.selectedSegmentIndex {
        case 0:
            addExerciseItem(exercise, forController: self)
        case 1:
            addInformationItem(exercise, forController: self)
        default:
            break
        }
    }
    
    
    @IBAction func orderPress(_ sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.addButton.isEnabled = !self.tableView.isEditing
    }

    
    @IBAction func backButtonPress(_ sender: UIBarButtonItem) {
        if self.currentTimer != nil {
            let currentItem=self.currentTimer!.ownerIndex!
            switch self.currentTimer!.ownerParent.exerciseExecutions[currentItem] {
            case is ExerciseExecution:
                deactivateTimebreakCounter(self.currentTimer!, forTableView: self.tableView)
            case is ExerciseTimebreak:
                deactivateExecutionCounter(self.currentTimer!, forTableView: self.tableView)
            default:
                break
            }
            TimerCountDownComplete(itemIndex:currentItem)
        }
        
        if self.exerciseTimer != nil {
            self.exerciseTimer?.invalidate()
            self.exerciseTimer=nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sgmSourcesValueChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex==1 || (self.currentTimer==nil)) {
            self.addButton.isEnabled=true
            self.reorderButton.isEnabled=true
        }
            else {
                self.addButton.isEnabled=false
                self.reorderButton.isEnabled=false
            }
        setExerciseViewVisible()
        self.tableView.reloadData()
    }

    @IBAction func bTimeBreakCompletePress(_ sender: UIButton) {
        let cell=sender.superview?.superview as! vcExerciseTimebreakCell
        let indexPath=self.tableView.indexPath(for: cell)
        defer {
            setExerciseViewVisible()
        }
        if self.tableView.isEditing {
            return
        }
        if self.currentTimer != nil {
        deactivateTimebreakCounter(self.currentTimer!, forTableView: self.tableView)
        }
        TimerCountDownComplete(itemIndex: (indexPath?.row)!)
        activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
    }
    @IBAction func bTimebreakStartPress(_ sender: UIButton) {
        let cell=sender.superview?.superview as! vcExerciseTimebreakCell
        let indexPath=self.tableView.indexPath(for: cell)
        defer {
            setExerciseViewVisible()
        }
        if !beforeTimerActivate() {
            return
        }
        if ((indexPath?.row)!) != 0 {
            afterExerciseItemComplete(forItemIndex: ((indexPath?.row)!)-1)
        }
        if self.currentTimer != nil {
            deactivateTimebreakCounter(self.currentTimer!, forTableView: self.tableView)
        }
        self.currentTimer=activateTimebreakCounterForExercise(exercise, withIndexPath: indexPath!, forTableView: self.tableView, withLabelCount: cell.lTimeInterval, withDelegate: self)
        activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
    }

    func TimerCountDownStep() {
        lExerciseItemsTotalTime.text="Длительность упражнения: "+exercise.strItemsTotalPassedTime
        if sgmSources.selectedSegmentIndex==0 {
        if let currTimer=self.currentTimer {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath.init(row: (currTimer.ownerIndex)!, section: 0)], with: .none)
        self.tableView.endUpdates()
        }
        }
    }

    func afterExerciseItemComplete(forItemIndex itemIndex:Int) {
        updateLastActivity(exercise)
        setCompleteExerciseItemToIndex(itemIndex, forExercise: self.exercise)
        lExerciseItemsTotalTime.text="Длительность упражнения: "+exercise.strItemsTotalPassedTime
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }

    func afterExerciseItemPaused(forItemIndex itemIndex:Int) {
        setPauseExerciseItemToIndex(itemIndex, forExercise: self.exercise)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath.init(row: itemIndex, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        
    }

    func afterExerciseItemResumed(forItemIndex itemIndex:Int) {
        setResumeExerciseItemToIndex(itemIndex, forExercise: self.exercise)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath.init(row: itemIndex, section: 0)], with: .none)
        self.tableView.endUpdates()
        
    }

    func afterExerciseComplete() {
        updateLastActivity(exercise)
        setCompleteExercise(self.exercise)
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }

    func TimerCountDownComplete(itemIndex:Int) {
        afterExerciseItemComplete(forItemIndex: itemIndex)
        self.currentTimer=nil
        afterTimerDeactivate()
    }
    
    func TimerCountDownPaused(itemIndex:Int) {
        afterExerciseItemPaused(forItemIndex: itemIndex)
    }

    func TimerCountDownResumed(itemIndex:Int) {
        afterExerciseItemResumed(forItemIndex: itemIndex)
    }

    func beforeTimerActivate()->Bool {
        if self.tableView.isEditing {
            return false
        }
        self.addButton.isEnabled=false
        self.reorderButton.isEnabled=false
        return true
    }
    
    func afterTimerDeactivate() {
        self.addButton.isEnabled=true
        self.reorderButton.isEnabled=true
    }
    
    @IBAction func bExecutionStartPress(_ sender: UIButton) {
        let cell=sender.superview?.superview as! vcExerciseExecutionCell
        let indexPath=self.tableView.indexPath(for: cell)
        defer {
            setExerciseViewVisible()
        }
        if !beforeTimerActivate() {
            return
        }
        if self.currentTimer != nil {
            if ((self.currentTimer?.ownerIndex) != (indexPath?.row)!) {
                deactivateTimebreakCounter(self.currentTimer!, forTableView: self.tableView) }
            else {
                if !beforeTimerActivate() {
                    return
                }
                resumeExecutionCounter(self.currentTimer!, forTableView: self.tableView)
                activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
                return
            }
        }
        if ((indexPath?.row)!) != 0 && self.currentTimer == nil {
            afterExerciseItemComplete(forItemIndex: ((indexPath?.row)!)-1)
        }
            self.currentTimer=activateExecutionCounterForExercise(exercise, withIndexPath: indexPath!, forTableView: self.tableView, withLabelCount: cell.lStringOfExecutionType, withDelegate: self)
        activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
    }
    
    @IBAction func bExecutionStopPress(_ sender: UIButton) {
        if self.currentTimer != nil {
            pauseExecutionCounter(self.currentTimer!, forTableView: self.tableView)
        }
    }
    
    @IBAction func bExecutionCompletePress(_ sender: UIButton) {
        let cell=sender.superview?.superview as! vcExerciseExecutionCell
        let indexPath=self.tableView.indexPathForRow(at: cell.center)
        defer {
            setExerciseViewVisible()
        }
        if self.tableView.isEditing {
            return
        }
        if self.currentTimer != nil {
            deactivateExecutionCounter(self.currentTimer!, forTableView: self.tableView)
        }
        TimerCountDownComplete(itemIndex: (indexPath?.row)!)
        activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
    }

    @IBAction func bExpandTextInformationPress(_ sender: UIButton) {
        let cell=sender.superview?.superview as! vcInformationTextCell
        let indexPath=self.tableView.indexPathForRow(at: cell.center)
        if self.tableView.isEditing {
            return
        }
        doExpandCollapseTextInformation(forItemIndex: indexPath!, ofExercise:exercise, forController:self)
    }
    

    
    /// Обработка жеста "Long press" на строке
    ///
    /// - parameter row: Номер строки
    func actionForLongPressAtRow(_ row:Int) {
        selectedRow=row
        if sgmSources.selectedSegmentIndex==0 {
        openLongPressExerciseItemDialog(forController: self, owner: exercise, forRow: row)
        }
        else {
            openLongPressInformationItemDialog(forController: self, owner: exercise, forRow: row)
        }
    }

    /// Обработка жеста "Long press"
    ///
    /// - parameter longPress: Данные жеста
    func longPressRecognizer(longPress:UILongPressGestureRecognizer) {
        if (!self.tableView.isEditing)&&(longPress.state==UIGestureRecognizerState.began) && (self.currentTimer == nil || sgmSources.selectedSegmentIndex==1) {
            let locationPoint=longPress.location(in: self.tableView)
            guard let indexPathPoint=self.tableView.indexPathForRow(at: locationPoint) else {
                return
            }
            actionForLongPressAtRow(indexPathPoint.row)
        }
    }

    /// Подготовка View к работе
    func prepareView() {
        let longPress=UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressRecognizer))
        self.tableView.addGestureRecognizer(longPress)
        self.clearsSelectionOnViewWillAppear = false
        infoView = vExerciseInfo
        if self.exercise.passedItemsTotalTimerInterval==0 {
        lExerciseItemsTotalTime.text=strDefaultExerciseItemsTotalTimeString
        }
        else {
            TimerCountDownStep()            
        }
        if self.exercise.timeStarted == nil {
            lExerciseTotalTime.text=strDefaultExerciseTotalTimeString }
        else {
            activateExerciseTimer(&exerciseTimer, forExercise: exercise, withBlock: blockExerciseTotalTimePased)
            blockExerciseTotalTimePased(self.exerciseTimer!)
        }
        setExerciseViewVisible()
    }
    
    
    /// Уведомление о выборе фотографии
    ///
    /// - parameter picker: Picker
    /// - parameter info:   Информация о выбранной фотографии
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedItem:Any!
        let imgNew=info[UIImagePickerControllerOriginalImage] as? UIImage
        let imgEdited=info[UIImagePickerControllerEditedImage] as? UIImage
        if  imgNew != nil || imgEdited != nil {
            // User choice Photo
            let img = imgEdited==nil ? imgNew : imgEdited
            if selectedRow==nil {
                selectedItem=addInformationImageCollection(forExercise: exercise)
            }
            else {
                selectedItem=(exercise.exerciseInformation[selectedRow!] as! InformationImage)
            }
                        setSelectedImage(img!, toItem:selectedItem) {_ in
                            self.tableView.beginUpdates()
                            if self.selectedRow==nil {
                                let index=IndexPath.init(row: self.exercise.exerciseInformation.count-1, section: 0)
                                self.tableView.insertRows(at: [index], with: .fade)
                            }
                            else {
                                let index=IndexPath.init(row: self.selectedRow!, section: 0)
                                self.tableView.reloadRows(at: [index], with: .fade)
                            }
                            self.tableView.endUpdates()
            }
        }
        else {
            let videoNewURL=info[UIImagePickerControllerMediaURL]  as? NSURL
            let videoOldURL=info[UIImagePickerControllerReferenceURL]  as? NSURL
            if  videoOldURL != nil || videoNewURL != nil  {
            // User choice Video
            let isNewVideo = videoOldURL==nil
                let videoPath=videoNewURL?.path!
                if isNewVideo {
                    let isCompatible=UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath!)
                    if isCompatible {
                        UISaveVideoAtPathToSavedPhotosAlbum(videoPath!, nil, nil, nil)
                    }
                }
                if selectedRow==nil {
                    selectedItem=addInformationVideoCollection(forExercise: exercise)
                }
                else {
                    selectedItem=(exercise.exerciseInformation[selectedRow!] as! InformationVideo)
                }
                setSelectedVideo(videoNewURL!, toItem:selectedItem) {_ in
                    self.tableView.beginUpdates()
                    if self.selectedRow==nil {
                        let index=IndexPath.init(row: self.exercise.exerciseInformation.count-1, section: 0)
                        self.tableView.insertRows(at: [index], with: .fade)
                    }
                    else {
                        let index=IndexPath.init(row: self.selectedRow!, section: 0)
                        self.tableView.reloadRows(at: [index], with: .fade)
                    }
                    self.tableView.endUpdates()
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Уведомление об отмене выбора фотографии
    ///
    /// - parameter picker: Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setExerciseViewVisible() {
        if sgmSources.selectedSegmentIndex==0 && isExerciseStarted(exercise) {
            self.tableView.tableHeaderView=infoView
        }
        else {
            self.tableView.tableHeaderView=nil
        }
        
    }
    
    @IBAction func pressCompleteExercise(_ sender: AnyObject) {
        if !beforeTimerActivate() {
            return
        }
        deactivateExerciseTimer(&exerciseTimer, forController:self ) {_ in
            lExerciseItemsTotalTime.text=strDefaultExerciseItemsTotalTimeString
            lExerciseTotalTime.text=strDefaultExerciseTotalTimeString
            self.exercise.passedItemsTotalTimerInterval=0
            self.exercise.strItemsTotalPassedTime="00:00:00"
            self.exercise.maxItemsTotalPassedTime=nil
        }
        if self.currentTimer != nil {
            deactivateTimebreakCounter(self.currentTimer!, forTableView: self.tableView)
        }
        afterTimerDeactivate()
        afterExerciseComplete()
        setExerciseViewVisible()
    }
    
    
    // MARK: - Notifications
    
    
    /// Уведомление об изменении содержимого текстового поля
    ///
    /// - parameter textField: Текстовое поле
    func textFieldTextDidChangeNotification(textField:UITextField) {
        guard let charactersCount=textField.text?.characters.count else {
            return
        }
        self.okAction?.isEnabled=charactersCount>0;
    }
    
 func imageTappedAction(sender:UITapGestureRecognizer) {
//    let locationPoint=sender.location(in: self.tableView)
//    guard let indexPathPoint=self.tableView.indexPathForRow(at: locationPoint) else {
//        return
//    }
//    let item=exercise.exerciseInformation[indexPathPoint.row]
    let imageFullscreenView=storyboard?.instantiateViewController(withIdentifier: "ImageFullscreenView")
    imageFullscreenView?.modalTransitionStyle = .coverVertical
    (imageFullscreenView as! vcImageFullscreen).img=(sender.view as! UIImageView).image
    self.present(imageFullscreenView!, animated: true, completion: nil)
    }

//    func dissmissFullscreenAction(sender:UIImageFullscreenTapGestureRecognizer) {
//        sender.view?.removeFromSuperview()
//    }

    func videoTappedAction(sender:UIVideoTapGestureRecognizer) {
        sender.showVideo(sender: sender)
    }
    
}

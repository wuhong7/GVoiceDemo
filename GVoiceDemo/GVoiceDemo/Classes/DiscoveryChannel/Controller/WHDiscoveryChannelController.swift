//
//  WHDiscoveryChannelController.swift
//  GVoiceDemo
//
//  Created by 盖特 on 2017/7/5.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class WHDiscoveryChannelController: WHBaseViewController {
    
    var roomID : String! = ""
    var openID : String! = ""
    var pollTimer : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化语音
        
        //初始化UI
        setupUI()
        initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initialization(){
        
        GVGCloudVoice.sharedInstance()?.delegate = self
        GVGCloudVoice.sharedInstance()?.setAppInfo("1820742892", withKey: "6ea185de355e565fe23818e228d1cde5", andOpenID: "abc")
        GVGCloudVoice.sharedInstance()?.initEngine()
        GVGCloudVoice.sharedInstance()?.setServerInfo("udp://cn.voice.gcloudcs.com:10001")

    }

    
    
    // MARK: 懒加载属性
    lazy var roomIDTextField : UITextField = {
        let roomIDTextField = UITextField()
        roomIDTextField.placeholder = "请输入房间id"
        roomIDTextField.borderStyle = .roundedRect
        return roomIDTextField
    }()
    
    lazy var openIDTextField : UITextField = {
        let openIDTextField = UITextField()
        openIDTextField.placeholder = "用户id"
        openIDTextField.borderStyle = .roundedRect
        return openIDTextField
    }()
    
    lazy var joinRoomBtn : UIButton = {
        let joinRoomBtn = UIButton()
        joinRoomBtn.addTarget(self, action: #selector(onJoinRoom(btn:)), for: .touchUpInside)
        joinRoomBtn.setTitle("进入房间", for: .normal)
        joinRoomBtn.setTitle("离开房间", for: .selected)
        joinRoomBtn.setBackgroundImage(UIImage(named: "vpnbuttonBlue"), for: .normal)
        joinRoomBtn.setBackgroundImage(UIImage(named: "vpnbuttonRed"), for: .selected)
        return joinRoomBtn
    }()
    
    lazy var OpenMicBtn : UIButton = {
        let OpenMicBtn = UIButton()
        OpenMicBtn.addTarget(self, action: #selector(onOpenMic(btn:)), for: .touchUpInside)
        OpenMicBtn.setTitle("打开mic", for: .normal)
        OpenMicBtn.setTitle("关闭mic", for: .selected)
        OpenMicBtn.setBackgroundImage(UIImage(named: "vpnbuttonBlue"), for: .normal)
        OpenMicBtn.setBackgroundImage(UIImage(named: "vpnbuttonRed"), for: .selected)
        return OpenMicBtn
    }()
    
    lazy var OpenSpeakerBtn : UIButton = {
        let OpenSpeakerBtn = UIButton()
        OpenSpeakerBtn.addTarget(self, action: #selector(onOpenSpeaker(btn:)), for: .touchUpInside)
        OpenSpeakerBtn.setTitle("打开声音", for: .normal)
        OpenSpeakerBtn.setTitle("关闭声音", for: .selected)
        OpenSpeakerBtn.setBackgroundImage(UIImage(named: "vpnbuttonBlue"), for: .normal)
        OpenSpeakerBtn.setBackgroundImage(UIImage(named: "vpnbuttonRed"), for: .selected)

        return OpenSpeakerBtn
    }()
    

}

// MARK: - UI布局
extension WHDiscoveryChannelController{
    
    fileprivate func setupUI(){
        
        view.backgroundColor = UIColor.white
        
        //添加房间输入
        view.addSubview(roomIDTextField)
        roomIDTextField.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(100)
            make.height.equalTo(50)
        }

        //用户id输入
        view.addSubview(openIDTextField)
        openIDTextField.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(roomIDTextField.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        
        //进入房间btn
        view.addSubview(joinRoomBtn)
        joinRoomBtn.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(openIDTextField.snp_bottom).offset(20)
            make.height.equalTo(60)
        }

        //打开mac
        view.addSubview(OpenMicBtn)
        OpenMicBtn.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(joinRoomBtn.snp_bottom).offset(20)
            make.height.equalTo(60)
        }

        //打开声音
        view.addSubview(OpenSpeakerBtn)
        OpenSpeakerBtn.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(OpenMicBtn.snp_bottom).offset(20)
            make.height.equalTo(60)
        }



        
        
    }

    
    
    
    
}


// MARK: - 用户交互
extension WHDiscoveryChannelController{
    
    
    /// 进入房间
    @objc fileprivate func onJoinRoom(btn : UIButton){
        
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            
            roomID = roomIDTextField.text
            openID = openIDTextField.text
 
            guard let roomID = roomID ,let openID = openID  else {
                warnning(msg: "房间名 或者 用户ID 不能为空")
                btn.isSelected = false
                return
            }
            
            
            PrintLog(message: " \n roomID:\(roomID) \n openID:\(openID)")
            
            
            if let openIDcString = openID.cString(using: .utf8) , let roomIDcString = roomID.cString(using: .utf8) {
                GVGCloudVoice.sharedInstance()?.setAppInfo("1820742892", withKey: "6ea185de355e565fe23818e228d1cde5", andOpenID: openIDcString)
                GVGCloudVoice.sharedInstance()?.setMode(RealTime)
                GVGCloudVoice.sharedInstance()?.joinTeamRoom(roomIDcString, timeout: 18000)
                pollTimer = Timer.scheduledTimer(timeInterval: 1.000/15, target: self, selector:#selector(pollData), userInfo: nil, repeats: true)
            }
            
            
  
        }else{
            
            if let roomIDcString = roomID.cString(using: .utf8) , roomID != ""{
                
                GVGCloudVoice.sharedInstance()?.quitRoom(roomIDcString, timeout: 18000)
                
            }
            
            
    
        }
    
    }
    //拉取数据
    @objc fileprivate func pollData(){
        GVGCloudVoice.sharedInstance()?.poll()
    }
    
    /// 打开/关闭麦克风
    @objc fileprivate func onOpenMic(btn : UIButton){
        
        btn.isSelected = !btn.isSelected
        
        if (btn.isSelected) {
            
            GVGCloudVoice.sharedInstance()?.openMic()
            
        } else {
            
            GVGCloudVoice.sharedInstance()?.closeMic()
    
        }
        
        
    }
    
    /// 打开/关闭声音
    @objc fileprivate func onOpenSpeaker(btn : UIButton){
        
        btn.isSelected = !btn.isSelected
        
        if (btn.isSelected) {

            GVGCloudVoice.sharedInstance()?.openSpeaker()

        } else {
            
            GVGCloudVoice.sharedInstance()?.closeSpeaker()
            
        }

        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    //弹出提示框
    fileprivate func warnning(msg:String){
        let alert = UIAlertController(title: "警告", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }


}

extension WHDiscoveryChannelController : GVGCloudVoiceDelegate{
    
    func onJoinRoom(_ code: GCloudVoiceCompleteCode, withRoomName roomName: UnsafePointer<Int8>?, andMemberID memberID: Int32) {
        
        if code == GV_ON_JOINROOM_SUCC {
            warnning(msg: "成功进入房间")
        }else{
            warnning(msg: "进入房间失败:\(code)")
        }
        
        
    }
    
    func onStatusUpdate(_ status: GCloudVoiceCompleteCode, withRoomName roomName: UnsafePointer<Int8>?, andMemberID memberID: Int32) {
        
        PrintLog(message: "状态更新：\(status)\n 房间名：\(String(describing: roomName))\n成员ID：\(memberID)")
    
    }
    
    func onQuitRoom(_ code: GCloudVoiceCompleteCode, withRoomName roomName: UnsafePointer<Int8>?) {
        
        if code == GV_ON_QUITROOM_SUCC {
            warnning(msg: "成功退出房间")
        }else{
            warnning(msg: "退出房间失败:\(code)")
        }
    }
    

    func onMemberVoice(_ members: UnsafePointer<UInt32>?, withCount count: Int32) {
        PrintLog(message: "状态更新：\(String(describing: members))\n 音量：\(count)")
    }
    
    func onUploadFile(_ code: GCloudVoiceCompleteCode, withFilePath filePath: UnsafePointer<Int8>?, andFileID fileID: UnsafePointer<Int8>?) {
        
    }

    
    func onDownloadFile(_ code: GCloudVoiceCompleteCode, withFilePath filePath: UnsafePointer<Int8>?, andFileID fileID: UnsafePointer<Int8>?) {
        
    }
    
    func onPlayRecordedFile(_ code: GCloudVoiceCompleteCode, withFilePath filePath: UnsafePointer<Int8>?) {
        
    }
    
    func onApplyMessageKey(_ code: GCloudVoiceCompleteCode) {
        
    }

    func onSpeech(toText code: GCloudVoiceCompleteCode, withFileID fileID: UnsafePointer<Int8>?, andResult result: UnsafePointer<Int8>?) {
        
    }
    
    func onRecording(_ pAudioData: UnsafePointer<UInt8>?, withLength nDataLength: UInt32) {
        
    }
    
    func onStreamSpeech(toText code: GCloudVoiceCompleteCode, withError error: Int32, andResult result: UnsafePointer<Int8>?) {
        
    }
    
    
}















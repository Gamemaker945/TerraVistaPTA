//
//  AnnouncementController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class AnnouncementController
{
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    class var sharedInstance : AnnouncementController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AnnouncementController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AnnouncementController()
        }
        return Static.instance!
    }
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    private var msgArray: [Announcement]
    private var activeMsg: Announcement?
    
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        msgArray = [Announcement]()
        activeMsg = nil
        
        if (CommonDefines.DEBUG_APP) {
            DEBUG_LOAD();
        }
    
    }
    
    func reset ()
    {
        activeMsg = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Announcements
    //------------------------------------------------------------------------------
    func fetchAnnouncements ()
    {
    // TODO - Backend Fetch
    }
    
    
    func addAnnouncement (msg:Announcement)
    {
        // TODO - Backend Add
        msgArray.append(msg);
    }
    
    func getAnnouncementByID (ID: Int) -> Announcement?
    {
        for var i=0; i < msgArray.count; i++
        {
            let msg:Announcement = msgArray[i]
            if (msg.parseID == ID) {
                return msg;
            }
        }
        return nil;
    }
    
    func getAnnouncementAtIndex (index: Int) -> Announcement?
    {
        return msgArray[index];
    }
    
    func countAnnouncements () -> Int
    {
        return msgArray.count;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    func setActiveMsg (msg: Announcement)
    {
        activeMsg = msg;
    }
    
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    func DEBUG_LOAD ()
    {
        let ann1:Announcement = Announcement();
        ann1.parseID = 1;
        ann1.title = "Google";
        ann1.content = "http://www.google.com";
        ann1.date = NSDate();
        msgArray.append(ann1);
        
        let ann2:Announcement = Announcement();
        ann2.parseID = 2;
        ann2.title = "Apple";
        ann2.content = "http://www.apple.com";
        ann2.date = NSDate();
        msgArray.append(ann2);
        
        let ann3:Announcement = Announcement();
        ann3.parseID = 3;
        ann3.title = "Long Text";
        ann3.content = "Nibh officiis accusamus no mei, iudico euismod te eam, denique intellegam ut usu. Sit legimus quaerendum cotidieque cu, in detracto vivendum sententiae mea. Verterem patrioque ad est, sit in consul commune, has case fabulas dolorum ei. Inermis detraxit platonem vel at, sensibus adversarium quo ex. An minim civibus qui, no summo semper corrumpit per, vel et scripta vocibus. Ut vel sententiae ullamcorper, sit ut debet audiam. Per illud persequeris te. Eu pro probo idque detracto, eu elitr abhorreant conclusionemque sit. In corpora indoctum per. Vis agam fastidii corrumpit ut.Gloriatur temporibus eum in, an duo tation dolorem percipitur. Euismod legendos voluptaria his ne, eu simul timeam ius, officiis erroribus urbanitas quo ut. Tibique consetetur te mel, eam at harum vivendum, at ius mazim fuisset omittantur. Autem ipsum cum ad, pro ex bonorum omnesque persecuti. Reque iudico philosophia an has. Modus laudem epicurei vix in. Pri graeci nusquam torquatos ex, vis tota congue ne. No vis sumo simul principes, eius velit salutandi te usu. Quaeque legimus pro te. Dico verterem eos an.Percipit indoctum principes nec id. Id eam insolens cotidieque, ex qui omnes animal salutatus. Vel dissentias definitiones et, vis et graeci nostro nostrum, illum atqui evertitur mei ne. Audiam aliquam mea ad.Velit malorum perfecto ex usu. Dicit affert volutpat ne est, quas congue mel ne. Has debet feugiat ancillae ut, id eum pericula referrentur. Sea splendide elaboraret cu, natum delenit vituperatoribus ei mel. Ne praesent explicari eum, quo ea purto atqui postea. Ei sumo impedit gubergren vel, no bonorum albucius suavitate usu, ad vix sonet nonumes scaevola.Tantas nonumy vel ea. Minim ornatus id nam, est altera aliquando ex. Paulo postea vis no. Nostro aliquip accusata eum eu. Decore tractatos ius at. Paulo melius quo no. An sit apeirian periculis percipitur, mel eu ferri nonumy.Clita labitur nusquam sea ex, ea vel graecis elaboraret. Esse libris omnium vis an, et commodo eloquentiam per. Cu omittam iudicabit adversarium eam, soleat admodum vis an. Quas labore et est, nec no mucius elaboraret, libris detracto ea eos. Christian"
        ann3.date = NSDate();
        msgArray.append(ann3);
    }
}
from download_process import DownloadProcess
from threading import Thread
from multiprocessing import Process
from utils import is_download_link , open_file , is_int , find, pda, pdCMD
import clipboard
import pickle
from queue import  Queue
from PySide2.QtCore import QObject, Slot, Signal,QCoreApplication
from program_settings import SettingsManager
import os


class FileDownloader(QObject):

    def __init__(self):
        QObject.__init__(self)
        self.processes = list()
        self.matched = list()
        self.cof = 0 #cof means completed or failed
        self.nas =0 #non active scheduled
        self.pending = Queue()
        self.scheduled = Queue()
        #SettingsManager.SETTINGS["System"]["Downloads"]["SimDown"] = 3
        self.auto_shutdown = False
        self._load_wrapped()

    downloadInfo_returned = Signal('QVariant', arguments=['request_process_info'])
    downloadModel_returned = Signal('QVariant', arguments=['request_model'])
    downloadLink_returned = Signal('QVariant', arguments=['request_clipboard_link'])
    link_approved = Signal('QVariant', arguments=['check_link'])
    additional_info_returned =  Signal('QVariant', arguments=['request_additional_info'])
    pending_started = Signal(int , arguments=['_resume_pending'])
    loadInfo_returned = Signal(bool , arguments=['request_load_info'])
    unfinished_check_returned = Signal(bool , arguments=['unfinished_check'])

    def add_download(self, process: DownloadProcess, scheduler=None):
        self.processes.append(process)
        if (scheduler):
            pass
        else:
            try:
                self.start_download(-1)
            except:
                print("An Error has occured")

    def _resume_pending(self):
        if not self.pending.is_empty():
            self.pending_started.emit(self.pending.peek())
            self.processes[self.pending.dequeue()].status = "Downloading"

    def _notify(self,cdd=True , scheduled_waiting=False , scheduler=False):
        #print("__Note__: yes it works")
        if scheduler:
            if scheduled_waiting:
                self.nas += 1
                pos = len(self.processes) - self.nas - len(self.processes)
                self.scheduled.enqueue(pos)
                print(f"===========================================adding sched {pos}  , s={self.scheduled.length}")
                print(f"-nanana {self.nas}")
            else:
                self.nas -= 1
                active = len(self.processes) - self.cof  - self.nas - 1
                print(f"at the moment we have {active} active downloads")
                if active >= SettingsManager.SETTINGS["System"]["Downloads"]["SimDown"]:
                    print(f" pending insex {self.scheduled.peek()}")
                    pos = self.scheduled.dequeue()
                    self.processes[pos].status = "Pending"
                    #self.pending.enqueue(pos)
                print(f"nanana {self.nas}")
        elif cdd:
            self.cof += 1
            if self.cof == len(self.processes) and self.auto_shutdown:
                print("all tasks are cof I think im gonna shut down")
                print(f'pda {SettingsManager.SETTINGS["System"]["OS"]["postDown"]}')
                print(f'pCMD {SettingsManager.SETTINGS["System"]["OS"]["postCMD"]}')
                #if SettingsManager.SETTINGS["System"]["OS"]["postDown"] == 1:
                #    QCoreApplication.exit(0)
                self.wrap_up()
                pda(SettingsManager.SETTINGS["System"]["OS"]["postDown"])
                pdCMD(SettingsManager.SETTINGS["System"]["OS"]["postCMD"])
                return
            self._resume_pending()
        else:
            active = len(self.processes) - self.cof - 1 - self.nas
            print(f"active {active}")
            print(f"cof {self.cof}")
            if active >= SettingsManager.SETTINGS["System"]["Downloads"]["SimDown"]:
                self.processes[-1].status = "Pending"
                self.pending.enqueue(len(self.processes) - 1)


    @Slot("QVariant")
    def log(self,data):
        if is_int(data):
            print(data)
        else:
            print(f"__LOG__:{data.toVariant()}")

    @Slot(str, str)
    def add(self, url, dest, scheduler=None):
        self.add_download(DownloadProcess(url, dest), scheduler=scheduler)

    @Slot("QVariant" , bool)
    def pause(self, index , search):
            if is_int(index):
                index = self.matched[index] if search else index
                if self.processes[index].status == 'Downloading':
                    self.processes[index].pause()
            else:
                index = index.toVariant()
                if search:
                    [self.processes[self.matched[i]].pause() for i in range(len(index)) if index[i]]
                else:
                    [self.processes[i].pause() for i in range(len(index)) if index[i]]
            print(index)

    @Slot("QVariant" , bool)
    def resume(self, index , search):
        if is_int(index):
            print(f"index res {index}")
            index = self.matched[index] if search else index
            if self.processes[index].status != 'Completed':
                self._resume_retry(index)
        else:
            index = index.toVariant()
            print(f"res are {index}")
            if search:
                [self._resume_retry(self.matched[i]) for i in range(len(index)) if index[i]]
            else:
                [self._resume_retry(i) for i in range(len(index)) if index[i]]




    @Slot(int,bool , bool , int)
    def remove(self, index , from_disk , search , shifts):
        print(index)
        print(f"matched {self.matched}")
        print(f"all {[i for i in range(len(self.processes))]}")
        if search:
            mi = self.matched[index] - shifts
            if self.processes[mi].status == "Completed" or self.processes[mi].status == "Failed":
                self.cof = self.cof - 1 if self.cof>0 else 0
            self.processes[mi].delete(from_disk)
            del(self.processes[mi])
            del(self.matched[index])
        else:
            if self.processes[index].status == "Completed" or self.processes[index].status == "Failed":
                self.cof = self.cof - 1 if self.cof>0 else 0
            self.processes[index].delete(from_disk)
            del(self.processes[index])


    @Slot(int)
    def start_download(self, index):
        t = Thread(target=self.processes[index].download , args=(self._notify ,))
        t.start()


    @Slot(str)
    def request_process_info(self,regex=None):
        # info_list = [download.info_model() for download in self.processes]
        if regex:
            if find(regex , self.processes[-1].file_name):
                self.downloadInfo_returned.emit(self.processes[-1].info_model())
        else:
            self.downloadInfo_returned.emit(self.processes[-1].info_model())


    @Slot(int,bool)
    def request_additional_info(self,index,search):
        if index != -1:
            index = self.matched[index] if search else index
            self.additional_info_returned.emit(self.processes[index].static_info())


    @Slot(str)
    def request_model(self , regex=None):
        if regex:
            #self.matched = [i for i in range(len(self.processes)) if find(regex , self.processes[i].file_name)]
            list = [process.info_model() for process in self.processes if find(regex ,process.file_name)]
        else:
            list = [process.info_model() for process in self.processes]
       # print(regex)
       # print(list)
        self.downloadModel_returned.emit(list)

    @Slot()
    def request_clipboard_link(self):
        link = clipboard.paste()
        if is_download_link(link):
            self.downloadLink_returned.emit([link,SettingsManager.SETTINGS["System"]["Downloads"]["Path"]])
        else:
            self.downloadLink_returned.emit(["", SettingsManager.SETTINGS["System"]["Downloads"]["Path"]])

    @Slot(str)
    def check_link(self, link):
        print(is_download_link(link))
        self.link_approved.emit(is_download_link(link))

    @Slot(int , bool,bool)
    def open_explorer(self,index,launch,search):
        if search:
            open_file(self.processes[self.matched[index]].destination.replace("/", "\\"), launch=launch)
        else:
            open_file(self.processes[index].destination.replace("/", "\\"), launch=launch)

    @Slot(int , str)
    def move(self,index,destination):
        process = self.processes[index]
        os.rename(process.destination , f"{destination}/{process.file_name}")
        self.processes[index].destination = f"{destination}/{process.file_name}"

    @Slot(str)
    def match(self,regex):
        self.matched = [i for i in range(len(self.processes)) if find(regex , self.processes[i].file_name)]

    @Slot()
    def shutdown_on_complete(self):
        self.auto_shutdown = not self.auto_shutdown

    @Slot(int,"QVariant",str,str,bool)
    def set_scheduler(self,index,repeat,tf,tt,search):
        index = self.matched[index] if search else index
        repeat_days = repeat.toVariant()
        t = Thread(target=self._schedule , args=(index,repeat_days,tf,tt),daemon=True)
        t.start()

    def _schedule(self,index,repeat,tf,tt):
        if self.processes[index].scheduler:
            print("REMOVING EXSTING SCED")
            self.processes[index].remove_schedule()
        self.processes[index].set_schedule(repeat, tf, tt)

    @Slot(int,bool)
    def del_scheduler(self,index,search):
        index = self.matched[index] if search else index
        if self.processes[index].scheduler:
            self.processes[index].remove_schedule()

    @Slot()
    def request_load_info(self):
        self.loadInfo_returned.emit(self.auto_shutdown)

    @Slot()
    def wrap_up(self):
        print("Main program closing")
        [process.wrap() for process in self.processes]
        info = [self.processes,self.cof,self.nas,self.pending,self.scheduled]
        with open('dl_list.dat','wb') as file:
            pickle.dump(info , file)

    @Slot()
    def unfinished_check(self):
        print([process.status for process in self.processes])
        print(f'cod={self.cof} | len={len(self.processes)}')
        check = self.cof < len(self.processes)
        self.unfinished_check_returned.emit(check)


    def _load_wrapped(self):
        with open('dl_list.dat' , 'rb') as file:
            wrapped_info = pickle.load(file)
            self.processes = wrapped_info[0]
            self.cof = wrapped_info[1]
            self.nas = wrapped_info[2]
            self.pending = wrapped_info[3]
            self.scheduled = wrapped_info[4]
            #[process.unwrap() for process in self.processes]


    def _resume_retry(self,index):
        if self.processes[index].status == 'Failed':
            self.start_download(index)
            self.cof -= 1
        else:
            self.processes[index].resume()



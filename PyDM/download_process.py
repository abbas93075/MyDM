import requests
from urllib.request import urlopen, Request , urlretrieve, ProxyHandler, build_opener, install_opener
from urllib.error import HTTPError , URLError
from urllib.parse import urlparse
import re
import os
import time
from program_settings import SettingsManager
from time_management import  Scheduler
from utils import download_speed_format, correct_file_name, current_date, check_existance , size_format,cap_val


class DownloadProcess:
    AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
    def __init__(self, url, destination):
        self.url = url
        self.total_size = 1
        self.file_name = "<Requesting...>"
        self.current_size = 0
        self.destination = destination
        self.type = None
        self.progress = 0
        self.status = 'idle'
        self.speed = "0 KB/s"
        #SettingsManager.SETTINGS["Network"]["Traffic"]["limit_numeric"] = 400
        self.pointer = None
        self.added = current_date()
        self.headers = {}
        self.timeout = 60
        self.request = None
        #SettingsManager.SETTINGS["System"]["Downloads"]["Retries"] = 10
        self.resumable = False
        self.scheduler = None

    def _release_pointer(self):
        if self.pointer:
            self.pointer.close()

    def _close(self):
        self._release_pointer()
        if self.request:
            self.request.close()

    def pause(self):
        if self.status == 'Downloading':
            self.status = 'Paused'

    def resume(self):
        if self.status == 'Paused':
            self.status = 'Downloading'

    def delete(self, from_disk=False):
        self.status = 'removed'
        if self.scheduler:
            self.scheduler.eliminate()
        if self.pointer:
            self.pointer.close()
        # self.pointer = None
        if from_disk and os.path.isfile(self.destination):
            os.remove(self.destination)

    def _schedule(self,start_handler , end_handler):
        if self.scheduler:
            self.status = "Scheduled"
            self.scheduler.interval_sleep(start_handler=start_handler , end_handler=end_handler)

    def _request(self,range=0,callback=None):
        print(f'requesting {range}-end')
        try:
            if self.request:
                self.request.close()
            self.headers = {
                "Range": f"bytes={range}-",
                'User-Agent':DownloadProcess.AGENT
            }
            self.status = 'Downloading'
            request_object = Request(self.url, headers=self.headers)
            if SettingsManager.SETTINGS["Network"]["Proxy"]["value"] == 1:
                self.set_proxy(SettingsManager.SETTINGS["Network"]["Proxy"]["URL"],'https',
                               uname=SettingsManager.SETTINGS["Network"]["Proxy"]["uname"],
                               passwd=SettingsManager.SETTINGS["Network"]["Proxy"]["passwd"])
            else:
                self.set_proxy('127.0.0.1','http')
            self.request = urlopen(request_object,timeout=60)
            #print(self.request.headers)
            #print(self.request.info())
            #print(f"ts is {int(self.request.headers.get('Content-Length', 1)) / 10 ** 6}")
            if range == 0:
                if 'Content-Range' in self.request.headers.keys():
                    self.resumable = True
                print(self.resumable)
                if 'Content-Length' in self.request.headers.keys():
                    self.total_size = int(self.request.headers['Content-Length'])
                    print(f"ts is {self.total_size}")
                if 'Content-Disposition' in self.request.headers.keys():
                    namelist = re.findall("filename=(.+)", self.request.headers['Content-Disposition'])
                    if len(namelist) > 0:
                        self.file_name = namelist[0]
                    else:
                        self.file_name = urlparse(self.url)[2].split("/")[-1]
                    print(self.request.headers)
                else:
                    self.file_name = urlparse(self.url)[2].split("/")[-1]
                self.file_name = correct_file_name(self.file_name)
                self.type = self.request.headers.get("Content-Type", "Unknown")
                #print(f'file to download {self.file_name} of type{self.type}')
                self.file_name = check_existance(f"{self.destination}\\{self.file_name}")
                self.destination = f'{self.destination}\\{self.file_name}'.replace("/","\\")
                #print(self.destination)
        except URLError as e:
            print(f"url error {e}")
            #self.status = "Failed"



    def download(self,callback=None):
        self._request(range=self.failed_ptr_loc())
        if not self.type:
            self.status = "Failed"
            self.file_name = "<Fatal Error(No Internet?)>"
            #return
        if callback:
            callback(cdd=False)
        differencet = 0
        differencec = 0
        t = time.time()
        c = self.current_size
        retries = 0
        if self.status != 'Failed':
            self.pointer = open(self.destination, 'ab')
        schedule_notify = True
        while self.status == "Pending":
            time.sleep(0.1)
        while self.status == "Scheduled":
            time.sleep(0.1)
        while self.status == "Downloading" or self.status=='Paused':
            try:
                # print(self.current_size)
                #print("loop---\nloop--")
                #new_t = time.time_ns()
                chunk = self.request.read(1024)
                #print(f"it took us {time.time_ns() - new_t} nanoseconds to read 1024 bytes from the internet")
                self.current_size = self.pointer.tell()
                while self.status == 'Paused':
                    time.sleep(0.1)
                if self.scheduler and schedule_notify:
                    callback(scheduled_waiting=True, scheduler=True)
                while self.status == "Scheduled":
                    time.sleep(0.1)
                if self.scheduler and schedule_notify:
                    callback(scheduled_waiting=False , scheduler=True)
                    schedule_notify = False
                while self.status == "Pending":
                    time.sleep(0.1)
                #self.scheduler = None
                if chunk:
                    # print(chunk)
                    retries = 0
                    if self.pointer:
                        self.pointer.write(chunk)
                    # print(f"my size is {self.current_size} wheras byte is {byte}")
                else:
                    if self.progress != 100 and retries < SettingsManager.SETTINGS["System"]["Downloads"]["Retries"]:
                        #print("else")
                        retries+=1
                        print(f"Retrying {retries}")
                        time.sleep(self.timeout)
                        self._request(range=self.pointer.tell())
                        continue
                    break

                total = self.total_size if self.total_size != 1 else self.current_size + 1
                self.progress = round((int(self.current_size) / total) * 100)
                differencet += time.time() - t
                differencec += self.current_size - c
                if differencet >= 1:
                    self.speed = download_speed_format(differencec / 1024)
                    #print(f"dc is {differencec / 1024}")
                    differencet = 0
                    differencec = 0
                    t = time.time()
                    c = self.current_size
                    cs = 1/((89*0.5)/4)
                    if SettingsManager.SETTINGS["Network"]["Traffic"]["value"] == 1:
                        time.sleep(cap_val(SettingsManager.SETTINGS["Network"]["Traffic"]["limit_numeric"]))
            except FileNotFoundError as e:
                self._close()
                print(e.strerror)
            except OSError as e:
                if retries < SettingsManager.SETTINGS["System"]["Downloads"]["Retries"] and self.resumable:
                    self._request(range=self.pointer.tell())
                    continue
                print(e.strerror)
                break

        print("==========")
        self._close()
        if self.status == 'Downloading':
            self.status = 'Completed' if self.progress == 100 else 'Failed'
        if callback:
            if self.status == "Completed" or self.status == "Failed":
                callback(cdd=True)

    def info_model(self) -> dict:
        info = {
            "name": self.file_name,
            "status": self.status,
            "progress": self.progress,
            "speed": f"Speed={self.speed}"
        }
        return info

    def onScheduler_interval_start(self):
        self.status = "Downloading"

    def onScheduler_interval_end(self):
        if not (self.status == "Completed" or self.status=="Failed"):
            self._schedule(start_handler=self.onScheduler_interval_start , end_handler=self.onScheduler_interval_end)

    def set_schedule(self,repeat,tf,tt):
        self.status = "Scheduled"
        self.scheduler = Scheduler(repeat,tf=tf,tt=tt)
        self._schedule(start_handler=self.onScheduler_interval_start , end_handler=self.onScheduler_interval_end)

    def remove_schedule(self):
        self.scheduler.eliminate()
        self.scheduler = None
        self.status = "Downloading"

    def static_info(self):
        info = [self.file_name, self.status, size_format(self.total_size), self.type, self.destination, self.added,
                self._scheduler_info()]
        return info

    def _scheduler_info(self):
        if self.scheduler:
            if self.status == "Completed" or self.status == "Failed":
                return f"Was {self.scheduler.message_info()}"
            else:
                return self.scheduler.message_info()
        else:
            return "Not Scheduled"

    def set_proxy(self,proxy_url,type,uname='',passwd=''):
        proxy = ProxyHandler({type: f'{uname}:{passwd}@{proxy_url}'})
        opener = build_opener(proxy)
        install_opener(opener)

    def wrap(self):
        self._close()
        self.request = None
        self.pointer = None

    def failed_ptr_loc(self):
        if self.status != "Failed" or not self.type:
            return 0
        if not self.resumable:
            ptr = open(self.destination,'wb')
            ptr.close()
            self.destination = "\\".join(self.destination.split("\\")[:-1])
            return 0
        ptr = open(self.destination,'ab')
        loc = ptr.tell()
        ptr.close()
        return loc


    '''
    def unwrap(self):
        if self.status == 'Stopped':
            self._request()
            self.pointer = open(self.destination,'ab')
            self.status = 'Paused'
    '''


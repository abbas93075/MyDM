import json
#from utils import   int_from_str
import getpass , os
import re
from PySide2.QtCore import QObject, Slot, Signal

def int_from_str(strval):
    if strval:
        return int(re.search("[0-9]+",strval).group(0))

def get_settings_downpath():
    uname = getpass.getuser()
    downpath = f"C:\\Users\\{uname}\\Downloads"
    if not os.path.exists(downpath):
        downpath = downpath.replace("Downloads","Desktop")
    return downpath



class SettingsManager(QObject):
    SETTINGS = None
    def __init__(self):
        SettingsManager.SETTINGS = self._load()
        self._set_default_download_path()
        QObject.__init__(self)

    settings_returned = Signal('QVariant' , arguments=['request_settings'])
    @Slot('QVariant')
    def log(self,data):
        print(f'__LOG__:{data.toVariant()}')

    @Slot(int,'QVariant')
    def set_proxy(self,value,url=None):
        SettingsManager.SETTINGS["Network"]["Proxy"]["value"] = value
        SettingsManager.SETTINGS["Network"]["Proxy"]["URL"] = url if url else None

    @Slot(int, 'QVariant')
    def set_proxy_authentication(self, option, data):
        if option==0:
            SettingsManager.SETTINGS["Network"]["Proxy"]["uname"] = data
        else:
            SettingsManager.SETTINGS["Network"]["Proxy"]["passwd"] = data

    @Slot(int, int)
    def set_traffic(self,value,limit=None):
        SettingsManager.SETTINGS["Network"]["Traffic"]["value"] = value
        SettingsManager.SETTINGS["Network"]["Traffic"]["limit"] = limit
        SettingsManager.SETTINGS["Network"]["Traffic"]["limit_numeric"] = self.numeric_limit
        print(f'the numeric limit is {SettingsManager.SETTINGS["Network"]["Traffic"]["limit_numeric"]}')

    @Slot(str)
    def set_download_path(self,path):
        SettingsManager.SETTINGS["System"]["Downloads"]["Path"] = path

    @Slot(int)
    def set_download_limit(self,limit):
        SettingsManager.SETTINGS["System"]["Downloads"]["SimDown"] = limit

    @Slot(int)
    def set_download_retries(self,retry_nb):
        SettingsManager.SETTINGS["System"]["Downloads"]["Retries"] = retry_nb

    @Slot(int, int,'QVariant')
    def set_os(self,value,pda=0,cmd=None):
        print(f"order to post download={pda} and post cmd={cmd}")
        SettingsManager.SETTINGS["System"]["OS"]["value"] = value
        SettingsManager.SETTINGS["System"]["OS"]["postDown"] = pda
        print(f'stting cmd:{cmd}')
        SettingsManager.SETTINGS["System"]["OS"]["postCMD"] = cmd if cmd else None
        #print(SettingsManager.SETTINGS)


    @Slot()
    def request_settings(self):
        print(f"emitting sttings {SettingsManager.SETTINGS}")
        self.settings_returned.emit(SettingsManager.SETTINGS)

    @Slot()
    def save(self):
        print("saving...")
        file = open("pref.json",'w')
        json.dump(SettingsManager.SETTINGS,file)
        file.close()
        print("saved")

    def _load(self):
        file = open("pref.json","r")
        data = json.load(file)
        file.close()
        return data

    def _set_default_download_path(self):
        if not SettingsManager.SETTINGS["System"]["Downloads"]["Path"]:
            SettingsManager.SETTINGS["System"]["Downloads"]["Path"] = get_settings_downpath()

    @property
    def numeric_limit(self):
        limits = SettingsManager.SETTINGS["Network"]["Traffic"]["limits"]
        limit = limits[SettingsManager.SETTINGS["Network"]["Traffic"]["limit"]]
        return int_from_str(limit)



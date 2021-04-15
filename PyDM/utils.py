import re
import os
import datetime
import sys
from math import sqrt , floor
import getpass
from program_settings import SettingsManager
from PySide2.QtCore import QCoreApplication
from urllib.parse import urlparse
import time

def download_speed_format(kbps):
    if(kbps < 1):
        return f"{kbps * 1024} B/S"
    elif(kbps >= 1000):
        return f"{round(kbps / 1024 , 2)} MB/s"
    else:
        return f"{kbps} KB/s"

def size_format(size_in_bytes):
    kb = size_in_bytes/1024
    if kb < 1:
        return f"{size_in_bytes} Bytes"
    elif kb >= 1000:
        return f"{round(kb/1024 , 2)} MB"
    else:
        return f"{kb} KB"

def is_download_link(link:str)->bool:
    return re.match(".+\/\/" , link) != None

def correct_file_name(file_name:str):
    file_name =  re.sub(r'[\/+\\+\:+\*+\?+\"+\<+\>+\|]' , "" , file_name)
    return file_name

def open_file(path , launch=False):
    if launch:
        os.system(f'explorer "{path}"')
    else:
        os.system(f'explorer /select,"{path}"')

def pda(option):
    if SettingsManager.SETTINGS["System"]["OS"]["value"] != 0:
        return
    if option == 0:
        pass
    elif option == 1:
        print("exit")
        QCoreApplication.exit()
    elif option == 2:
        print("hibernate")
        os.system("shutdown /h")
    elif option == 3:
        print("shutdown")
        os.system("shutdown -s -t 1")

def pdCMD(command):
    if SettingsManager.SETTINGS["System"]["OS"]["value"] != 1:
        return
    os.system(command)

def conditional_sleep(conition , interval=0.1):
    while conition:
        time.sleep(interval)

def is_int(data):
    return isinstance(data,int)

def find(phrase , regex):
    return re.search(phrase , regex , re.IGNORECASE) != None

def td(one_digit_nb:str):
    return '{:02d}'.format(one_digit_nb)

def check_existance(path:str):
    i=1
    extension = path.split(".")[-1]
    folder = path.replace(f".{extension}","")
    while os.path.exists(path):
        #folder = f"{folder}({i})"
        path = f"{folder} ({i}).{extension}"
        i+=1
    return os.path.split(path)[-1]


def current_date():
    return f"{datetime.date.today()} At {datetime.datetime.now().time().strftime('%H:%M:%S')}"

def poly(a=0.0 , b=0.0 , c=0.0):
    delta = b**2 - 4*a*c
    x= (-b+sqrt(delta))/(2*a)
    return x

def cap_val(speedkBps):
    if speedkBps < 0:
        raise ValueError("Negative speeds are not allowed")
    return 1/poly(a=0.5, b=0.5 , c=-1*speedkBps)

def get_settings_downpath():
    uname = getpass.getuser()
    downpath = f"C:\\Users\\{uname}\\Downloads"
    if not os.path.exists(downpath):
        downpath = downpath.replace("Downloads","Desktop")
    return downpath




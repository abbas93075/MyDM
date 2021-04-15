from download_process import DownloadProcess
from file_downloader import  FileDownloader
import time
from queue import Queue
from urllib.parse import urlparse, urlsplit
from utils import *
from program_settings import SettingsManager
import json
import getpass
from time_management import Scheduler
from datetime import datetime , timedelta
from math import  sqrt
from multiprocessing import Process
from program_settings import SettingsManager
import pickle
'''
fd = FileDownloader()
fd.add_download(DownloadProcess("https://a4-ps6-nmdk.vidstream.to/dl/26d64f4e844d66e9ZrzuzIkWyDkKTssu3.hBhC3JPX2BEB%7CJjBvffIdg__.UXpYaTZUYUowcmI3QjNLLzRZVmZoRW9MSWhWVEFSZGVvS25IVzdObmFJZE1QbzdBMkM3NTFQMklISy9qVGZpSnJlOHlzYjBWRzlBcDhqN3REK1Y3MGxYRDNTVlBJd09vSzhhTS9ROFFUbHZhcWlrSzBhbGpoV1lJTWt1SUp5VDBBMFpBNHo0czJKUnRKdHhUQk5DUHI0TUp4Y20yS0wwUEhVdlJuWnIrbmlVcFNDOHMzQkZ6V2hGSk1JYXpxcHFVWEhqcXJibERiME0veGJSTGVOTUx3RGlWWVYrcExWSzhpd3ZTWlhNREdaWHpaNklLV0FSbkc0VmNaZEtWNjNhWXlzTWRzeDAzMHQzanpYaGErcHdoaGV5ajNKT2tCOWFZTm5YNlpzR1JGYkFXbTF2dHdqTkE0M1VndXQvRDU3cmoxSlVGUlpxSVc4SW9UTXEvVlB4VzQ4NFkvRnltRUNDT1VxVHRtdjNNVlpkYWorTzRuUT09/[EgyBest].Orphan.Black.S03E02.BluRay.720p.x264.mp4","C:\\Users\\Abbas\\Desktop\\idmtst"))
#fd.pause(0)
print("======================================================================")
#time.sleep(10)
#fd.delete(0)
#fd.resume(0)
'''
#print(is_download_link("https://lolsossl"))
#YMD
#print(datetime.now() > datetime(2020 , 10 , 11 , 23 , 20 , 23))
#s = Scheduler([False,False,False,False,False,False,False],"12:45:00","12:46:00")
#print(s.message_info())
#print("Abbas" in "Abbas is a donkey")
#s.interval_sleep(lambda :print("hi"),lambda :print('bye'))
#d = datetime(2020,9,30,12,45,10)
#print(f"done sleeping at {datetime.now()}")
#print(not False)
#print(current_date())
'''
i=7
print(datetime.today().date())
print(poly(a=0.5, b=0.5 , c=-6))
print(get_settings_downpath())
sm = SettingsManager()
sm.set_proxy(1,url="www.google.com")
sm.set_traffic(1,limit="700 KB/s")
sm.set_download_path("C:\\l\\l\\l")
sm.set_download_retries(71)
sm.set_os(1,cmd='echo helloWorld!')
print(int_from_str("450 KB/s"))
print(SettingsManager.SETTINGS)
'''
ptr = open('test.txt','wb')
ptr.close()
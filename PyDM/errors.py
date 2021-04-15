from urllib.error import *
from socket import gaierror

class URLerror(URLError):
    pass

class ConnectionError(gaierror):
    pass
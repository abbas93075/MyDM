from PySide2.QtCore import QObject, Signal, Property, QUrl
from PySide2.QtGui import QGuiApplication,QIcon
from PySide2.QtQml import QQmlApplicationEngine
from file_downloader import FileDownloader
from program_settings import SettingsManager
import resources
import sys

app = QGuiApplication(sys.argv)
app.setWindowIcon(QIcon(':/mi.png'))
engine = QQmlApplicationEngine()
settings_man = SettingsManager()
fd = FileDownloader()
engine.rootContext().setContextProperty("filedownloader" , fd)
engine.rootContext().setContextProperty("sm" , settings_man)
engine.load(QUrl.fromLocalFile(':/Main.qml'))
if not engine.rootObjects():
        sys.exit(-1)
sys.exit(app.exec_())
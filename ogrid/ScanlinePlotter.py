import numpy as np
import pyqtgraph as pg
from PyQt5 import QtWidgets, QtCore, QtGui
from messages.udpMsg import *
# from messages.moosMsgs import *
from messages.udpClient_py import *
from scipy import signal
from settings import GridSettings



class haha(QObject):
    scan_list = []
    ad_low = []
    ad_span = []
    bearing = []
    range_scale = []

    def __init__(self, p1):
        super().__init__()
        self.p1 = p1
        # self.client = MoosMsgs()
        # self.client.signal_new_sonar_msg.connect(self.plot)
        # self.client.run()
        self.client = UdpClient(4002, 4006, None, None, None)
        self.client.start()
        self.client.signal_new_sonar_msg.connect(self.plot)

    @QtCore.pyqtSlot(object, name='new_sonar_msg')
    def plot(self, msg):
        # global curve
        # curve.setData(msg.data)
        self.p1.plotItem.plot(msg.data, clear=True)
        smooth = np.convolve(msg.data, np.full(GridSettings.smoothing_factor, 1.0/GridSettings.smoothing_factor),
                             mode='full')
        self.p1.plotItem.plot(smooth, clear=False, pen=pg.mkPen('b'))
        self.scan_list.append(msg.data)
        self.ad_low.append(msg.ad_low)
        self.ad_span.append(msg.ad_span)
        self.bearing.append(msg.bearing)
        self.range_scale.append(msg.range_scale)


if __name__ == '__main__':
    global scan_list
    # udp_client = UdpClient(4001, 4005, None, None)
    # udp_client.set_sonar_callback(plot)
    # udp_client.start()
    p1 = pg.plot()
    b = haha(p1)

    app = QtGui.QApplication([])

    p1.setYRange(0, 255)
    # p1.autoPixelRange = False
    p1.show()

    app.exec_()
    from scipy.io import savemat
    # np.savez('scanline.npz', scanline=np.array(b.scan_list))
    savemat('scanlines.mat', {'scanlines': np.array(b.scan_list), 'ad_low': np.array(b.ad_low),
                              'ad_span': np.array(b.ad_span), 'bearing': np.array(b.bearing),
                              'range_scale': np.array(b.range_scale)})
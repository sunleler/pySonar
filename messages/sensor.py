from datetime import datetime

class Sensor(object):
    sensorStr = 'None'
    sensor = 0
    time = ''
    date = ''

    def __init__(self, *kwargs):
        for args in kwargs:
            if type(args) == tuple:
                self._set_dateTime(args[2])
                self.date = args[0]
                self.time = args[1]
            else:
                self.time = args

    def _get_dateTime(self):
        return self.__dateTime
        return self.__dateTime

    def _set_dateTime(self, value):
        if not isinstance(value, datetime):
            raise TypeError("bar must be set to an integer")
        self.__dateTime = value

    dateTime = property(_get_dateTime, _set_dateTime)

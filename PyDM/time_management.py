import time
from datetime import datetime , timedelta
from utils import  td
class Scheduler:
    DF = '%Y-%m-%d'
    TF = '%H-%M-%S'
    def __init__(self , repeat , tf , tt):
        self.current_date = datetime.today()
        self.today = self.current_date.weekday()
        self.allowed_days = repeat
                            # M     T    W    Th    F    Sa   Su
        self.start_date = None
        self.end_date = None
        self.time_from = self.split_to_int(tf,":")
        self.time_to = self.split_to_int(tt,":")
        self.force_finish = False
        print(self.allowed_days)

    def message_info(self):
        time_from = map(lambda t : td(t) , self.time_from)
        time_to = map(lambda t : td(t) , self.time_to)
        weekdays = ['Mon' , 'Tue' , 'Wed' , 'Thu' , 'Fri' , 'Sat' , 'Sun']
        allowed_days = '-'.join([weekdays[i] for i in range(7) if self.allowed_days[i]])
        if len(allowed_days) == 7:
            allowed_days = "Everyday"
        elif len(allowed_days) == 0:
            allowed_days = str(self.start_date.date())
        return f"Set for {':'.join(time_from)} -> {':'.join(time_to)} At Days: {allowed_days}"

    def in_time_range(self,current_date , start_date , end_date):
        return current_date >= start_date and current_date <= end_date

    def sleep_until(self,future_date):
        while datetime.now() < future_date and not self.force_finish:
            print("scheduler wating.......................")
            time.sleep(1)

    def interval_sleep(self,start_handler , end_handler):
        print(self.to_list(self.current_date, time=True , date=True))
        print(self._ttms(self.to_list(self.current_date, time=True)))
        print(self._ttms(self.time_to))
        if self._ttms(self.to_list(self.current_date , time=True)) > self._ttms(self.time_to):
            print("futer date out of hand incrementing")
            self.current_date += timedelta(days=1)
            self.today = self.current_date.weekday()
        print(f"actual day is {self._determine_actual_day(self.today)}")
        self.today = self.today if self._is_allowed(self.today) else self._determine_actual_day(self.today)
        #print(self.current_date.day)
        #print(self.today)
        print(f"current week day {self.current_date.weekday()}")
        print(f"current date day {self.current_date.day}")
        add_val =  abs(self.current_date.weekday() - self.today)
        print(f"advel {add_val}")
        self.start_date = datetime(*self.to_list(self.current_date , date=True , time=False), *self.time_from) + timedelta(days=add_val)
        print(f"start date is {self.start_date}")
        self.sleep_until(self.start_date)
        self.interval_start(callback=start_handler)
        self.end_date = datetime(*self.to_list(self.start_date,date=True,time=False),*self.time_to)
        #print(f"end date is {end_date}")
        self.sleep_until(self.end_date)
        self.interval_end(callback=end_handler)



    def set_interval(self,time_from:str,time_to:str):
        self.time_from = self.split_to_int(time_from,":")
        self.time_to = self.split_to_int(time_to , ":")

    def interval_start(self,callback=None):
        if callback and not self.force_finish:
            callback()

    def interval_end(self,callback=None):
        if callback and not self.force_finish:
            callback()

    def _inc(self):
        if self.current_day == 6:
            self.current_day = 0
        else:
            self.current_day += 1

    def to_list(self,dateOrtime ,date=False,time=False , replace=None):
        format = None
        if date and time:
            format = f"{Scheduler.DF}-{Scheduler.TF}"
        elif time:
            format = Scheduler.TF
        elif date:
            format = Scheduler.DF
        dtlist = dateOrtime.strftime(format).split("-")
        dtlist = [int(s) for s in dtlist]
        if replace:
            dtlist[replace[0]] = replace[1]
        return dtlist

    def split_to_int(self,string:str , splitter):
        return [int(s) for s in string.split(splitter)]

    def _determine_actual_day(self , start):
        if not any(self.allowed_days):
            print("all are false actual day ")
            return start
        for i in range(start ,7):
            if self.allowed_days[i]:
                return i
        for i in range(0,7):
            if self.allowed_days[i]:
                return -(i+1)
        return datetime.today().weekday()

    def _is_allowed(self,week_nb):
        return self.allowed_days[week_nb]

    def _ttms(self , time_list):
        h = time_list[0]*3600
        m = time_list[1]*60
        s = time_list[2]
        return h+m+s

    def eliminate(self):
        self.force_finish = True


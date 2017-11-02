import random
from datetime import date, datetime, timedelta
destinations = ['NY', 'CO', 'CA', 'TX', 'RI']
start = datetime(2010,1,1)
end = datetime(2016,12,31)

# return random.choice(destinations)


def datetime_range(start, end, delta):
    current = start
    if not isinstance(delta, timedelta):
        delta = timedelta(**delta)
    while current < end:
        yield current
        current += delta




#this unlocks the following interface:
for dt in datetime_range(start, end, {'days': 0, 'hours':0, 'minutes':1}):
	date = dt.strftime("%Y-%m-%d")
	time = dt.strftime("%H:%M:%S")
	target_temp = random.randint(68,72)
	actual_temp = random.randint(50,86)
	system = random.randint(1,20)
	systemAge = random.randint(1,40)
	building = random.randint(1,20)

	print "%s,%s,%d,%d,%d,%d,%d" %(date, time, target_temp, actual_temp, system, systemAge, building)
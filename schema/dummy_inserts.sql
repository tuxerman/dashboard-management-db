
insert into m_rtt   (deviceid,       srcip, 			dstip, 				eventstamp, 			average, 		std, 		minimum, 		maximum, 		median, 		iqr, 		toolid) 
	values 			('2CB05D830287', '130.207.121.65', 	'143.225.229.254', 	'2013-09-21 06:57:43', 	'145.043900', 	'0.347794', '144.726000', 	'145.939000', 	'144.948000', 	'0.263000', 'PING');

insert into m_rtt   (deviceid,       srcip,              dstip,              eventstamp,             average,        std,        minimum,        maximum,        median,         iqr,        toolid) 
    values          ('2CB05D830287', '130.207.121.65',  '143.225.229.254',  '2013-08-19 06:57:43',  '145.043900',   '0.347794', '144.726000',   '145.939000',   '144.948000',   '0.263000', 'PING');

insert into m_rtt   (deviceid,       srcip,              dstip,              eventstamp,             average,        std,        minimum,        maximum,        median,         iqr,        toolid) 
    values          ('2CB05D830287', '130.207.121.65',  '143.225.229.254',  '2013-09-22 06:57:43',  '145.043900',   '0.347794', '144.726000',   '145.939000',   '144.948000',   '0.263000', 'PING');

insert into m_rtt   (deviceid,       srcip,              dstip,              eventstamp,             average,        std,        minimum,        maximum,        median,         iqr,        toolid) 
    values          ('2CB05D830287', '130.207.121.65',  '143.225.229.254',  '2013-04-02 06:57:43',  '145.043900',   '0.347794', '144.726000',   '145.939000',   '144.948000',   '0.263000', 'PING');

-- diagnostic: list entries in m_rtt and list tables
select * from m_rtt;

-- explain select * from m_rtt where eventstamp >= DATE '2013-09-21 06:57:43';

\dt;
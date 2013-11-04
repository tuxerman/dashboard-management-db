DB:=sriram

all: create

create:
	createdb $(DB)
	./setup.sh $(DB)

createall: clean create
	
tables:

indexes:

export:

import:

verify:
	psql -f dummy_inserts.sql $(DB)

test:

cleansql:
	rm -f *.gsql */*.gsql */*/*.gsql	

clean:
	dropdb $(DB)

reallyclean: 
	dropdb $(DB)
	rm -f *.gsql */*.gsql */*/*.gsql

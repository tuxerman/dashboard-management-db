\i defaults.cfg

-- deviceidref references userdevices(deviceid), but not unique across series
CREATE TABLE measurements_tmpl (
    deviceid deviceidref_t NOT NULL, 
    srcip inetn_t,
    dstip inetn_t,
    eventstamp eventstamp_t,
    average float8,
    std float8,
    minimum float8,
    maximum float8,
    median float8,
    iqr float8,
    exitstatus integer default -9999,
    id id_t,
    toolid toolidref_t references tools(id),
    unique(id),
	direction varchar(10) default NULL,
    primary key (deviceid, eventstamp, dstip, srcip) -- dst,src maybe not needed
);

-- it's my hope that this attribute migrates to copies, but have to check

alter TABLE measurements_tmpl ALTER COLUMN toolid set storage EXTERNAL;
alter TABLE measurements_tmpl ALTER COLUMN id set storage EXTERNAL;

-- FIXME, new is always new? do I need to grab the value of old?

CREATE OR REPLACE function gen_id_measurement_update() returns trigger as $gen_id_measurement_update$
  DECLARE 
    suffix VARCHAR(6);

  BEGIN
    IF (new.deviceid != 
       	   old.deviceid OR 
       	   new.eventstamp != 
	   old.eventstamp OR 
	   new.dstip !=
	   old.dstip OR
	   new.srcip !=
	   old.srcip )
	  THEN
	  new.id = sha1( (new.deviceid) || 
			 to_char(new.eventstamp,'JHH24MISSUS') || 
	  	   	 host(new.dstip) || 
			 host(new.srcip) );

    ----FIXME! Change this to act upon a changed eventstamp
    --SELECT INTO suffix * FROM to_char( New.eventstamp, 'YYYYMM');
    --EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_' || suffix || ' SELECT $1.*;' USING NEW;
    RETURN new;

  EXCEPTION
    -- FIXME! See above
    -- WHEN undefined_table
    -- THEN
    --   raise notice 'Inside specific exception block % %: Update', SQLERRM, SQLSTATE;
    --   EXECUTE 'CREATE TABLE ' || TG_TABLE_NAME || '_' || yyyy || '_' || mm || '() INHERITS('|| TG_TABLE_NAME|| ');';
    --   EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_' || yyyy || '_' || mm || ' SELECT $1.*;' USING NEW;
    --   RETURN null;
    WHEN OTHERS
    THEN
      raise notice 'Generic exception occured: % %', SQLERRM, SQLSTATE;
      -- TODO: Handle generic exception?
  	  END IF;
    return NEW;
    END;
$gen_id_measurement_update$
--language plpgsql strict immutable;
language plpgsql volatile;

CREATE OR REPLACE function gen_id_measurement_insert() returns trigger as $gen_id_measurement_insert$
      DECLARE 
      mm VARCHAR(2);
      yyyy VARCHAR(4);
      suffix VARCHAR(6);

  BEGIN
    new.id = sha1( new.deviceid || 
       to_char(new.eventstamp,'JHH24MISSUS') || 
           host(new.dstip) || 
       host(new.srcip));

    SELECT INTO suffix * FROM to_char( New.eventstamp, 'YYYYMM');
      EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_' || suffix || ' SELECT $1.*;' USING NEW;
      RETURN null;

  EXCEPTION
    WHEN undefined_table
    THEN
        SELECT INTO yyyy * FROM to_char( New.eventstamp, 'YYYY');
        SELECT INTO mm * FROM to_char( New.eventstamp, 'MM');
        EXECUTE 'CREATE TABLE ' || TG_TABLE_NAME || '_' || suffix || '( CHECK ( eventstamp >= DATE ''' || yyyy || '-' || mm || '-01'' AND eventstamp <= DATE ''' || yyyy || '-' || mm || '-01'' + interval ''1 month'' ) ) INHERITS('|| TG_TABLE_NAME|| ');';
        EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_' || suffix || ' SELECT $1.*;' USING NEW;
        RETURN null;
    WHEN OTHERS
    THEN
        raise notice 'Generic exception occured: % %', SQLERRM, SQLSTATE;
  END;
  
$gen_id_measurement_insert$
--language plpgsql strict immutable;
language plpgsql volatile;

create trigger gen_id_measurements_update before update on measurements_tmpl
	for each row execute procedure gen_id_measurement_update();

create trigger gen_id_measurements_insert instead of insert on measurements_tmpl
	for each row execute procedure gen_id_measurement_insert();
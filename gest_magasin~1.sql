CREATE OR REPLACE TRIGGER dept_bir 
BEFORE INSERT ON client
FOR EACH ROW

BEGIN
  SELECT SEQ_CLIENT.nextval
  INTO   :new.idCli
  FROM   dual;
END;
/

    



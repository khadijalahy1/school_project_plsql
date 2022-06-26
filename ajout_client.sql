
--Procedure ajout client 
CREATE OR REPLACE PROCEDURE AJOUT_CLIENT (idClient in client.idcli%TYPE,nomCli in client.nomcli%TYPE,
preCli in client.precli%TYPE,adrCli in client.adrcli%TYPE,
chAffaire in client.chaffaire%TYPE,idMagasin in client.idmagasin%TYPE) 
IS 
    ex_magasin EXCEPTION;

BEGIN 

   IF (idMagasin=1 OR idMagasin=2)  THEN
      RAISE ex_magasin;
   ELSE
      INSERT INTO client VALUES(idClient,nomCli,preCli,adrCli,chAffaire,idMagasin);
      DBMS_OUTPUT.PUT_LINE('Client crée');
    
   END IF;

EXCEPTION    
    WHEN ex_magasin THEN 
        DBMS_OUTPUT.PUT_LINE('Magasin inconnu');
    WHEN others THEN 
        DBMS_OUTPUT.PUT_LINE('Error!');
             
END;
/


BEGIN
    DBMS_OUTPUT.PUT_LINE('Client crée');
    -- Appel de la procedure insertion réussite 
    
    AJOUT_CLIENT (5,'Ali','Benanni','Elamal-agadir','30000',5);
    -- Appel de la procedure insertion échoué
    AJOUT_CLIENT (6,'Halima','marzouq','Elamal-agadir','30000',2);
    
END;
/

    
    
    
    



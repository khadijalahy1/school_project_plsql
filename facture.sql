/*
- Paramètres en Entrée : idCli, idMagasin et idDateA.
- Action :
 Affichage Nom_Client, Adresse_Client, idMagasin et Date.
 Affichage des achats sous la forme :
idProd - nomProd - prixPayé - qtéAchat – Montant
Avec Montant Total à la fin.
- Exceptions : Aucun achat.
- Affichages : Erreurs exceptions.

*/
--Procedure facture
CREATE OR REPLACE PROCEDURE FACTURE(idC client.idcli%type,idM magasin.idmagasin%type,idD achat.iddatea%type)
IS 
    ex_not_exist EXCEPTION;

    -- Definition des curseurs

    CURSOR achat_cursor is
    select  idcli
    from achat
    where idcli=idC and idmagasin=idM and iddatea=idD;
    --
    cursor facture_cursor is
    select client.nomCli,client.precli,client.adrcli,achat.idmagasin,achat.iddatea,achat.idprod,produit.nomprod,achat.prixpaye,achat.qteachat
    from achat
    join client
    on achat.idcli=client.idcli
    join produit
    on produit.idprod=achat.idprod
    where achat.idcli=idC and achat.idmagasin=idM and achat.iddatea=idD;
    --
    ffacture facture_cursor%ROWTYPE;
    fachat  achat_cursor%ROWTYPE;
    montant NUMBER :=0;
    is_first BOOLEAN :=TRUE;

BEGIN 
    open facture_cursor;
    open achat_cursor;
    fetch achat_cursor into fachat;

    IF (achat_cursor%NOTFOUND) THEN
        RAISE ex_not_exist ;

    ELSE
        LOOP
            fetch facture_cursor into ffacture;
            EXIT when facture_cursor%NOTFOUND;

            if is_first THEN

            --  Affichage Nom_Client, Adresse_Client, idMagasin et Date
                DBMS_OUTPUT.PUT_LINE('Nom_client :'||ffacture.nomCli||' '||ffacture.precli);
                DBMS_OUTPUT.PUT_LINE('Adresse :'||ffacture.adrcli);
                DBMS_OUTPUT.PUT_LINE('id Magasin :'||ffacture.idmagasin);
                DBMS_OUTPUT.PUT_LINE('Date :'||ffacture.iddatea);
                is_first:=FALSE;

            END IF;

            --Affichage des achats sous la forme :idProd - nomProd - prixPayé - qtéAchat – Montant
                DBMS_OUTPUT.PUT_LINE(ffacture.idprod||'-'||ffacture.nomProd||'-'||ffacture.prixpaye||'-'||ffacture.qteachat);

                --additionner le prix de cet achat au montant global
                montant:=montant+ffacture.prixpaye;

        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Montant global :'||montant);


    END IF;

    close facture_cursor;
    close achat_cursor;


EXCEPTION    
    WHEN ex_not_exist THEN 
        DBMS_OUTPUT.PUT_LINE('aucun achat existant');
    WHEN others THEN 
        DBMS_OUTPUT.PUT_LINE('Error!');
             
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('debut de test');

    -- test pour une facture d'achats non  valide
    FACTURE(10,1,TO_DATE('11/02/2012', 'DD/MM/YYYY'));

    -- test pour une facture d'achats valide
    FACTURE(2,1,TO_DATE('11/02/2012', 'DD/MM/YYYY'));

END;
/



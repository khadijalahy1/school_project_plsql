--Procedure ajout achat
CREATE OR REPLACE PROCEDURE AJOUT_ACHAT (idP in achat.idprod%type,idM in achat.idmagasin%type,idC in achat.idcli%type,
idD in achat.iddatea%type,qteA in achat.qteachat%type,price in achat.prixpaye%type) 

IS 
    ex_produit_inexistant EXCEPTION;
    ex_client_inconnu  EXCEPTION;  
    ex_qte_insuffisante EXCEPTION;
    ex_prix EXCEPTION;
    -- Definition des curseurs 
    CURSOR cursor_prod_stock is
    select idprod
    from stocker
    where idprod=idP  and idmagasin=idM;
    --------------
    CURSOR cursor_qte_stock is
    select idprod
    from stocker 
    where idprod=idP and idmagasin=idM and qtestock>=qteA;
    -----------------
    CURSOR cursor_client is
    select idcli
    from  client
    where idcli=idC;
    ------------------
    prix_unitaire_paye NUMBER := price/qteA ;
    CURSOR cursor_price is
    select idprod
    from produit
    where idprod=idp and puprod=prix_unitaire_paye;
    
    
     
    -- definition des variables conteneurs des curseurs
    fprod produit.idprod%type;
    fqte achat.qteachat%type;
    fclient client.idcli%type;
    fprix produit.idprod%type;
  
    

BEGIN 
    open cursor_prod_stock;
    open cursor_qte_stock;
    open cursor_client;
    open cursor_price;
    
    fetch cursor_prod_stock into fprod;
    fetch cursor_qte_stock into fqte;
    fetch cursor_client into fclient;
    fetch cursor_price into fprix;

   IF (cursor_prod_stock%NOTFOUND)  THEN
        RAISE ex_produit_inexistant;

   ELSIF (cursor_qte_stock%NOTFOUND) THEN 
        RAISE ex_qte_insuffisante;
        
   ELSIF (cursor_client%NOTFOUND) THEN 
        RAISE ex_client_inconnu;
    
   ELSIF (cursor_price%NOTFOUND) THEN
        RAISE ex_prix;
   ELSE
      INSERT INTO ACHAT VALUES (idP,idM,idC,idD,qteA,price);
      -- mise à jours du stock apres achat 
      UPDATE stocker
      SET qtestock = qtestock-qteA
      WHERE idprod=idp and idmagasin=idm;

   END IF;

EXCEPTION    
    WHEN ex_produit_inexistant THEN 
        DBMS_OUTPUT.PUT_LINE('Ce produit n existe pas dans ce magasin');
        
    WHEN ex_qte_insuffisante THEN
        DBMS_OUTPUT.PUT_LINE('la quantité existante dans le magasin est insuffisante');
        
    WHEN ex_client_inconnu THEN 
        DBMS_OUTPUT.PUT_LINE('Ce client est inconnu');
        
    WHEN ex_prix THEN
        DBMS_OUTPUT.PUT_LINE('le prix que vous avez payé est superieur aux prix unitaire');
        
    WHEN others THEN 
        DBMS_OUTPUT.PUT_LINE('error');
             
END;
/


BEGIN
 DBMS_OUTPUT.PUT_LINE('Test');
 
 -- achat valide
 ajout_achat(2,2,3,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2,100);
 -- client inexistant
 ajout_achat(2,2,7,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2,100);
 -- produit inexistant
 ajout_achat(5,2,3,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2,100);
 -- qte insuffisante
  ajout_achat(2,2,3,TO_DATE('17/12/2015', 'DD/MM/YYYY'),50,100);
 -- prix superieur au prix unitaire
  ajout_achat(2,2,3,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2,200);
 
 
    
    
END;
/
/*
. Procédure TRANSFERT_PRODUIT :
On désire transférer un article d’un magasin vers un autre.
- Paramètres en Entrée :
 idProd du produit à transférer.
 le nombre d’exemplaires.
 les 2 idMagasin (source et destination).
- Action :
 MAJ des qteStock des 2 magasins.
Ou :
 MAJ qteStock du 1er magasin et AJOUT dans le second.
- Exceptions : Stock insuffisant au magasin ‘source’.
- Affichages : ‘Transaction réussie’ ou Erreurs exceptions
*/
create or replace procedure transfert_produit(idP in  produit.idprod%type,nbre in NUMBER,idM1 in magasin.idmagasin%type,
idM2 in magasin.idmagasin%type)

IS

-- declaration
    ex_stock_insuffisant EXCEPTION;
    
    -- definition des curseurs 
    cursor stock_cursor is
    select idprod,qtestock
    from stocker
    where idprod=idP and idmagasin=idM1 and qtestock>=nbre;
    
    -- variables conteneurs des curseurs
    
    fstock stock_cursor%ROWTYPE;
    
BEGIN

    open stock_cursor;
    fetch stock_cursor into fstock;
    if stock_cursor%NOTFOUND THEN
        RAISE ex_stock_insuffisant;
        
    else
        -- transfert de la quantite du produit du premier magasin vers le deuxieme magasin
        --diminuer la qte de stock du magasin 1
        UPDATE stocker
        SET qtestock = qtestock-nbre
        WHERE idprod=idP and idmagasin=idM1;
        --augmenter la quantité de stock du magasin 2
        UPDATE stocker
        SET qtestock = qtestock+nbre
        WHERE idprod=idP and idmagasin=idM2;
        
        -- si le magasin1 ne contient plus de stoch pour ce produit --> effacer la ligne qui lui correspond dans la table stocker
        if fstock.qtestock=nbre then
            delete from stocker
            where idprod=idP and idmagasin=idM1;
            DBMS_OUTPUT.PUT_LINE('le magasin 1 ne contient plus maintenat ce produit');
            
        END IF;
        DBMS_OUTPUT.PUT_LINE('Transaction reussite');
        
        
    END IF;
    
EXCEPTION 
    WHEN ex_stock_insuffisant THEN 
        DBMS_OUTPUT.PUT_LINE('stock du magasin1 insuffisant pour faire le transfert');
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error');
 END; 
 /
 
BEGIN
    DBMS_OUTPUT.PUT_LINE('debut de test');
        -- transfert de 2 entites du produit1  du magasin1 au magasin 2
    transfert_produit(1,2,1,2);
    
    -- essayons de transferer 6 --> qte insuffisante 
    --transfert_produit(1,6,1,2);
    
    -- on transfert tout le reste de la quantité
    --transfert_produit(1,3,1,2);

END;
/
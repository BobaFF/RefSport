#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

#define PG_HOST     "127.0.0.1"
#define PG_USER     "postgres" 
#define PG_DB       "postgres"
#define PG_PASS     "1234"
#define PG_PORT     5432

PGconn* connect() {
    char conninfo [250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);
    
    PGconn * conn = PQconnectdb (conninfo);
    
    if(PQstatus(conn) != CONNECTION_OK) {
        std::cout << "Errore di connessione" << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }

    return conn;
}

void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        std::cout << "Risultati inconsistenti!" << PQerrorMessage(conn);
        PQclear(res);
        exit(1);
    }
}

PGresult* execute(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    checkResults(res, conn);
    return res;
}

void printQuery(PGresult* res) {
    int tuple = PQntuples(res);
    int campi = PQnfields(res);

    for (int i = 0; i < campi; ++i){
        std::cout << PQfname(res,i) << "\t\t";
        }
    std::cout << std::endl;
    
    for(int i = 0; i < tuple; ++i){
        for (int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }

}
int main () {
    
    PGconn* conn = connect();

    const char* query[10] = {
        "SELECT D.nome, D.cognome, F.inizio, F.fine, F.stato, D2.Nome AS Nome_capo, D2.cognome AS Cognome_capo\
        FROM Dipendente D JOIN Ferie F ON (D.CF = F.dipendente) JOIN Dipendente D2 ON (D.sedeLavorativa = D2.sedeLavorativa) JOIN Sede S ON (D2.sedeLavorativa = S.codice)\
        WHERE F.inizio <= '8/15/2023' AND F.fine >= '8/15/2023' AND D2.ruolo = 'Direttore'",

        "SELECT S.città, SUM(C.Stipendio) AS Spesa\
        FROM Sede S JOIN Dipendente D ON (S.codice = D.sedeLavorativa) JOIN Contratto C ON (D.CF = C.dipendente)\
        GROUP BY(S.codice)",

        "SELECT P.nome, p.marca, p.costo, SUM(dp.quantità) AS quantità\
        FROM Prodotto P JOIN Dettagli_ordine dp ON (P.codice = dp.prodottoP)\
        GROUP BY (p.codice)\
        UNION ALL\
        SELECT P.nome, p.marca, p.costo, SUM(df.quantità) AS quantità\
        FROM Prodotto P JOIN Dettagli_ordine_f df ON (P.codice = df.prodottoF)\
        GROUP BY (p.codice)\
        UNION ALL\
        SELECT P.nome, p.marca, p.costo, SUM(ds.quantità) AS quantità\
        FROM Prodotto P JOIN Dettagli_ordine_s ds ON (P.codice = ds.prodottoS)\
        GROUP BY (p.codice)\
        UNION ALL\
        SELECT P.nome, p.marca, p.costo, SUM(dv.quantità) AS quantità\
        FROM Prodotto P JOIN Dettagli_ordine_v dv ON (P.codice = dv.prodottoV)\
        GROUP BY (p.codice)\
        ORDER BY (quantità) DESC\
        LIMIT 10",

        "SELECT P.nome, P.punteggio, COUNT(R.voto) AS n_Voti\
        FROM Prodotto P JOIN Recensione R ON (P.codice = R.prodottor)\
        GROUP BY(P.codice)\
        HAVING COUNT(R.voto) >= 5\
        ORDER BY (P.punteggio) DESC",

        "SELECT D.nome, D.cognome,  COUNT(O.ricevuta) AS Ordini_gestiti\
        FROM Dipendente D JOIN Ordine O ON (D.CF = O.gestore)\
        WHERE D.ruolo = 'Magazziniere' AND O.data > '1/1/2023'\
        GROUP BY (D.CF)\
        ORDER BY Ordini_gestiti DESC" ,

        "SELECT DISTINCT oo.ricevuta, r.data, p.nome, r.voto, r.testo\
        FROM Cliente c JOIN Ordine_online oo ON (c.mail = oo.cliente) JOIN Dettagli_ordine d ON (oo.ricevuta = d.ordineP)\
        JOIN Prodotto p ON (p.codice = d.prodottop) JOIN Recensione r ON (r.prodottoR = p.codice)\
        WHERE r.ordineR = oo.ricevuta AND c.mail = '%s'\
        UNION ALL\
        SELECT DISTINCT oo.ricevuta, r.data, p.nome, r.voto, r.testo\
        FROM Cliente c JOIN Ordine_online oo ON (c.mail = oo.cliente)\
        JOIN Dettagli_ordine_f df ON (oo.ricevuta = df.ordineF) JOIN Prodotto p ON (p.codice = df.prodottof)\
        JOIN Recensione r ON (r.prodottoR = p.codice)\
        WHERE r.ordineR = oo.ricevuta AND c.mail = '%s'\
        UNION ALL\
        SELECT DISTINCT  oo.ricevuta, r.data, p.nome, r.voto, r.testo\
        FROM Cliente c JOIN Ordine_online oo ON (c.mail = oo.cliente)\
        JOIN Dettagli_ordine_s ds ON (oo.ricevuta = ds.ordineS) JOIN Prodotto p ON (p.codice = ds.prodottos)\
        JOIN Recensione r ON (r.prodottoR = p.codice)\
        WHERE r.ordineR = oo.ricevuta AND c.mail = '%s'\
        UNION ALL\
        SELECT DISTINCT oo.ricevuta, r.data, p.nome, r.voto, r.testo\
        FROM Cliente c JOIN Ordine_online oo ON (c.mail = oo.cliente)\
        JOIN Dettagli_ordine_v dv ON (oo.ricevuta = dv.ordineV) JOIN Prodotto p ON (p.codice = dv.prodottov)\
        JOIN Recensione r ON (r.prodottoR = p.codice)\
        WHERE r.ordineR = oo.ricevuta AND c.mail = '%s'",

        "SELECT tot.città, SUM(Ricavi) AS Ricavo_€\
        FROM (SELECT S.città, SUM(dp.quantità * p.costo) AS Ricavi\
        FROM Sede S JOIN Dipendente D ON (S.codice = D.sedeLavorativa) JOIN Ordine O ON (D.CF = O.gestore) JOIN Dettagli_ordine dp\
        ON (O.ricevuta = dp.ordineP) JOIN Prodotto p ON (dp.prodottoP = p.codice)\
        GROUP BY (S.codice)\
        UNION\
        SELECT S.città, SUM(df.quantità * p.costo) AS Ricavi\
        FROM Sede S JOIN Dipendente D ON (S.codice = D.sedeLavorativa) JOIN Ordine O ON (D.CF = O.gestore) JOIN Dettagli_ordine_f df\
        ON (O.ricevuta = df.ordineF) JOIN Prodotto p ON (df.prodottoF = p.codice)\
        GROUP BY (S.codice)\
        UNION\
        SELECT S.città, SUM(dS.quantità * p.costo) AS Ricavi\
        FROM Sede S JOIN Dipendente D ON (S.codice = D.sedeLavorativa) JOIN Ordine O ON (D.CF = O.gestore) JOIN Dettagli_ordine_s ds\
        ON (O.ricevuta = ds.ordineS) JOIN Prodotto p ON (ds.prodottoS = p.codice)\
        GROUP BY (S.codice)\
        UNION\
        SELECT S.città, SUM(dV.quantità * p.costo) AS Ricavi\
        FROM Sede S JOIN Dipendente D ON (S.codice = D.sedeLavorativa) JOIN Ordine O ON (D.CF = O.gestore) JOIN Dettagli_ordine_v dv\
        ON (O.ricevuta = dv.ordineV) JOIN Prodotto p ON (dv.prodottoV = p.codice)\
        GROUP BY (S.codice)\
        ) AS tot\
        GROUP BY tot.città",

        "SELECT D.nome, D.cognome, D.ruolo, COUNT(o.ricevuta) AS ordini\
        FROM Dipendente D JOIN Sede S ON (D.sedeLavorativa = S.codice) JOIN Ordine o ON (D.CF = o.gestore)\
        GROUP BY (D.CF)\
        ORDER BY (ordini) DESC",

        "SELECT D.nome, D.cognome, D.ruolo, C.fine\
        FROM Dipendente D JOIN Contratto C ON (D.CF = C.dipendente)\
        WHERE C.fine >= '1/1/2023' AND C.fine <= '12/31/2023'",
        
        "SELECT C.mail, Oo.ricevuta, O.data\
        FROM Cliente C JOIN Ordine_online Oo ON (C.mail = Oo.cliente) JOIN dettagli_ordine_v d\
        ON (Oo.ricevuta = d.ordineV) JOIN Prodotto P ON (d.prodottoV = P.codice), Ordine O\
        WHERE C.sezioneAIA = true AND P.codice = 14 AND d.quantità >= 15 AND Oo.ricevuta = O.ricevuta"
    };
    char queryTemp[1800];
    int i = -1;
    while (i!=0)
    {
        std::cout << "Selezionare una delle query disponibili:\n\
    1. Visualizza i dipendenti che hanno effettuato una richiesta di ferie per ferragosto e lo stato di approvazione in cui si trova\n\
    2. Visualizza la spesa mensile di ogni sede per gli stipendi dei dipendenti\n\
    3. Visualizza i 10 prodotti più venduti (sia online che in negozio) ordinati in modo decrescente per pezzi venduti\n\
    4. Visualizza i prodotti che hanno ricevuto almeno 5 valutazioni ordinati per punteggio in modo decrescente\n\
    5. Visualizza il numero di ordini online gestiti dai diversi magazzinieri nel 2023 ordinati in modo decrescente\n\
    6. Stampa tutte le valutazioni effettuate da un cliente su prodotti ordinati online, visualizzando ID dell'ordine, la data della recensione, il nome del prodotto, il voto e l'eventuale testo\n\
    7. Visualizza il ricavato ottenuto dagli ordini (sia online che in negozio) per ogni sede\n\
    8. Visualizza i dipendenti e il numero di ordini che hanno gestito, in ordine decrescente\n\
    9. Visualizza i dipendenti che hanno un contratto in scadenza nel 2023 con la relativa data di fine\n\
    10. Visualizza tutti gli ordini effettuati dalle sezioni AIA che includevano almeno 15 divise da gara\n\
    0. esci\n\
Esegui query n: ";
        std::cin >> i ;
        std::cout << "\v";

        if (i == 0)
            break;
        else if (i <= 10 && i>=1){
            if (i==6) {
                char cliente[30];
                std::cout << "Inserisci la mail del cliente: ";
                std::cin >> cliente;
                sprintf(queryTemp, query[5], cliente, cliente, cliente , cliente);
                printQuery(execute(conn, queryTemp));
            
            }
            else
                printQuery(execute(conn, query[i-1]));
        }
        else std::cout << "Scelta non valida! \n";
        std::cout<< "\v";
        
    }
    std::cout <<"Esco da programma..";
    return 0;
}
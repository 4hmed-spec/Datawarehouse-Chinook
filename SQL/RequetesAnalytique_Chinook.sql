
'''1. Quel pays a le plus grand nombre de clients ?'''

SELECT Country,TotalClients
FROM (SELECT customer.Country, COUNT(*) AS TotalClients
FROM Customer 
GROUP BY customer.Country
ORDER BY TotalClients DESC
)
WHERE ROWNUM = 1;

'''2. Quel client a dépensé le plus d’argent ?'''

SELECT 
    FirstName,
    LastName,
    TotalSpent
FROM (
    SELECT 
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.Total) AS TotalSpent
    FROM 
        Customer
    JOIN 
        Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY 
        Customer.FirstName, Customer.LastName
    ORDER BY 
        TotalSpent DESC
)
WHERE ROWNUM = 1;


''' 3. Quel album et de quel artiste, contient le plus de titres ? '''
SELECT 
    Artist.Name AS ArtistName,
    Album.Title AS AlbumTitle,
    NumberOfTracks
FROM (
    SELECT 
        Album.AlbumId,
        Album.Title,
        Artist.Name,
        COUNT(Track.TrackId) AS NumberOfTracks
    FROM 
        Album
    JOIN 
        Artist ON Album.ArtistId = Artist.ArtistId
    JOIN 
        Track ON Album.AlbumId = Track.AlbumId
    GROUP BY 
        Album.AlbumId, Album.Title, Artist.Name
    ORDER BY 
        NumberOfTracks DESC
)
WHERE ROWNUM = 1;


''' 3. Quel album et de quel artiste, contient le plus de titres ? '''


SELECT name,title,Nombredetitre
FROM (
    SELECT 
        Album.AlbumId,
        Album.Title,
        Artist.Name,
        COUNT(Track.TrackId) AS Nombredetitre
    FROM 
        Album
    JOIN 
        Artist ON Album.ArtistId = Artist.ArtistId
    JOIN 
        Track ON Album.AlbumId = Track.AlbumId
    GROUP BY 
        Album.AlbumId, TITLE, Artist.Name
    ORDER BY 
        Nombredetitre DESC
)
WHERE ROWNUM = 1;

''' 4. Quel genre de musique est le plus représenté ? '''

SELECT distinct genre.name, count(track.genreid) as GenreNumero1
FROM TRACK JOIN GENRE ON GENRE.Genreid = Track.Genreid
GROUP BY genre.name
FETCH FIRST 1 ROW ONLY



'''5. Affichez la durée en minutes, et secondes de l’album le plus long'''
SELECT Album.Title, Track.AlbumId,ROUND(((SUM(track.milliseconds) / 1000) / 60),2) as Temps
FROM ALBUM JOIN TRACK ON album.albumid = track.albumid
GROUP BY album.title , track.albumid
ORDER BY Temps DESC
FETCH FIRST 1 ROW ONLY


'''6. Combien d’artistes ne sont associés à aucun album ?'''
SELECT COUNT(Artist.ArtistId) as ArtistSansAlbum
FROM ARTIST LEFT JOIN ALBUM ON Artist.ArtistId = Album.ArtistId
WHERE album.artistid IS NULL

'''7. Le nombre d’albums composés de chansons de genres différents ? '''

SELECT COUNT(*) AS NbAlbumsMultiGenres
FROM (
    SELECT Album.AlbumId
    FROM Album
    INNER JOIN Track ON Album.AlbumId = Track.AlbumId
    INNER JOIN Genre ON Track.GenreId = Genre.GenreId
    GROUP BY Album.AlbumId
    HAVING COUNT(DISTINCT Genre.GenreId) > 1
);


'''8. Le pourcentage de chansons jamais achetées
'''

SELECT 
  ROUND(COUNT(CASE WHEN il.TrackId IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS PourcentageChansonsJamaisAchetees
FROM 
  Track t
  LEFT JOIN InvoiceLine il ON t.TrackId = il.TrackId;

'''9. Le nombre de clients qui ont dépensé plus que le montant total moyen
dépensé par tous les clients
'''
SELECT COUNT(*) AS ClientSupMoyenne
FROM (
    SELECT customerid, SUM(total) AS total_par_client
    FROM invoice
    GROUP BY customerid
) client_totaux
WHERE total_par_client > (
    SELECT AVG(total_client)
    FROM (
        SELECT customerid, SUM(total) AS total_client
        FROM invoice
        GROUP BY customerid
    )
);








''' 10. Identifiez lartiste le plus vendu du genre musical le plus populaire 
'''

--- Je prend en compte le fait que le genre populaire n'est pas forcement celui qui genere le plus mais celui qui apparait le plus ---

SELECT artist.name, COUNT(invoiceline.invoicelineid) AS nbvente
FROM artist 
INNER JOIN album ON artist.artistid = album.artistid 
INNER JOIN track ON track.albumid = album.albumid
INNER JOIN genre ON track.genreid = genre.genreid
INNER JOIN invoiceline ON invoiceline.trackid = track.trackid
WHERE genre.genreid = (
    SELECT genre.genreid
    FROM genre 
    INNER JOIN track ON track.genreid = genre.genreid
    GROUP BY genre.genreid
    ORDER BY COUNT(track.genreid) DESC
    FETCH FIRST 1 ROW ONLY
)
GROUP BY artist.name
ORDER BY nbvente DESC
FETCH FIRST 1 ROW ONLY;


'''11. Classez les pistes de chaque album par durée
'''

SELECT album.title AS titre, track.name AS piste, 
       ROUND(track.milliseconds / 1000 / 60, 2) AS temps
FROM track
INNER JOIN album ON track.albumid = album.albumid
ORDER BY temps DESC;


'''12. Calculez les dépenses des clients par rapport à la moyenne de leur pays'''
SELECT 
    Customer.FirstName || ' ' || Customer.LastName AS NomClient,
    Customer.Country AS Pays,
    SUM(Invoice.Total) AS TotalDepensesClient,
    ROUND(AVG(SUM(Invoice.Total)) OVER (PARTITION BY Customer.Country), 2) AS MoyennePays,
    ROUND(SUM(Invoice.Total) - AVG(SUM(Invoice.Total)) OVER (PARTITION BY Customer.Country), 2) AS EcartParRapportMoyenne
FROM 
    Customer
JOIN 
    Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY 
    Customer.CustomerId, Customer.FirstName, Customer.LastName, Customer.Country;

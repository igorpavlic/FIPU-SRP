-- ============================================================
-- SQL upiti za Tableau / PowerBI
-- Baza: fipu_srp_projekt (MySQL)
-- Spoji se na bazu i koristi ove upite kao data source
-- ============================================================


-- ============================================================
-- 1. GLAVNI UPIT — Denormalizirani pogled na fact tablicu
--    Koristi kao primarni data source u Tableau/PowerBI
-- ============================================================

SELECT
    f.ticket_id,
    p.naziv_projekta                          AS projekt,
    r.ime_prezime                             AS reporter,
    a.ime_prezime                             AS assignee,
    pr.razina_prioriteta                      AS prioritet,
    s.naziv_statusa                           AS status,
    f.vrijeme_key                             AS datum_kreiranja,
    v.dan,
    v.mjesec,
    v.godina,
    v.kvartal,
    v.dan_u_tjednu,
    ROUND(f.vrijeme_rjesavanja_sati, 2)       AS sati_rjesavanja,
    ROUND(f.vrijeme_rjesavanja_sati / 24, 2)  AS dana_rjesavanja,
    f.broj_komentara,
    ROUND(f.sati_open, 2)                     AS sati_open,
    ROUND(f.sati_in_progress, 2)              AS sati_in_progress,
    ROUND(f.sati_resolved, 2)                 AS sati_resolved,
    ROUND(f.sati_waiting, 2)                  AS sati_waiting
FROM fact_support_tickets f
JOIN dim_projekt p          ON f.projekt_key = p.projekt_key
JOIN dim_tehnicar r         ON f.reporter_key = r.tehnicar_key
LEFT JOIN dim_tehnicar a    ON f.assignee_key = a.tehnicar_key
JOIN dim_prioritet pr       ON f.prioritet_key = pr.prioritet_key
JOIN dim_status s           ON f.status_key = s.status_key
JOIN dim_vrijeme v          ON f.vrijeme_key = v.vrijeme_key;


-- ============================================================
-- 2. KPI: Broj ticketa po projektu
-- ============================================================

SELECT
    p.naziv_projekta AS projekt,
    COUNT(*)         AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_projekt p ON f.projekt_key = p.projekt_key
GROUP BY p.naziv_projekta
ORDER BY broj_ticketa DESC;


-- ============================================================
-- 3. KPI: Prosjecno vrijeme rjesavanja po prioritetu
-- ============================================================

SELECT
    pr.razina_prioriteta                              AS prioritet,
    COUNT(*)                                          AS broj_ticketa,
    ROUND(AVG(f.vrijeme_rjesavanja_sati), 1)          AS avg_sati,
    ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1)     AS avg_dana
FROM fact_support_tickets f
JOIN dim_prioritet pr ON f.prioritet_key = pr.prioritet_key
WHERE f.vrijeme_rjesavanja_sati IS NOT NULL
GROUP BY pr.razina_prioriteta
ORDER BY avg_sati DESC;


-- ============================================================
-- 4. KPI: Mjesecni trend volumena ticketa
-- ============================================================

SELECT
    v.godina,
    v.mjesec,
    COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_vrijeme v ON f.vrijeme_key = v.vrijeme_key
GROUP BY v.godina, v.mjesec
ORDER BY v.godina, v.mjesec;


-- ============================================================
-- 5. KPI: Prosjecno workflow vrijeme po stanju
-- ============================================================

SELECT
    ROUND(AVG(f.sati_open), 1)        AS avg_sati_open,
    ROUND(AVG(f.sati_in_progress), 1) AS avg_sati_in_progress,
    ROUND(AVG(f.sati_resolved), 1)    AS avg_sati_resolved,
    ROUND(AVG(f.sati_waiting), 1)     AS avg_sati_waiting
FROM fact_support_tickets f;


-- ============================================================
-- 6. KPI: Top 10 tehnicara po opterecenju
-- ============================================================

SELECT
    t.ime_prezime                                  AS tehnicar,
    COUNT(*)                                       AS broj_ticketa,
    ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1)  AS avg_dana
FROM fact_support_tickets f
JOIN dim_tehnicar t ON f.assignee_key = t.tehnicar_key
GROUP BY t.ime_prezime
ORDER BY broj_ticketa DESC
LIMIT 10;


-- ============================================================
-- 7. KPI: Status ticketa po projektu
-- ============================================================

SELECT
    p.naziv_projekta   AS projekt,
    s.naziv_statusa    AS status,
    COUNT(*)           AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_projekt p          ON f.projekt_key = p.projekt_key
JOIN dim_status s ON f.status_key = s.status_key
GROUP BY p.naziv_projekta, s.naziv_statusa
ORDER BY p.naziv_projekta, broj_ticketa DESC;


-- ============================================================
-- 8. KPI: Ticketi po danu u tjednu i kvartalu
-- ============================================================

SELECT
    v.dan_u_tjednu,
    v.kvartal,
    COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_vrijeme v ON f.vrijeme_key = v.vrijeme_key
GROUP BY v.dan_u_tjednu, v.kvartal
ORDER BY v.kvartal, v.dan_u_tjednu;


-- ============================================================
-- 9. KPI: Sazetak
-- ============================================================

SELECT
    COUNT(*)                                        AS ukupno_ticketa,
    COUNT(DISTINCT f.projekt_key)                   AS broj_projekata,
    COUNT(DISTINCT f.reporter_key)                  AS broj_reportera,
    COUNT(DISTINCT f.assignee_key)                  AS broj_assigneea,
    ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1)   AS avg_dana_rjesavanja,
    ROUND(AVG(f.broj_komentara), 1)                 AS avg_komentara
FROM fact_support_tickets f;

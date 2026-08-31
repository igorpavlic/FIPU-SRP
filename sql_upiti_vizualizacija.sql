-- ============================================================
-- SQL upiti za Tableau / PowerBI
-- Baza: fipu_srp_projekt (MySQL)
-- Star shema: dim_tehnicar, dim_projekt_prioritet_status (junk), dim_vrijeme
-- ============================================================


-- ============================================================
-- 1. GLAVNI UPIT — Denormalizirani pogled na fact tablicu
-- ============================================================

SELECT
    f.ticket_id,
    j.naziv_projekta                          AS projekt,
    r.ime_prezime                             AS reporter,
    a.ime_prezime                             AS assignee,
    j.razina_prioriteta                       AS prioritet,
    j.naziv_statusa                           AS status,
    f.vrijeme_key                             AS datum_kreiranja,
    v.dan, v.mjesec, v.godina, v.kvartal, v.dan_u_tjednu,
    ROUND(f.vrijeme_rjesavanja_sati, 2)       AS sati_rjesavanja,
    ROUND(f.vrijeme_rjesavanja_sati / 24, 2)  AS dana_rjesavanja,
    f.broj_komentara,
    ROUND(f.sati_open, 2)                     AS sati_open,
    ROUND(f.sati_in_progress, 2)              AS sati_in_progress,
    ROUND(f.sati_resolved, 2)                 AS sati_resolved,
    ROUND(f.sati_waiting, 2)                  AS sati_waiting
FROM fact_support_tickets f
JOIN dim_tehnicar r                  ON f.reporter_key = r.tehnicar_key
LEFT JOIN dim_tehnicar a             ON f.assignee_key = a.tehnicar_key
JOIN dim_projekt_prioritet_status j  ON f.projekt_prioritet_status_key = j.projekt_prioritet_status_key
JOIN dim_vrijeme v                   ON f.vrijeme_key = v.vrijeme_key;


-- ============================================================
-- 2. KPI: Broj ticketa po projektu
-- ============================================================

SELECT j.naziv_projekta AS projekt, COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_projekt_prioritet_status j ON f.projekt_prioritet_status_key = j.projekt_prioritet_status_key
GROUP BY j.naziv_projekta
ORDER BY broj_ticketa DESC;


-- ============================================================
-- 3. KPI: Prosjecno vrijeme rjesavanja po prioritetu
-- ============================================================

SELECT j.razina_prioriteta AS prioritet, COUNT(*) AS broj_ticketa,
       ROUND(AVG(f.vrijeme_rjesavanja_sati), 1) AS avg_sati,
       ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1) AS avg_dana
FROM fact_support_tickets f
JOIN dim_projekt_prioritet_status j ON f.projekt_prioritet_status_key = j.projekt_prioritet_status_key
WHERE f.vrijeme_rjesavanja_sati IS NOT NULL
GROUP BY j.razina_prioriteta
ORDER BY avg_sati DESC;


-- ============================================================
-- 4. KPI: Mjesecni trend
-- ============================================================

SELECT v.godina, v.mjesec, COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_vrijeme v ON f.vrijeme_key = v.vrijeme_key
GROUP BY v.godina, v.mjesec
ORDER BY v.godina, v.mjesec;


-- ============================================================
-- 5. KPI: Workflow vrijeme
-- ============================================================

SELECT ROUND(AVG(f.sati_open), 1) AS avg_sati_open,
       ROUND(AVG(f.sati_in_progress), 1) AS avg_sati_in_progress,
       ROUND(AVG(f.sati_resolved), 1) AS avg_sati_resolved,
       ROUND(AVG(f.sati_waiting), 1) AS avg_sati_waiting
FROM fact_support_tickets f;


-- ============================================================
-- 6. KPI: Top 10 tehnicara
-- ============================================================

SELECT t.ime_prezime AS tehnicar, COUNT(*) AS broj_ticketa,
       ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1) AS avg_dana
FROM fact_support_tickets f
JOIN dim_tehnicar t ON f.assignee_key = t.tehnicar_key
GROUP BY t.ime_prezime
ORDER BY broj_ticketa DESC
LIMIT 10;


-- ============================================================
-- 7. KPI: Status po projektu
-- ============================================================

SELECT j.naziv_projekta AS projekt, j.naziv_statusa AS status, COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_projekt_prioritet_status j ON f.projekt_prioritet_status_key = j.projekt_prioritet_status_key
GROUP BY j.naziv_projekta, j.naziv_statusa
ORDER BY j.naziv_projekta, broj_ticketa DESC;


-- ============================================================
-- 8. KPI: Dan u tjednu × kvartal
-- ============================================================

SELECT v.dan_u_tjednu, v.kvartal, COUNT(*) AS broj_ticketa
FROM fact_support_tickets f
JOIN dim_vrijeme v ON f.vrijeme_key = v.vrijeme_key
GROUP BY v.dan_u_tjednu, v.kvartal
ORDER BY v.kvartal, v.dan_u_tjednu;


-- ============================================================
-- 9. KPI: Sazetak
-- ============================================================

SELECT COUNT(*) AS ukupno_ticketa,
       COUNT(DISTINCT j.naziv_projekta) AS broj_projekata,
       COUNT(DISTINCT f.reporter_key) AS broj_reportera,
       COUNT(DISTINCT f.assignee_key) AS broj_assigneea,
       ROUND(AVG(f.vrijeme_rjesavanja_sati) / 24, 1) AS avg_dana_rjesavanja,
       ROUND(AVG(f.broj_komentara), 1) AS avg_komentara
FROM fact_support_tickets f
JOIN dim_projekt_prioritet_status j ON f.projekt_prioritet_status_key = j.projekt_prioritet_status_key;

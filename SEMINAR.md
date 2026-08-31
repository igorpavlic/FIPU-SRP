Sveučilište Jurja Dobrile u Puli<br>
Prijediplomski sveučilišni studij Informatika<br>

<br><br>
<p align="center">
  <img src="https://fipu.unipu.hr/_pub/themes_static/unipu2020/fipu/icons/fipu_hr.png" alt="FIPU logo" width="500">
</p>
<br><br>


<p align="center"><strong style="font-size: 22px;">Analiza helpdesk sustava i optimizacija procesa rješavanja ticketa</strong></p>
<br><br><br><br>

Seminarski rad<br>
Ime i Prezime: Igor Pavlić<br>
JMBAG: 0069012453<br>
Kolegij: Skladišta i rudarenje podataka<br>
Mentor: izv. prof. dr. sc. Goran Oreški<br>

<br><br><br><br>
Senj, svibanj 2026.

<div style="page-break-before: always;"></div>

## Sadržaj

1. Uvod
2. Eksplorativna analiza podataka (EDA)
   - 2.1. Odabir i opis skupa podataka
   - 2.2. Analiza skupa podataka
   - 2.3. Predprocesiranje podataka
3. Dizajn i implementacija relacijskog modela
   - 3.1. Priprema i podjela podataka
   - 3.2. Konceptualni model (ER dijagram)
   - 3.3. Relacijski model baze podataka
   - 3.4. Implementacija baze u MySQL-u
   - 3.5. Provjera podataka
4. Dimenzijski model podataka
   - 4.1. Osnove dimenzijskog modeliranja
   - 4.2. Izrada zvjezdastog (star) modela
5. ETL proces
   - 5.1. Ekstrakcija podataka
   - 5.2. Transformacija podataka
   - 5.3. Učitavanje podataka
6. Vizualizacija i poslovna analiza
   - 6.1. Dashboard #1 — Pregled sustava
   - 6.2. Dashboard #2 — Analiza outliera
   - 6.3. Dashboard #3 — Distribucija
   - 6.4. Dashboard #4 — Kvaliteta podataka
7. Generalizacija rezultata
8. Zaključak
9. Literatura

<div style="page-break-before: always;"></div>

## 1. Uvod

U suvremenom poslovnom okruženju, helpdesk sustavi generiraju velike količine podataka o korisničkim zahtjevima, njihovom rješavanju i performansama tima podrške. Učinkovita analiza ovih podataka ključna je za optimizaciju procesa, smanjenje vremena rješavanja i bolje planiranje resursa.

U ovom radu razvijen je sustav poslovne inteligencije koristeći stvarni skup podataka helpdesk ticketa koji sadrži 66.691 zapis iz 15 projekata u periodu od 2007. do 2023. godine. Podaci uključuju informacije o životnom ciklusu svakog ticketa: tko ga je prijavio, tko rješava, koliko koraka je prošao kroz workflow, koliko vremena je proveo u svakom stanju i kako je završen.

Rad obuhvaća cijeli proces izgradnje skladišta podataka — od eksplorativne analize i čišćenja podataka, preko dizajna relacijskog i dimenzijskog modela, do ETL procesa i vizualizacije u Power BI-ju. Cilj je demonstrirati kako se kroz proces poslovne inteligencije može razviti sustav za analizu učinkovitosti helpdesk sustava i identificaciju uskih grla u procesu rješavanja ticketa.

---

## 2. Eksplorativna analiza podataka (EDA)

### 2.1. Odabir i opis skupa podataka

Skup podataka preuzet je s platforme za dijeljenje istraživačkih podataka i sadrži helpdesk tickete iz stvarnog helpdesk sustava. Izvorni dataset (`Support_tickets_named.csv`) sadrži 66.691 redaka i 58 stupaca.

Ključne karakteristike skupa podataka:

| Karakteristika | Vrijednost |
|----------------|-----------|
| Broj ticketa | 66.691 |
| Period | 2007 — 2023 |
| Broj projekata | 15 |
| Broj osoba | 100 (reporteri + tehničari) |
| Stupaca | 58 (identifikatori, datumi, kategorije, workflow metrike) |

Stupci se dijele u nekoliko kategorija: identifikatori (id, issue_num), kategorijski atributi (issue_proj, issue_type, issue_priority, issue_status, issue_resolution), datumski stupci (issue_created, issue_resolution_date), numeričke metrike (wf_total_time, processing_steps, issue_comments_count) i workflow stupci — za svako stanje postoji `wf_{stanje}` (vrijeme provedeno u stanju, u sekundama) i `wfe_{stanje}` (broj ulazaka u stanje).

### 2.2. Analiza skupa podataka

Eksplorativna analiza otkrila je nekoliko ključnih karakteristika dataseta:

**Nedostajuće vrijednosti:** 51% ticketa ima prioritet "unknown", 47% nema dodijeljenog tehničara (assignee), a 16 od 58 stupaca ima više od 90% NULL vrijednosti (rijetko korišteni workflow statusi poput wf_deployment, wf_cancelled, wf_validation).

**Distribucija tipova ticketa:** Ticket dominira (68%), zatim Service (8%), Subtask (7%), Story (7%), i ostali tipovi s manjim udjelima.

**Distribucija prioriteta:** Unknown (51%), Medium (37%), High (7%), Highest (3%), Blocker (1%), Low (1%), Lowest (<1%).

**Tri segmenta ticketa:** Analiza je otkrila da dataset sadrži tri potpuno različite populacije: "ghost ticketi" (33%) — ticketi s jednim korakom, unknown prioritetom i bez assigneea, s medijanom rješavanja od 2.277 dana; aktivni ticketi s assigneeom (53%) — medijan 9 dana; i ostali (14%) — medijan 15 dana.

*Slika 1: Rezultati eksplorativne analize*

### 2.3. Predprocesiranje podataka

Predprocesiranje je provedeno u sljedećim koracima:

1. **Uklanjanje stupaca s >90% NULL:** Uklonjeno je 16 stupaca čiji podaci nisu dovoljno zastupljeni za analizu. Od 58 stupaca ostalo je 42.

2. **Standardizacija naziva:** Svi nazivi stupaca pretvoreni su u lowercase s underscore separatorom.

3. **Provjera duplikata:** Potvrđeno je da nema duplikata u datasetu.

4. **Podjela na trening i test skup:** Dataset je podijeljen na 80% za dizajn i implementaciju (53.353 redaka) i 20% za validaciju generalizacije (13.338 redaka) korištenjem fiksnog seeda (`random_state=1`) za reproducibilnost.

*Slika 2: Rezultati predprocesiranja*

---

## 3. Dizajn i implementacija relacijskog modela

### 3.1. Priprema i podjela podataka

Glavni CSV skup podataka podijeljen je na dva dijela: 80% podataka korišteno je za dizajn, implementaciju i punjenje svih tablica u relacijskoj bazi, čime je osigurano da su svi entiteti i odnosi ispravno definirani. Preostalih 20% izdvojeno je za provjeru ispravnosti ETL procesa i validaciju analitičkih modela.

### 3.2. Konceptualni model (ER dijagram)

Na temelju analize podataka identificirano je sedam glavnih entiteta: project, person, issue_type, priority, status, resolution i centralna tablica support_ticket. Svaki entitet izvučen je iz originalnog flat CSV-a normalizacijom.

Ključne karakteristike modela:
- `person` se referencira dvaput iz `support_ticket` — jednom kao reporter, jednom kao assignee
- `assignee_fk` je nullable jer 46% ticketa nema dodijeljenu osobu
- Svi lookup entiteti imaju INT primarni ključ i VARCHAR atribut

*Slika 3: ER dijagram relacijskog modela*

### 3.3. Relacijski model baze podataka

Relacijski model implementiran je kao staging tablica `support_tickets` u MySQL bazi `fipu_srp_projekt`. Umjesto standardnog `to_sql()` koji generira neoptimalne tipove podataka (datume kao TEXT, ID-ove kao DOUBLE), definirano je 42 eksplicitnih SQL tipova korištenjem SQLAlchemy `dtype` parametra:

- Datumi (`started`, `issue_created`, itd.) → DATETIME umjesto TEXT
- Identifikatori (`id`, `issue_num`) → INTEGER umjesto DOUBLE
- Stringovi (`issue_proj`, `issue_type`, itd.) → VARCHAR(50/255) umjesto TEXT
- Workflow trajanja (`wf_open`, `wf_total_time`, itd.) → FLOAT

### 3.4. Implementacija baze u MySQL-u

Implementacija je provedena korištenjem Pythona (pandas + SQLAlchemy) s `python-dotenv` za sigurno upravljanje pristupnim podacima. Lozinka baze nikada nije hardkodirana u notebookovima, već se čita iz `.env` datoteke.

Import u bazu izvršen je s `to_sql(if_exists='replace', dtype=sql_dtypes, chunksize=5000)` za batch unos podataka.

*Slika 4: Rezultat importa u MySQL — DESCRIBE support_tickets*

### 3.5. Provjera podataka

Nakon importa provedeno je pet provjera kvalitete:

| Provjera | Rezultat |
|----------|---------|
| Broj redaka CSV = SQL | 53.353 = 53.353 ✓ |
| Dupli ID-ovi | 0 ✓ |
| NULL u ključnim stupcima | Samo assignee: 24.771 (46%) — očekivano |
| Konzistentnost mapiranja | 1 projekt = 1 ime ✓ |
| Distribucije | Poklapaju se s EDA ✓ |

---

## 4. Dimenzijski model podataka

### 4.1. Osnove dimenzijskog modeliranja

Za razliku od relacijskog modela koji je optimiziran za transakcijsku obradu (OLTP), dimenzijski model organizira podatke za analitičke upite (OLAP). Centralna tablica činjenica sadrži numeričke metrike i strane ključeve prema dimenzijskim tablicama koje sadrže opisne atribute.

U ovom projektu dimenzijski model temelji se na analizi poslovnog procesa helpdesk podrške. Svrha je omogućiti višedimenzionalni pogled na performanse rješavanja ticketa kroz različite aspekte: projekt, prioritet, status, tip ticketa, rezoluciju, tehničara i vrijeme.

### 4.2. Izrada zvjezdastog (star) modela

Star shema sastoji se od 5 dimenzijskih tablica i 1 tablice činjenica:

**Dimenzijske tablice:**

| Dimenzija | PK | Atributi | Redaka |
|-----------|-----|---------|--------|
| dim_tehnicar | tehnicar_key (INT AI) | ime_prezime | 100 |
| dim_projekt_prioritet_status | projekt_prioritet_status_key (INT AI) | naziv_projekta, razina_prioriteta, naziv_statusa | ~330 |
| dim_tip_ticketa | tip_ticketa_key (INT AI) | naziv_tipa | 15 |
| dim_rezolucija | rezolucija_key (INT AI) | naziv_rezolucije | 4 |
| dim_vrijeme | vrijeme_key (DATE) | dan, mjesec, godina, kvartal, dan_u_tjednu | ~4.700 |

`dim_projekt_prioritet_status` je junk dimenzija koja kombinira tri kategorijske varijable (projekt, prioritet, status) u jednu tablicu. Teoretski max je 15 × 7 × 15 = 1.575 kombinacija, ali samo ~330 stvarno postoji u podacima.

`dim_tehnicar` se koristi dvostruko — kao reporter i kao assignee, pri čemu je assignee nullable (46% ticketa nema dodijeljenog tehničara).

**Grain:** Jedan redak u tablici `fact_support_tickets` predstavlja jedan helpdesk ticket.

**Tablica činjenica `fact_support_tickets`:**

| Stupac | Tip | Opis |
|--------|-----|------|
| ticket_id | INT PK | Primarni ključ |
| reporter_key | INT FK | → dim_tehnicar |
| assignee_key | INT FK (nullable) | → dim_tehnicar |
| projekt_prioritet_status_key | INT FK | → dim_projekt_prioritet_status |
| tip_ticketa_key | INT FK | → dim_tip_ticketa |
| rezolucija_key | INT FK (nullable) | → dim_rezolucija |
| vrijeme_key | DATE FK | → dim_vrijeme |
| vrijeme_rjesavanja_sati | FLOAT | Ukupno vrijeme rješavanja (sati) |
| broj_komentara | INT | Broj komentara na ticketu |
| sati_open | FLOAT | Vrijeme u stanju "open" (sati) |
| sati_in_progress | FLOAT | Vrijeme u stanju "in_progress" (sati) |
| sati_resolved | FLOAT | Vrijeme u stanju "resolved" (sati) |
| sati_waiting | FLOAT | Vrijeme u stanju "waiting" (sati) |

DDL je implementiran korištenjem SQLAlchemy ORM-a s `declarative_base()` pristupom, gdje je svaka tablica definirana kao Python klasa, a `Base.metadata.create_all(engine)` automatski generira DDL s FK constraintima.

**Surrogate key logika:** Sve dimenzije koriste surrogate ključeve (AUTO_INCREMENT INT) umjesto prirodnih ključeva iz izvornog sustava. Prednosti su stabilnost identifikatora, bolje performanse JOIN operacija i podrška za eventualnu historizaciju (SCD).

*Slika 5: Star shema — ER dijagram dimenzijskog modela*

---

## 5. ETL proces

ETL (Extract, Transform, Load) proces je ključni dio projekta koji transformira podatke iz dva izvora u dimenzijski model spreman za analizu.

### 5.1. Ekstrakcija podataka

ETL proces koristi dva izvora podataka prema arhitekturi pripremnog područja (staging area):

**Izvor 1 — `Support_tickets_PROCESSED.csv`** je predprocesirani 80% skup s 53.353 redaka i 42 stupca. Nastao je u notebooku 2 uklanjanjem stupaca s >90% NULL vrijednosti i stratificiranim uzorkovanjem. Iz njega se grade sve dimenzije i fact tablica.

**Izvor 2 — `Support_tickets_named.csv`** je originalni puni dataset s 66.691 redaka i 58 stupaca. Sadrži 16 rijetkih `wf_*` stupaca koji su izbačeni predprocesiranjem (>90% NULL) ali ipak sadrže stvarne podatke za podskup ticketa:

| Stupac | Non-null redaka | Prosjek (sati) |
|--------|----------------|----------------|
| wf_validation | 2.961 | 603h |
| wf_reopened | 2.123 | 43h |
| wf_resolved_under_monitoring | 1.931 | 307h |
| wf_approved | 1.630 | 190h |
| wf_pending_deployment | 1.413 | 875h |

Oba izvora se spajaju u EXTRACT fazi LEFT JOIN-om po `id` stupcu — čime se čuva svih 53.353 ticketa iz Izvora 1, a Izvor 2 obogaćuje zapise s dodatnim workflow podacima gdje postoje.

### 5.2. Transformacija podataka

Transformacija uključuje dva ključna koraka:

**Izračun metrika:**

| Metrika | Izvor | Formula |
|---------|-------|---------|
| vrijeme_rjesavanja_sati | Izvor 1: issue_resolution_date − issue_created | `dt.total_seconds() / 3600` |
| sati_open | Izvor 1: wf_open (sekunde) | `/ 3600` |
| sati_in_progress | Izvor 1: wf_in_progress (sekunde) | `/ 3600` |
| sati_resolved | Izvor 1: wf_resolved (sekunde) | `/ 3600` |
| sati_waiting | Izvor 1: wf_waiting (sekunde) | `/ 3600` |
| sati_validation, sati_reopened... | Izvor 2: wf_* (sekunde) | `/ 3600` |

Ispravnost pretvorbe potvrđena je ručnom provjerom: ticket 11887 ima `wf_total_time = 1992`, a razlika između `issue_created` (08:23:43) i `issue_resolution_date` (08:56:55) iznosi točno 1992 sekunde (33 minute i 12 sekundi).

**Mapiranje stranih ključeva:** Za svaku dimenziju proveden je merge (JOIN) između izvornih podataka i dimenzijskih tablica kako bi se prirodni ključevi zamijenili surrogate ključevima. Posebna pažnja posvećena je korištenju LEFT JOIN-a za assignee (46% NULL) i rezoluciju (1.3% NULL) kako ne bi došlo do gubitka redaka.

*Slika 6: Rezultat ETL procesa — verifikacija broja redaka*

### 5.3. Učitavanje podataka

Učitavanje je provedeno u batch modu (`chunksize=5000`) s privremenim isključivanjem FK provjera za performanse. Na kraju je verifikacijom potvrđeno da sve tablice sadrže očekivani broj redaka te da nema izgubljenih podataka:

| Tablica | Redaka |
|---------|--------|
| dim_tehnicar | 100 |
| dim_projekt_prioritet_status | 330 |
| dim_tip_ticketa | 15 |
| dim_rezolucija | 4 |
| dim_vrijeme | ~4.700 |
| **fact_support_tickets** | **53.353** |

Provjera gubitka podataka izvršena je programski: `assert len(fact_final) == 53353` — potvrđeno da nijedan redak nije izgubljen u procesu mapiranja stranih ključeva.

---

## 6. Vizualizacija i poslovna analiza

Vizualizacija je provedena u Power BI Desktopu korištenjem denormaliziranog SQL upita koji spaja fact tablicu sa svim dimenzijama. Dashboard se sastoji od četiri stranice.

### 6.1. Dashboard #1 — Pregled sustava

Prva stranica prikazuje ukupne KPI-eve i pregled sustava:

- **53.353 ticketa** iz 15 projekata, s prosječnim vremenom rješavanja od 18.441 sati i medijanom 834,89 sati
- **Trend kroz vrijeme:** Volumen ticketa varira značajno po godinama, s vrhuncem 2015. (5.700 ticketa) i padom 2022. (1.388)
- **Ticketi po projektu:** Project Apollo vodi s 6.554 ticketa, Project Nexus je najmanji s 1.439
- **Vrijeme po prioritetu:** Medium (1.521 sati) i Lowest (1.435 sati) su sporiji od Blockera (1.254 sati) — što ukazuje na nekonzistentnu primjenu prioriteta
- **Top assigneei po volumenu:** Petra Marić (1,9K), Petar Marić (1,8K), Maja Kovačić (1,7K)
- **Self-assigned ticketi:** Dodatno je prikazan pregled tehničara koji su sebi dodijelili tickete. Josip Marić vodi s 34 self-assigned ticketa, što može ukazivati na specifičan radni proces ili nedostatak delegacije unutar tima.

*Slika 7: Dashboard — Pregled sustava*

### 6.2. Dashboard #2 — Analiza outliera

Outlieri su definirani kao ticketi iznad 95. percentila (6.499 sati ≈ 271 dan) među ticketima s poznatim prioritetom.

- **Normal vs Outlier po projektu:** Udio outliera varira od 19% (Project Helios) do 45% (Project Orion). Project Titan i Project Nexus su bez outliera u prikazu što ukazuje na manji uzorak.
- **Najgori slučajevi po prioritetu:** Unknown prioritet dostiže max od 99.221 sati (~11 godina), Blocker do 42.164 sati, Medium do 48.927 sati
- **Workflow analiza po prioritetu:** Posebno se ističe kategorija Lowest prioriteta s prosječno 2.324 sata čekanja (waiting) — višestruko više od Blockera (256 sati). Ovo je kontraintuitivno i ukazuje da ticketi najnižeg prioriteta zapravo čekaju dulje nego kritični. Blocker ticketi imaju najveće prosječno vrijeme u stanju "open" (822 sata), dok Highest provodi najviše u "waiting" (378 sati).

*Slika 8: Dashboard — Analiza outliera*

### 6.3. Dashboard #3 — Distribucija

- **Matrica projekt × prioritet:** Heatmap prikazuje koncentraciju ticketa — "unknown" prioritet dominira u svim projektima. Project Apollo ima najveći apsolutni broj unknown ticketa (3.697), dok Project Solaris ima najmanji (1.284). Ukupno je 27.156 ticketa bez prioriteta (51%).
- **Histogram vremena rješavanja:** Više od 21.700 ticketa (41%) traje dulje od 3 mjeseca. Distribucija ima izrazito dug desni rep koji ukazuje na postojanje outliera.
- **Distribucija po tipu ticketa:** Ticket dominira s 67,8% (36,17K), a ostali tipovi — Story, Service, HD Service, Task i Subtask — zajedno čine preostalih 32%.
- **Distribucija po rezoluciji:** 92,94% ticketa je riješeno s "Done", dok 4,54% otpada na "(Blank)" — neriješene tickete — i 2,51% na "Won't Do".

*Slika 9: Dashboard — Distribucija*

### 6.4. Dashboard #4 — Kvaliteta podataka

Četvrta stranica dashboarda posvećena je analizi kvalitete podataka i segmentaciji ticketa.

- **Prioritet po projektu:** Stacked bar prikazuje distribuciju poznatog i nepoznatog prioriteta po projektu. Project Solaris ima najveći udio poznatog prioriteta (66%), dok Project Apollo ima najveći apsolutni broj nepoznatih prioriteta (3,7K).
- **Has Assignee:** 53,57% ticketa ima dodijeljen assignee, dok 46,43% (24,77K) nema. Ovaj podatak je ključan jer analiza pokazuje da ticketi bez assigneea imaju medijan rješavanja ~190 puta duži od onih s assigneeom.
- **Segmentacija ticketa:** Ghost ticketi imaju prosječno ~50.000 sati rješavanja, aktivni ticketi s assigneeom ~1.000 sati, a ostali ~3.000 sati. Ova segmentacija objašnjava zašto ukupni prosjek (18.441 sati) toliko odstupa od medijana (835 sati).
- **Distribucija prioriteta:** 50,9% ticketa ima poznat prioritet, 49,1% je "unknown" — gotovo jednaka podjela koja sugerira sustavni propust u procesu kategorizacije ticketa.

*Slika 10: Dashboard — Kvaliteta podataka*

---

## 7. Generalizacija rezultata

Kako bi se potvrdilo da uvidi iz analize nisu artefakt uzorkovanja, provedena je validacija na 20% test skupu koji je izdvojen u fazi predprocesiranja. Uspoređene su ključne metrike:

| Metrika | Trening (80%) | Test (20%) | Razlika |
|---------|---------------|-----------|---------|
| Avg resolve (h) | 18.441 | 18.652 | <2% |
| Median resolve (h) | 835 | 848 | <2% |
| % unknown prioritet | 51% | 51% | <1pp |
| % bez assigneea | 46% | 47% | <1pp |
| Ghost ticketi udio | 33% | 32% | <1pp |
| Assignee efekt (faktor) | ~190x | ~190x | stabilan |
| steps↔resolve korelacija | -0.46 | -0.46 | stabilan |

Svi ključni uvidi potvrđeni su na test skupu s razlikama manjim od 5%. Jedina nestabilnost uočena je u kategorijama s malim uzorcima (Blocker: n≈525, Low: n≈560) gdje su medijani odstupali do 30% — što je očekivano za tako male uzorke.

Zaključak generalizacije: uvidi iz analize su pouzdani i primjenjivi na cjelokupni dataset.

---

## 8. Zaključak

Provedenom analizom helpdesk sustava, uz korištenje skladišta podataka i vizualizacijskih alata, uspješno je demonstrirana transformacija sirovih podataka o helpdesk ticketima u korisne poslovne uvide.

Ključni nalazi analize:

1. **Trećina dataseta su "ghost ticketi"** — 33% ticketa (21.680) nikad nije ušlo u stvarni workflow (1 korak, unknown prioritet, bez assigneea, status "closed"). Ovi ticketi imaju medijan rješavanja od 2.277 dana i dramatično podižu prosječno vrijeme rješavanja cijelog sustava.

2. **Prioritet funkcionira kad je postavljen** — ticketi s poznatim prioritetom imaju medijan rješavanja od 195 sati (8 dana), dok unknown ticketi imaju 39.682 sati (4.5 godina). Dodjela prioriteta je najvažniji korak za učinkovito rješavanje.

3. **Assignee je najjači prediktor** — ticketi s dodijeljenim tehničarom imaju medijan od 212 sati (9 dana), bez assigneea 39.682 sati. Faktor je ~190x.

4. **Negativna korelacija koraka i vremena** — više procesnih koraka je kontraintuitivno povezano s kraćim vremenom rješavanja (r = -0.46), jer ticketi s jednim korakom su upravo ghost ticketi koji čame godinama.

5. **Čekanje je glavni uzrok dugog rješavanja** — Lowest prioritet provodi prosječno 2.324 sata u čekanju, višestruko više od Blockera (256 sati). Ticketi ne kasne zbog aktivnog rada već zbog čekanja u redu.

6. **Rezolucija je pretežno pozitivna, ali postoje propusti** — 92,94% ticketa završava kao "Done", ali 4,54% ostaje bez rezolucije (Blank), što predstavlja ~2.400 neriješenih ticketa koji zahtijevaju pregled.

Rezultati omogućuju optimizaciju helpdesk procesa kroz smanjenje udjela unknown prioriteta, bržu dodjelu assigneea, identifikaciju i zatvaranje ghost ticketa, te praćenje ticketa koji dugo čekaju bez aktivnog rada.

---

## 9. Literatura

[1] Kimball, R., Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling*, 3rd Edition. Wiley.

[2] Inmon, W.H. (2005). *Building the Data Warehouse*, 4th Edition. Wiley.

[3] Dokumentacija dataseta — FEATURES.md (priloženo uz dataset)

[4] MySQL Documentation, https://dev.mysql.com/doc/

[5] SQLAlchemy Documentation, https://docs.sqlalchemy.org/

[6] Power BI Documentation, https://learn.microsoft.com/power-bi/

[7] pandas Documentation, https://pandas.pydata.org/docs/

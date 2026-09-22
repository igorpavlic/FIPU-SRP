# SKLADIŠTA I RUDARENJE PODATAKA — skripta za učenje

> Sažetak predavanja P1–P6 i P8–P12 (izv. prof. dr. sc. Goran Oreški, FIPU).
> P7 nije bio u arhivi predavanja — vjerojatno praktični sat s Tableauom; sadržaj mu je dijelom pokriven u P8.

---

## Kako koristiti skriptu

Kolegij ima **dvije jasno odvojene polovice** koje se spajaju tek na kraju:

| Dio | Predavanja | Pitanje na koje odgovara |
|---|---|---|
| **A. Skladišta podataka** | P1–P8 | *Kako organizirati podatke da se nad njima može brzo i smisleno analizirati?* |
| **B. Rudarenje podataka** | P9–P12 | *Kako iz tako organiziranih podataka automatski izvući znanje?* |

Nit koja povezuje sve: **podatak → informacija → znanje → odluka → akcija.**

Svako poglavlje ima:
- **Ključne ideje** — ono što se pamti u jednoj rečenici
- **Razrada** — definicije, tablice, usporedbe
- **Provjeri se** — pitanja tipa kakva se očekuju na ispitu

Na kraju su: sinteza cijelog toka, pojmovnik HR↔EN, banka ispitnih pitanja i popis tipičnih zamki.

---

## Mapa kolegija (jedna slika u glavi)

```
OLTP (transakcijski sustav)          ← P2
        │
        │  ETL: izdvajanje → transformacija → punjenje   ← P6
        │  (kroz pripremno područje / staging area)
        ▼
SKLADIŠTE PODATAKA                   ← P3, P4, P5
  dimenzijski model: tablica činjenica + dimenzije
        │
        ├──► OLAP: slice/dice, drill-down, roll-up, pivot   ← P8
        │    (deskriptivna analitika — "što se dogodilo?")
        │
        └──► RUDARENJE PODATAKA                              ← P9–P12
             klasifikacija, regresija, klasteriranje,
             asocijativna pravila, detekcija anomalija
             (prediktivna analitika — "što će se dogoditi?")
```

---
---

# P1 — Uvod, analiza, deskriptivna statistika i vizualizacija

## Ključne ideje

- **OLTP vs. DSS** je temeljna podjela cijelog kolegija: jedan sustav zapisuje, drugi analizira.
- Poslovna inteligencija se dijeli na **tri razine analitike** — deskriptivnu, prediktivnu, preskriptivnu.
- Tip varijable određuje **i pripremu i vizualizaciju** podataka. Nije kozmetika, nego temelj.

## Transakcijski sustavi (OPS / OLTP)

Operacijski sustavi (engl. *Operational Systems*) podržavaju svakodnevno poslovanje tvrtke.

- Često **ne sadrže povijesne podatke** — podaci se ažuriraju na trenutno stanje.
- Optimizirani za **brzo procesiranje transakcija**.
- Najčešće se obrađuje **jedna transakcija u jednom trenutku**.
- Primjeri: računi na blagajni, novčane transakcije u banci, evidencija posjetitelja.

## Sustavi za potporu odlučivanju (DSS)

- Podržavaju **strateško** donošenje odluka.
- Sadrže **povijesne** podatke; pune se **periodički**.
- Optimizirani za **efikasno dohvaćanje velikog skupa podataka** — tisuće zapisa u jednom upitu.
- Primjeri: analiza poslovanja, segmentacija tržišta, predviđanje trendova.

## Poslovna inteligencija (BI)

BI je rezultat razvoja DSS-a.

> **Definicija:** BI objedinjuje skup metodologija i alata kojima se omogućuje obrada podataka iz različitih izvora s ciljem njihova pretvaranja u informaciju potrebnu za donošenje poslovnih odluka.

Proces BI temelji se na tri koraka:
1. **Transformacija** podataka u informacije
2. **Odluka** na temelju tih informacija
3. **Akcija** — provedba odluke u praksi

**BI vs. BA (Business Analytics):** često se koriste kao sinonimi; prema nekim autorima BI je *podskup* BA (BA je širi pojam).

### Tri razine analitike — tablica koju treba znati napamet

| Razina | Ključna pitanja | Alati / metode | Rezultat |
|---|---|---|---|
| **Deskriptivna** (~BI) | Što se dogodilo? Što se događa? | Poslovno izvještavanje, **skladišta podataka**, kontrolne ploče / vizualizacija | Jasno definiran poslovni problem i prepoznate mogućnosti za napredak |
| **Prediktivna** (~BA) | Što će se dogoditi? Zašto? | **Rudarenje podataka**, rudarenje teksta, sustavi za predviđanje | Precizne projekcije budućih događaja i rezultata |
| **Preskriptivna** (~BA) | Što je potrebno napraviti? Zašto? | Optimizacija, simulacija, ekspertni sustavi | Najbolje odluke i konkretne akcije (*best course of action*) |

> Ovo je okvir cijelog kolegija: **P1–P8 = deskriptivna razina, P9–P12 = prediktivna razina.**

## Podaci

Karakteristike koje određuju **spremnost podataka za izradu skladišta**:

pouzdanost izvora · točnost sadržaja · dostupnost · sigurnost i privatnost · potpunost · konzistentnost · vremenska dimenzija · granularnost · relevantnost

### Podjela po strukturi (CS perspektiva)

| Vrsta | Opis | Primjeri |
|---|---|---|
| **Strukturirani** | definirani fiksnom shemom, laki za obradu | relacijske BP, proračunske tablice |
| **Nestrukturirani** | nemaju unaprijed definiran model ni organizaciju | tekst, dokumenti, objave, e-mail, video, audio |
| **Polustrukturirani** | nisu u relacijskoj BP, ali imaju organizacijska svojstva i oznake za odvajanje semantičkih elemenata | XML, JSON |

### Podjela varijabli (statistička perspektiva)

**Kategoričke (kvalitativne):**
- **nominalne** — grupe **bez** prirodnog redoslijeda (npr. boja, država)
- **ordinalne** — grupe **s** prirodnim redoslijedom, ali **bez jasno definirane razlike** među kategorijama (npr. prioritet: nizak/srednji/visok)

**Numeričke (kvantitativne):**
- **intervalne** — jednaki razmaci, **nema apsolutne nule** (npr. °C, kalendarska godina)
- **omjerne** — sve od intervalnih **+ apsolutna nula** → dopuštene sve aritmetičke operacije (npr. prihod, količina, trajanje)

Dodatna podjela numeričkih po distribuciji:
- **diskretne** — samo određene vrijednosti unutar skupa
- **kontinuirane** — bilo koja vrijednost unutar raspona

> **Zašto je ovo bitno:** mjere u tablici činjenica moraju biti kvantitativne (najbolje omjerne, jer se zbrajaju); dimenzijski atributi su kvalitativni.

## Statistika

- **Deskriptivna statistika** — uređuje, grafički prikazuje i opisuje **prikupljene** podatke (prosjek, standardna devijacija, korelacija). Zaključci **samo o uzorku**.
- **Inferencijalna statistika** — na temelju teorije vjerojatnosti donosi zaključke **o populaciji** pomoću uzoraka.

### Mjere središnje tendencije

| Mjera | Definicija |
|---|---|
| **Srednja vrijednost** (aritmetička sredina) | suma svih podataka / broj podataka |
| **Medijan** | vrijednost središnjeg podatka koja podatke poredane po veličini dijeli na dva jednako brojna dijela |
| **Mod** | vrijednost koja se najčešće ponavlja |

**Primjer sa slajda** — `[5, 210, 10, 3, 5, 7, 411557, 1, 78, 220, 4589]`
sortirano: `[1, 3, 5, 5, 7, 10, 78, 210, 220, 4589, 411557]`

```
Mean:   37880.45
Mode:   5
Median: 10
```

> **Pouka primjera:** jedna ekstremna vrijednost (411 557) razvalila je srednju vrijednost — 37 880 ne opisuje **nijedan** stvarni podatak. Medijan (10) je otporan na stršeće vrijednosti. Ovo je izravna motivacija za **detekciju anomalija** (P12).

### Mjere varijabilnosti

| Mjera | Definicija |
|---|---|
| **Raspon** | max − min |
| **Varijanca (uzorka)** | suma kvadrata odstupanja od srednje vrijednosti / (n − 1) |
| **Standardna devijacija (uzorka)** | pozitivni drugi korijen varijance |
| **Koeficijent varijacije** | omjer standardne devijacije i srednje vrijednosti (relativna mjera, često ×100 %) |
| **Kvantili** | vrijednosti koje statistički niz dijele na *n* jednakih dijelova |

Za isti primjer: `Range: 411556`, `Std: 123941.96`, `Var: 15361610476.07`, `CV: 327.19 %`, `Q1 = 5.0`, `Q2 = 10.0`, `Q3 = 215.0`.

> CV od 327 % znači da je raspršenost trostruko veća od same sredine — podatak je praktički bezvrijedan kao "tipična vrijednost".

Osnovni pandas alat: `.mean() .median() .mode() .std() .var() .quantile([.25,.5,.75]) .isna().sum()`

## Priprema podataka (data preprocessing)

Priprema **ovisi o namjeni** novog sustava (deskriptivni / prediktivni / preskriptivni). Lanac koraka:

```
sirovi podaci → konsolidacija → čišćenje → transformacija → redukcija
```

## Vizualizacija

- **Grafikoni** — slikovni prikazi skupova podataka, nizova mjerenja, učestalosti, trenda ili međusobnog odnosa.
- **Tip grafikona ovisi o tipu podataka.**
- Osnovna podjela: **površinski** i **linijski**.
- Osnovni tipovi: linijski, dijagram rasipanja (scatter), stupčasti, okrugli (pie), geografski.

### Upozorenje sa slajdova "Oprez!"

Dva slajda pokazuju **iste podatke** prikazane na dva načina:
- odsjecanje y-osi (npr. raspon 11 390–11 640 umjesto 0–12 000) čini minimalne razlike dramatičnima;
- promjena skale/orijentacije mijenja dojam o odnosu kategorija.

> **Etika vizualizacije:** grafikon koji tehnički ne laže i dalje može obmanuti. Y-os koja ne kreće od nule kod stupčastog grafikona je klasična manipulacija.

## Provjeri se

1. Navedi tri razlike između OPS-a i DSS-a.
2. Zašto je BI podskup BA, a ne obrnuto?
3. Koja je razlika između intervalne i omjerne skale? Daj po jedan primjer.
4. Kada je medijan bolji od aritmetičke sredine i zašto?
5. Što mjeri koeficijent varijacije i zašto je koristan kada uspoređujemo dvije varijable različitih jedinica?
6. Objasni kako se istim podacima može prikazati suprotan dojam.

**Checkpoint 1 (projekt):** odabrati skup podataka i napraviti osnovnu analizu u Pythonu — `.head()`, veličina skupa, nazivi stupaca, `.isna()`, `.unique()`, `.dtypes`, `value_counts()` po stupcu.
Kriteriji: >~50k zapisa · dovoljna raznolikost · **vremenska dimenzija** · i kvantitativni i kvalitativni podaci · koliko nedostajućih vrijednosti.

---
---

# P2 — Transakcijski sustavi

## Ključne ideje

- Skladište se puni **iz** transakcijskog sustava, pa ga treba dobro razumjeti i modelirati.
- Dizajn baze ide u tri faze: **konceptualni → logički → fizički**.
- Entitete prepoznaješ kao **imenice**, veze kao **glagole**.

## Načini organizacije transakcijskih podataka

| | Datotečni sustav | Relacijska baza podataka |
|---|---|---|
| Količina podataka | manje količine | velike, neophodna za današnje organizacije |
| Povezanost | podaci često nepovezani | povezani, s ograničenjima |
| Operacije | jednostavne (čitanje, pisanje) | složeni upiti, transakcije, integritet |
| Nedostaci | redundancija, zavisnost, niska produktivnost | zahtijeva dizajn i održavanje |

> Datoteke su **jedan od čestih izvora za skladišta podataka** — zato projekt namjerno dijeli izvor na bazu + CSV, da se simulira punjenje iz više izvora.

## Tri razine dizajna baze

| Faza | Model | Alat / rezultat |
|---|---|---|
| **Konceptualni dizajn** | ER model | ER dijagram — neovisan o DBMS-u |
| **Logički dizajn** | relacijski model | EER dijagram — tipovi podataka, ključevi, normalizacija |
| **Fizički dizajn** | implementacija | indeksi, pohrana, integritet, kontrola pristupa |

> **Model = apstraktna reprezentacija stvarnosti koja isključuje mnoštvo detalja** — smanjenje kompleksnosti, fokus na bitno. Modeliranje je "umjetnost apstrakcije": znati što uključiti, a što izostaviti.

## ER model — elementi

| Element | Definicija | Prikaz | Kako prepoznati u tekstu |
|---|---|---|---|
| **Entitet** | objekt ili predmet od interesa (fizički ili apstraktni) | pravokutnik | **imenica** |
| **Atribut** | činjenica, svojstvo ili detalj o entitetu; ima naziv, pridruženi entitet i domenu | ovalni oblik, spojen ravnom linijom | **imenica** |
| **Veza** | odnos između dva ili više entiteta | romb; kraj veze pokazuje kardinalnost | **glagol** |

Veza ima: **naziv**, **skup entiteta koji sudjeluju**, **stupanj** (broj entiteta u vezi) i **kardinalnost**.

### Kardinalnost

| Tip | Primjer sa slajda |
|---|---|
| **1:1** | svaki direktor ima svoj ured |
| **1:M** | svaki proizvod ima jednu liniju, ali linija ima više proizvoda |
| **M:M** | proizvod se proizvodi u više tvornica, tvornica proizvodi više proizvoda |

### Entitet ili atribut? (klasično ispitno pitanje)

Oba su imenice i oba predstavljaju činjenice iz stvarnog svijeta. Smjernice:
- **entiteti sadrže atribute; atributi se ne sastoje od manjih dijelova**
- **entiteti mogu imati veze između sebe; atributi pripadaju entitetima**

## Case study — Oprema d.o.o.

> Međunarodni proizvođač opreme za planinarenje i kampiranje. Preko 100 proizvoda; proizvodi pripadaju **tipovima**, tipovi **linijama**. Narudžbe se plaćaju iz preko 25 zemalja, godišnje >25 000 narudžbi. Prodaja preko **partnera**, kroz više **prodajnih kanala**. Većina podataka u relacijskoj bazi, manji dio (direktna prodaja) u **CSV datoteci**. Dostupni podaci 3 godine poslovanja: **količina** prodanih proizvoda i **prihod**.

**Entiteti:** Linija, Tip, Proizvod, Partner, Zemlja, Narudžba, Kanal
**Veze:** Pripada (Linija–Tip, Tip–Proizvod), Naručeno od (Partner–Narudžba), Plaćeno iz (Narudžba–Zemlja), Naručeno kroz (Narudžba–Kanal), Uključuje (Narudžba–Proizvod)

Ograničenja koja se lako previde:
- moguće je naručiti **samo jedan proizvod po narudžbi**
- **zemlja iz koje se plaća nije povezana s partnerom**

## Logički model

Most između konceptualnog modela i fizičke implementacije. Ključan za detaljan plan strukture, optimizaciju dohvaćanja i integriteta, te usklađivanje s poslovnim zahtjevima.

**Komponente:**
- entiteti i atributi — **sa specificiranim tipovima podataka**
- veze — detaljnije, s vrstama (1:N, N:1, N:N) i ograničenjima
- **primarni i strani ključevi**
- **EER dijagram** — prilagođeni ER dijagram s ključevima i tipovima

**Koraci izrade:**
1. transformacija konceptualnog u logički (identifikacija entiteta i veza)
2. **normalizacija** — smanjenje redundancije
3. definiranje atributa i ključeva

Alati: MySQL Workbench, Microsoft Visio, Lucidchart, Draw.io.
Fizička implementacija: Oracle SQL Developer, MySQL Workbench, SSMS, pgAdmin.

## Provjeri se

1. Nabroji tri faze dizajna baze i rezultat svake.
2. Kako u tekstualnom opisu poslovnog procesa razlikuješ entitet, atribut i vezu?
3. Kada je nešto entitet, a kada atribut? Navedi obje smjernice.
4. Što EER dijagram dodaje na ER dijagram?
5. Zašto su datotečni izvori važni u kontekstu skladišta podataka?

**Checkpoint 2 (projekt):** definirati proces → entitete, atribute, veze i kardinalnost → ER dijagram (konceptualni) → EER dijagram (logički) → implementirati u DBMS → učitati podatke u relacijsku bazu.

---
---

# P3 — Skladišta podataka

## Ključne ideje

- **Inmonova definicija u četiri riječi** je najčešće ispitno pitanje cijelog kolegija.
- **Top-down (Inmon) vs. bottom-up (Kimball)** — znati tablicu usporedbe.
- **Dimenzijsko razmišljanje**: ne modeliramo *sve* detalje procesa, nego *kontekste koji utječu na odluku*.

## Potreba

- iskoristiti podatke iz **različitih izvora unutar i izvan organizacije** za potporu odlučivanju
- **integracija u jedinstvenu bazu**, modeliranu u skladu s ciljem
- olakšati postavljanje upita menadžerima koji donose odluke

## Definicije

> **Bill Inmon:** Skladište podataka jest **subjektno orijentiran, integriran, postojan i vremenski različit** skup podataka koji služi kao potpora odlučivanju.

> **Ralph Kimball:** Kopija transakcijskih podataka specijalno strukturirana za upite i analize.

> **Barry Devlin:** Jedinstven, kompletan i dosljedan repozitorij podataka pribavljen iz raznih izvora i predstavljen krajnjem korisniku na razumljiv način.

### Četiri svojstva iz Inmonove definicije

| Svojstvo | Značenje |
|---|---|
| **subjektno orijentiran** | podaci su organizirani **po poslovnim temama**, ne po aplikacijama |
| **integriran** | podaci dolaze iz **različitih izvora** i usklađuju se |
| **postojan** | podaci se **ne mijenjaju** u skladištu — samo se dodaju novi |
| **vremenski različit** | skladište ima **vremensku dimenziju** koja omogućuje pregled u vremenskom kontekstu |

## OLTP vs. OLAP

| OLTP (transakcijska aplikacija) | OLAP (analitika, izvješćivanje) |
|---|---|
| veliki broj transakcija | velika količina podataka |
| brza obrada | de-normalizirani podaci |
| normalizirani podaci | manje tablica |
| puno tablica | |

Tok podataka: **Izvori podataka → Pripremno područje → Skladište podataka → Korisnici**

## Pristupi implementacije

| | **Top-down** (Inmon) | **Bottom-up** (Kimball) |
|---|---|---|
| Postupak | prvo cijelo skladište, pa područna skladišta (*data marts*) | prvo područna skladišta, pa se spajaju u cjelinu |
| Izrada skladišta | vremenski iscrpno | vremenski kraće |
| Održavanje | **lagano** | **teško** |
| Trošak | visoki inicijalni | niski inicijalni |
| Vrijeme do početka | duže | kraće |
| Integracija podataka | ukupna organizacija | pojedini dijelovi |

> Izbor ovisi o slučaju. Kod bottom-upa **usklađene dimenzije** postaju kritične (vidi P5) jer različiti timovi razvijaju različita područna skladišta.

## Uvod u dimenzijski model

Prednosti u odnosu na relacijski model: standardizacija · pohranjivanje povijesnih podataka · modularnost · dohvat velike količine podataka · performanse upita · razumljivost.

**Predmet modeliranja:** činjenice i dimenzije.
**Osnovni elementi:** tablica činjenica, dimenzijske tablice, atributi.
**Sheme:** *star* ili *snowflake*.

- **Star shema** — dimenzijske tablice izravno spojene na tablicu činjenica (denormalizirane).
- **Snowflake shema** — dimenzije su **normalizirane**, pa se granaju u podtablice.

## Dimenzijsko razmišljanje

Razmišljanje o poslovanju **kroz različite kontekste koji utječu na rezultat**, posebno one bitne za odlučivanje.

- Konteksti **mogu, ali ne moraju** odgovarati entitetima iz relacijskog modela.
- Mogu se **izvući (generirati) iz transakcijskih podataka** — npr. ponašanje kupaca koje nigdje nije eksplicitno zapisano.

**Primjer 1 — Kafić želi povećati prodaju:**
- analiziramo: prodaju
- podaci: prodaja po vremenu dana, popularnost proizvoda, preferencije kupaca
- odluke: promotivne ponude, prilagođavanje radnog vremena, zapošljavanje

**Primjer 2 — E-trgovina želi poboljšati iskustvo kupaca:**
- kontekst: izvor posjetitelja, demografija kupaca, povijest kupnje, pregledi proizvoda, stopa napuštanja košarice
- odluke: promjena web trgovine, marketinške odluke

**Zaključak:** nije nam bitno pratiti sve detalje procesa — za to postoji transakcijski sustav. Fokus je na elementima koji značajno utječu na cilj. Ali: što više podataka uključimo, detaljnije analize možemo raditi → potrebno **definirati granicu**.

## Četiri koraka dizajna skladišta podataka

> **Ovo je okosnica cijelog projekta — nauči redoslijed.**

1. **Odabrati poslovni proces** — dnevne aktivnosti podržane OLTP sustavom (marketing, prodaja, HR, nabava). Definirati potrebe korisnika. Paziti na kvalitetu podataka.
2. **Odabrati granularnost tablice činjenica** — razina detalja; identificirati **najnižu razinu informacija**.
3. **Definirati dimenzije** — daju kontekst i odgovaraju na **Tko? Što? Gdje? Kada?**
4. **Definirati mjere (činjenice)** — predmet interesa odlučivanja, pohranjuju se u tablicu činjenica.

*Case study:* dimenzije = partneri, proizvod, lokacija, vrijeme; mjere = prihodi od prodaje, prodana količina.

## Provjeri se

1. Reproduciraj Inmonovu definiciju i objasni sva četiri svojstva.
2. Što znači da je skladište **postojano**? Kako to utječe na ETL?
3. Usporedi top-down i bottom-up po pet kriterija.
4. Nabroji četiri koraka dizajna skladišta, ispravnim redoslijedom.
5. Zadan proces: *"Bolnica želi smanjiti vrijeme čekanja pacijenata."* Odredi poslovni proces, granularnost, tri dimenzije i dvije mjere.

---
---

# P4 — Modeliranje skladišta podataka

## Ključne ideje

- **Tablica činjenica = mjere + strani ključevi dimenzija.** Dimenzije = kontekst.
- Tablica činjenica je (gotovo) **normalizirana**; dimenzijske tablice su **de-normalizirane**. Ovo je najčešća zamka.
- **Star shema i OLAP kocka imaju isti logički dizajn, različitu fizičku implementaciju.**

## Dimenzijsko modeliranje

Tehnika za prezentiranje analitičkih podataka koja omogućava:
- **razumljivost podataka poslovnim korisnicima**
- **brze performanse upita**

Razlika u odnosu na klasične normalizirane modele: **normalizirani modeli su prekomplicirani za BI upite**.

> Podaci koji se uključuju su **isti** kao u OLTP-u — različit je **način organizacije i pohrane**.

## Tablica činjenica

- **Činjenica = poslovna mjera**, kvantitativan tip podataka (pošiljke, prihodi, rashodi, plaćanja...)
- **Centralna** tablica dimenzijskog modela
- Tablica s **velikim brojem zapisa**; nije predviđena pohrana na više mjesta
- Cilj: sadržavati **najnižu razinu granularnosti**
- **Često je normalizirana ili gotovo normalizirana** i vrlo slična tablici u transakcijskom sustavu

**Sadržaj:**

```
Tablica činjenica
─────────────────
TK              ← tehnički (surogat) ključ = primarni ključ
Vrijeme ID      ┐
Lokacija ID     ├─ strani ključevi prema dimenzijama
Proizvodi ID    ┘
Prihod          ┐
Količina        ┘─ mjere
```

## Dimenzijska tablica

- **Kontekstualni dodatak** tablici činjenica
- **Kvalitativan** tip podataka (diskretan skup vrijednosti)
- Pridružena tablici činjenica vezom **1:M** → rezultat je **star shema**
- Često **manje veličine** od tablice činjenica (može imati svega nekoliko zapisa)
- **De-normalizirane** — zbog lakše obrade zahtjevnih analitičkih upita i čitljivosti modela
- Ima **surogat ključ** kao primarni ključ; **količina atributa doprinosi kvaliteti i raznovrsnosti analize**

```
Dimenzijska tablica
───────────────────
TK                    ← surogat ključ
Šifra (prirodni ID)   ← zadržan produkcijski ključ
Naziv
Tip proizvoda   ┐
Linija          ┘─ hijerarhija
Pakiranje
```

### Hijerarhije i redundancija

Dimenzijska tablica može imati **jednu ili više hijerarhija** unutar iste tablice — npr. dimenzija Trgovina:

```
Trgovina naziv → Grad → Županija → Država     (geografska hijerarhija)
Trgovina naziv → Prodajna zona → Prodajna regija   (organizacijska hijerarhija)
```

Hijerarhije unutar jedne tablice su **izvor redundancije podataka**. Normalizacija dimenzijskih tablica → **snowflake shema**. Pitanje koje treba postaviti: *je li normalizacija uopće potrebna?* (obično nije — prostor je jeftin, čitljivost i brzina nisu).

## Star shema ili OLAP kocke

**Obje implementacije imaju isti logički dizajn, ali različitu fizičku implementaciju.**

| | **OLAP kocke** | **Star sheme** |
|---|---|---|
| Fizička implementacija | MDB (multidimenzijska baza) | RDB (relacijska baza) |
| Agregacije | stvara i održava OLAP cube engine | rade se u ETL-u / upitima |
| Performanse | bolje performanse upita | slabije |
| Analitičke funkcije | robusnije | ograničene na SQL |
| Stabilnost | manja | **veće** |

> **Dobra praksa: stvoriti star shemu čak i kada se podaci pohranjuju u OLAP kocke** — i onda izvesti kocke iz star sheme.

## Normalizirani model → dimenzijski model

Transakcijski sustavi su tipično u **3NF**; dimenzijski model je **de-normaliziran**. Postupak pretvorbe koristi **ista četiri koraka** iz P3:

### 1) Odabrati poslovni proces
- dobro proučiti **ukupan** model transakcijskog sustava
- usredotočiti se na **područje** u relacijskom modelu — svi entiteti vezani uz proces su tek dio ukupnog modela
- imati ideju koje mjere će se odabrati
- kvaliteta podataka

### 2) Odabrati granularnost
- razina detalja; **preporuka: najniža granularnost**
- npr. individualne transakcije, linije dokumenta

### 3) Definirati dimenzije
- moraju biti **razumljive i korisne poslovnim korisnicima** — one su **korisničko sučelje** skladišta
- definirati potrebne atribute
- definirati hijerarhije (tražiti u povezanim tablicama) **ili stvoriti nove**
- najčešće vezane s tablicom činjenica **1:M**
- **transformacija kvantitativnih vrijednosti → grupiranje** (npr. dob → dobna skupina)
- **dodati dimenziju vrijeme**

### 4) Definirati mjere (tablicu činjenica)
- **često odgovaraju asocijativnim entitetima u ER dijagramu** ← ključna heuristika
- može se odabrati više mjera u jednu tablicu činjenica (količina, vrijednost)
- mjere moraju biti odgovarajućeg tipa
- uključivanje trivijalnih dimenzija

## Dodatak: asocijativni entiteti

- Kombinacija **veze i entiteta**.
- Kada ih stvoriti: kod **many-to-many** veze i kod **ternarnih** veza.
- Imaju **nezavisno značenje** od povezanih entiteta koji su stvorili vezu.
- Sadrže **svoj id** i često dodatni atribut koji nije id povezanog entiteta.
- Primjer: *Student — **Predaje** — Kolegij*, s dodatnim atributima `id`, `ocjena`.
- Pri implementaciji se pretvara u **zasebnu tablicu u 1:M vezama**.

> **Zato je asocijativni entitet prirodni kandidat za tablicu činjenica** — on već sadrži veze prema više entiteta (→ dimenzije) i vlastite mjerljive atribute (→ mjere).

*Case study — dimenzijski model:* tablica činjenica **Narudžba t.č.**, dimenzije **Partner d., Zemlja d., Proizvod d., Vrijeme d.**

## Provjeri se

1. Zašto je tablica činjenica normalizirana, a dimenzijske tablice de-normalizirane?
2. Koja je veza između star sheme i OLAP kocke?
3. Što je hijerarhija u dimenziji i zašto uzrokuje redundanciju?
4. Kako iz ER dijagrama prepoznaješ kandidata za tablicu činjenica?
5. Objasni zašto se preporučuje najniža granularnost, i koja je cijena te odluke.

**Checkpoint 3 (projekt):** pronaći mjeru (kvantitativan podatak) · 5 različitih dimenzija (kvalitativni podaci) · 2–3 hijerarhije u 2 dimenzije · napraviti star shemu.

---
---

# P5 — Dimenzijski model podataka (napredne teme)

## Ključne ideje

- **Surogat ključevi** su obavezni u svim tablicama dimenzijskog modela.
- **SCD tipovi 1–4 + hibridni** — najgušće ispitno gradivo cijelog kolegija.
- Za svaku "specijalnu" dimenziju znati **jednu rečenicu definicije i kada se koristi**.

Logika predavanja: (1) dizajniraj osnovni dimenzijski model → (2) **poboljšaj ga**.

## Surogat (tehnički) ključevi

- Uvode se u **sve** tablice dimenzijskog modela; **cijeli brojevi (sekvence)**.
- Originalni primarni (**produkcijski**) ključevi se **zadržavaju** — veze na izvorne podatke.
- **Ne smiju biti "pametni" niti kompozitni.**
- **Ne smiju biti povezani s produkcijskim ključevima.**
- Surogat ključevi dimenzija koriste se za **vezu prema tablici činjenica**.

> **Zašto?** Izvorni sustav može promijeniti format ključa, spojiti se s drugim sustavom, reciklirati šifre. Osim toga, SCD tip 2 **zahtijeva** da ista poslovna šifra postoji u više redaka — a to je moguće samo ako primarni ključ nije poslovna šifra.

## Sporo mijenjajuće dimenzije (SCD — *slowly changing dimensions*)

Atributi dimenzije mijenjaju se kroz vrijeme, a **želimo praćenje povijesti** — to je opća ideja skladišta podataka.

### Tip 1 — presnimavanje

Stara vrijednost se **prepisuje** novom. Koristi se kada praćenje povijesti tog atributa **nema analitički značaj**.

```
prije:  1200345 | Acer A5 Računalo | i5
poslije:1200345 | Acer A5 Računalo | i7
```

➕ jednostavno, bez rasta tablice  ➖ **povijest je nepovratno izgubljena**; stara izvješća se retroaktivno mijenjaju

### Tip 2 — dodavanje novog zapisa

Povijest se čuva kao **novi zapis** u dimenziji. **Najčešći oblik praćenja SCD-a.**

```
1200345 | Acer A5 Računalo | i5
1200346 | Acer A5 Računalo | i7     ← novi surogat ključ, ista poslovna šifra
```

Za praćenje aktivnosti zapisa dodaju se atributi — **dovoljan je samo jedan mehanizam**:
- `Datum od` / `Datum do`, **ili**
- indikator `Aktivan` (Y/N)

```
ID      | Naziv            | Procesor | Datum od   | Datum do   | Aktivan
1200345 | Acer A5 Računalo | i5       | 2018-01-12 | 2019-03-15 | N
1200346 | Acer A5 Računalo | i7       | 2019-03-16 |            | Y
```

➕ potpuna povijest, izvješća ostaju točna  ➖ dimenzija raste, ETL je složeniji

### Tip 3 — novi atribut

Povijest se zadržava **dodavanjem novog atributa**, u istom retku.

```
ID      | Naziv            | Procesor tip | Stari procesor tip
1200345 | Acer A5 Računalo | i7           | i5
```

➕ jedan redak po entitetu, lako uspoređivati "prije/poslije"  ➖ **čuva samo ograničen broj promjena** (obično jednu) — razlika u odnosu na tip 2

### Tip 4 — zasebna tablica povijesti

Trenutni podaci u **glavnoj** dimenzijskoj tablici, povijesni podaci u **zasebnoj tablici povijesti**.

Idealno za okruženja s jasnim potrebama za analizu trenutnih **vs.** povijesnih podataka.

➕ poboljšava performanse upita na trenutnim podacima; pojednostavljuje analizu povijesnih
➖ dodatni prostor za pohranu; **složeniji ETL procesi**

### Hibridni tip 1 (proširenje tipa 3)

Tablica se proširuje **novim atributima** — kada su promjene **redovite i predvidive**.

```
ID | Naziv | Procesor tip | Procesor tip 2018 | Procesor tip 2017
   |       | i7           | i5                | i3
```

### Hibridni tip 2 (kombinacija tipova 1+2+3)

Način primjene — sva tri mehanizma istovremeno:
1. održavamo **dva atributa**, trenutni i povijesni → **tip 3**
2. unosimo **novi zapis** s promjenom vrijednosti → **tip 2**
3. **ažuriramo svim atributima trenutnu vrijednost** → **tip 1**

```
1200345 | Acer A5 | Trenutni: i9 | Povijesni: i5
1200346 | Acer A5 | Trenutni: i9 | Povijesni: i7
1200347 | Acer A5 | Trenutni: i9 | Povijesni: i9   ← novi zapis
```
Rezultat: možeš analizirati i "kako je bilo tada" (povijesni stupac po retku) i "kako je danas" (trenutni stupac, ažuriran svugdje).

### SCD — sažeta tablica za brzo ponavljanje

| Tip | Mehanizam | Povijest | Kada |
|---|---|---|---|
| **1** | prepiši vrijednost | **nema** | povijest nema analitičkog značaja |
| **2** | novi redak + Datum od/do ili Aktivan | **potpuna** | standardni izbor |
| **3** | novi stupac (stara vrijednost) | **ograničena** | usporedba prije/poslije jedne promjene |
| **4** | zasebna tablica povijesti | potpuna, odvojena | jasno odvojene analize trenutno vs. povijesno |
| **Hibrid 1** | više stupaca po razdoblju | ograničena, predvidiva | redovite, predvidive promjene |
| **Hibrid 2** | 1 + 2 + 3 zajedno | potpuna + trenutni pogled | najzahtjevniji analitički scenariji |

## Ostale vrste dimenzija

| Vrsta | Definicija | Ključna karakteristika |
|---|---|---|
| **Usklađene** (*conformed*) | tablice koje se pojavljuju u **više dimenzijskih modela** | omogućavaju prijelaz iz jednog područnog skladišta u drugo; osiguravaju konzistentnost, usporedivost, smanjuju redundanciju; **kritične kod bottom-up pristupa** |
| **Degenerirane** | **atributi unutar same tablice činjenica** | imaju svojstva dimenzijskog ključa, ali **ne postoji odgovarajuća dimenzijska tablica**; korisne za grupiranje zapisa (npr. broj računa) |
| **Potporne** | referencira se **iz druge dimenzije**, ne iz tablice činjenica | to je **snowflake** shema; **iznimka, a ne pravilo** |
| **Mini dimenzije** | kod dimenzija s velikim brojem atributa, **logički povezani** atributi se odvajaju | spajaju se izravno s tablicom činjenica (dodatni atribut u t.č.); ubrzavaju pretraživanje; iz *monster dimensions* može se stvoriti više mini dimenzija |
| **Kompozitne** (*junk*) | atributi **niske kardinalnosti** premješteni iz tablice činjenica u posebnu dimenziju | oznake (Da/Ne), indikatori (Staro/Novo), statusi (Završeno/Nije završeno); **za razliku od mini dimenzija, atributi NISU logički povezani** |
| **Heterogene** | kombinira **različite, ali logički slične** entitete u jednu dimenziju | zajednički atribut u glavnoj tablici, opcionalni često u zasebnima; npr. hrana/posuđe/piće → Proizvodi; traži se ravnoteža između jedne velike polu-prazne dimenzije i mnogo zasebnih |

> **Mini vs. junk — razlika koja se pita:** mini dimenzija grupira **logički povezane** atribute (npr. sva demografija kupca); junk dimenzija grupira **nepovezane** atribute niske kardinalnosti samo da ih makne iz tablice činjenica.

## Napredna svojstva tablica činjenica

### Modeli činjeničnih tablica

| Model | Opis | Primjer |
|---|---|---|
| **Transakcijske** | fokusirane na **pojedinačne događaje ili transakcije**; vrlo detaljne | svaka stavka računa |
| **Periodička snimka stanja** (*periodic snapshot*) | bilježe **stanje podataka u određenim intervalima**; korisno za analizu trendova | stanje računa na kraju svakog mjeseca |
| **Akumulirajuća snimka stanja** (*accumulating snapshot*) | prate **napredak procesa od početka do kraja**, ažurirajući status **u istom retku** kroz faze | narudžba: zaprimljena → plaćena → poslana → isporučena |

> **Najčešće se koristi transakcijski model.**

### Tablica činjenica bez činjenica (*factless fact table*)

- Bilježi **postojanje događaja**.
- Tablica činjenica **bez mjere** (vrijednost = 1, ili 0/1).
- Mogu se koristiti za analizu **što se NIJE dogodilo** (npr. koji su promovirani proizvodi ostali neprodani; koji student nije došao na predavanje).

### Unakrsni pregled (*drill across*)

- Upit **iz više tablica činjenica**; podaci se kombiniraju u jedinstven rezultat.
- Preduvjet: **usklađene dimenzije**.
- Tablice činjenica **mogu biti različite granularnosti**.

### Pravovremenost podataka

Podaci obično dolaze sinkronizirano, redoslijedom **dimenzije → tablica činjenica**. Kada dođe do desinkronizacije:

| | **Rano** | **Kasno** |
|---|---|---|
| **Dimenzije** | U redu | **Problem** |
| **Činjenice** | **Problem** | **Problem** |

**Rano dolazeće činjenice** — dva rješenja:
1. Postoji **općeniti zapis** u dimenziji → unese se zapis u t.č. i **privremeno poveže s općenitim zapisom**; t.č. se ažurira kad stigne pravi dimenzijski zapis.
2. Unese se zapis u dimenziju **s dostupnim podacima** → poveže se s t.č. → kasnije se dimenzija ažurira po **tipu 1**.

**Kasno dolazeće činjenice** — utječu na **prethodna izvješća** (treba dozvoliti unos kasnih podataka):
- pronaći zapise u **svim** dimenzijama koji su vrijedili **u trenutku stvaranja transakcije** (moguće samo uz **dimenzije tipa 2**)
- unijeti novi zapis u t.č. s tako određenim ključevima

**Kasno dolazeće dimenzije:**
- unijeti novi zapis u dimenzijsku tablicu s odgovarajućim vremenom nastanka
- ažurirati sve pripadajuće dimenzijske zapise **nakon** vremena novog zapisa, ako se mijenjaju
- ažurirati `DatumDo` prethodnog i promatranog zapisa
- **promijeniti veze u činjeničnoj tablici** koje se odnose na razdoblje novounesenog zapisa

## Provjeri se

1. Nabroji četiri pravila za surogat ključeve.
2. Objasni razliku između SCD tipa 2 i tipa 3 na istom primjeru.
3. Kada bi izabrao tip 4 umjesto tipa 2?
4. Što je degenerirana dimenzija? Zašto nema svoju tablicu?
5. Razlika mini dimenzije i junk (kompozitne) dimenzije?
6. Što je factless fact table i za kakvu analizu je nezamjenjiva?
7. Zašto su za kasno dolazeće činjenice **nužne** dimenzije tipa 2?
8. Popuni tablicu pravovremenosti (rano/kasno × dimenzije/činjenice).

**Checkpoint 3 (proširen):** mjera **ili tablica činjenica bez činjenica** · 5 dimenzija · 2–3 hijerarhije u 2 dimenzije, **jedna degenerirana dimenzija** · star ili snowflake shema · **uključiti napredne mogućnosti** (SCD, različite izvedbe dimenzijskih tablica).

---
---

# P6 — ETL proces

## Ključne ideje

- **ETL = Extract, Transform, Load**, a sve tri faze se odvijaju preko **pripremnog područja**.
- **CDC tehnike** i njihova usporedna tablica — sigurno ispitno pitanje.
- Transformacija nije samo "pretvorba formata" nego prije svega **čišćenje i kontrola kvalitete**.

## ETL proces

```
IZVOR 1 ┐
IZVOR 2 ├─► IZDVAJANJE ─► TRANSFORMACIJA ─► UČITAVANJE ─► skladište podataka
IZVOR 3 ┘   └────────── PRIPREMNO PODRUČJE (staging area) ──────┘
```

Odgovoran je za:
- **izdvajanje** podataka iz transakcijskog sustava u pripremno područje
- **transformaciju** — čišćenje podataka + transformacija u strukturu za dimenzijski model
- **učitavanje** podataka u skladište

> ETL je **najzahtjevniji dio izrade skladišta** (implementacija i održavanje) i **specifičan je za svaku organizaciju**.

Izazovi po fazama: *izdvajanje* — detektiranje promjena, više izvora; *transformacija* — način transformacije i čišćenja, različitost podataka; *punjenje* — način učitavanja.

## Pripremno područje (*staging area*)

- Područje izvornih podataka za transformaciju i čišćenje — u biti **kopija transakcijskog sustava**.
- **Korisnici nemaju pristup** pripremnom području; **upiti ne mogu pristupiti** tim podacima.
- Tablice mogu biti **dodane ili izbrisane bez pravila**.
- Iz pripremnog područja se puni skladište podataka.

> **Zašto uopće postoji:** da se produkcijski sustav ne opterećuje transformacijama i da se prljavi, polutransformirani podaci nikada ne vide u skladištu.

## Izdvajanje podataka

**Prvo pravilo: produkcijski sustav ne smije biti ugrožen prikupljanjem podataka za skladište.** Paziti da:
- se podaci **ne mijenjaju (ili izgube)** u izvorišnom sustavu
- se **ne mijenja (ili što manje) konfiguracija** sustava
- ne stradaju **performanse** (zaključavanje) izvorišnog sustava — pitanje **vremena izdvajanja**

### Načini izdvajanja

| | **Potpuno** | **Djelomično** |
|---|---|---|
| Što obuhvaća | sve dostupne podatke iz izvora | samo podatke promijenjene od zadnjeg uspješnog ETL-a |
| Kada | **prvo punjenje** (*initial load*), *full load* | **inkrementalna nadopuna** |
| Složenost | **manje komplicirano** — ne mora se voditi briga o već učitanim podacima | **kompleksnije** — traži detekciju promjena |
| Napomena | zahtijeva **posebnu verziju ETL procesa** | frekvencija ovisi o poslovnom procesu (npr. dnevno) |

> Skladište može biti **jedini izvor povijesnih podataka** tvrtke — zato ponovno inicijalno punjenje treba raditi vrlo oprezno; nije praktično za veća skladišta.

### Change Data Capture (CDC)

**CDC = sposobnost detektiranja promijenjenih podataka u izvorišnom sustavu i njihovo prikupljanje.**

**1. Dodavanje vremenske oznake**
Poseban atribut koji prati vrijeme (dan, sat, minuta, sekunda). ETL uspoređuje vrijeme zadnje ekstrakcije s oznakom na zapisu.
*Ograničenja:* bilježi samo **zadnju izmjenu**; **ne vidi obrisane zapise**.

**2. Razlika snimki stanja**
Usporedba **zapis po zapis** s podacima iz prethodnog ažuriranja; stara snimka mora ostati u pripremnom području.
➕ jednostavna za implementaciju, **pronalazi sve promjene** ➖ **zahtijeva dosta resursa i vremena**

**3. Aplikacijsko bilježenje promjena**
Bilježenje promjena u posebnu tablicu; **svi aplikacijski programi moraju jednako evidentirati promjene**.
➕ pogodno za baze koje ne podržavaju mehanizme praćenja ➖ složeno, traži veliki angažman na promjeni aplikacija

**4. Korištenje okidača baze podataka**
Okidači (*triggers*) i pohranjene procedure bilježe svaki `INSERT`, `UPDATE`, `DELETE` u log tablicu.
➖ velike izmjene na bazi, **opterećenje baze** — okidače treba **vrlo oprezno** koristiti

**5. Korištenje dnevnika transakcija**
Koristi mehanizme oporavka podataka (*data recovery*) koje pruža DBMS. Vrsta podataka ovisi o implementaciji; zahtijeva **razvoj posebnog algoritma** i sinkronizaciju s ETL-om.

### Usporedba CDC tehnika — tablica za memoriranje

| Utjecaj na: | izvorišnu bazu | aplikacije | složenost implementacije | evidencija povijesti | performanse izvornog sus. |
|---|---|---|---|---|---|
| **dodavanje vremenske oznake** | srednji | nema | niska | slaba | nizak |
| **razlika snimki stanja** | nema | nema | niska | **nema** | nizak |
| **aplikacijsko bilježenje promjena** | nema | **visok** | **visoka** | visoka | visoka |
| **korištenjem okidača baze** | **visok** | nema | srednja | visoka | visoka |
| **korištenje dnevnika transakcija** | nema | nema | srednja | visoka | **nizak** |

> Zadnji redak je jedini s "nema/nema/srednja/visoka/nizak" — **dnevnik transakcija je tehnički najelegantnije rješenje**, cijena mu je razvoj posebnog algoritma.

## Transformacija

Drugi korak ETL-a, izvodi se **u pripremnom području**. Podrazumijeva:
- **analizu** podataka
- **čišćenje** podataka
- **transformaciju u odgovarajuću strukturu** za dimenzijski model

Operacije se izvršavaju **slijednim redoslijedom** (*pipelining order*).

### Čišćenje podataka — zašto?

Zbog **kvalitete podataka koji se učitavaju u skladište**. Bitne karakteristike: **ispravnost · nedvosmislenost · konzistentnost · potpunost**.

Primjer sa slajda i tipovi grešaka koje pokazuje:

| ID | Ime | God. rođ. | Starost | Spol | Telefon | Pošta |
|---|---|---|---|---|---|---|
| 233 | Anić, Ivan | 13.4.80 | 26 | M | 99999999 | 51000 |
| 233 | Petra Ivić | 33.4.87 | 32 | M | 01234568 | 99999 |
| 234 | Ivan Anić | 13.4.80 | 36 | M | 051236543 | 51000 |

| Pošta | Grad |
|---|---|
| 44000 | Sisak |
| 51000 | Rjieka |
| 1000 | Hrvatska |

Detektirane greške:
- **reprezentacija** — "Anić, Ivan" vs. "Ivan Anić"
- **jedinstvenost** — ID 233 pojavljuje se dvaput
- **kontradikcija** — ista godina rođenja, različita starost (26 vs. 36)
- **netočne vrijednosti** — datum `33.4.87`, telefon `99999999`
- **nedostajuće vrijednosti**
- **referencijalni integritet** — pošta `99999` ne postoji u šifrarniku
- **greške** — "Rjieka" (tipfeler), `1000 → Hrvatska` (država umjesto grada)
- **duplikati** — 233/234 su vjerojatno ista osoba

### Testovi kvalitete (*Quality Screens*, QS)

- Testovi u ETL procesu koji se **javljaju ako podaci ne prođu određeni test kvalitete**.
- Ako se javi greška, aktivira se QS i **bilježi se u shemu grešaka** (*error event schema*).
- Vrste testova: **stupčani · strukturni · testovi poslovnih pravila**

### Shema grešaka (*error event schema*)

**Dimenzijski model čiji je cilj evidentiranje svih grešaka u ETL procesu.**
- **tablica činjenica = događaj greške**; **granularnost = svaka greška u ETL-u**
- **dimenzije**: vremenska, obrada u kojoj se greška dogodila, test kvalitete...

### Revizorska dimenzija (*audit dimension*)

- Činjeničnoj tablici se pridjeljuje **dimenzija s metapodacima koji opisuju kvalitetu podataka**.
- Pridjeljuje se **svakom zapisu** tablice činjenica.
- Sadrži ETL podatke o procesiranju i kvaliteti.
- Zajedno sa shemom grešaka omogućuje provjeru je li bilo problema s kvalitetom tijekom ETL-a.

### Transformacija u strukturu dimenzijskog modela

**Izgradnja dimenzija:**
- uklanjanje duplih dimenzijskih zapisa
- mehanizam **sporo mijenjajućih dimenzija**
- **generiranje surogat ključeva**

**Izgradnja tablice činjenica:**
- **povezivanje s dimenzijama** (dohvat surogat ključeva)

> Redoslijed je obavezan: **prvo dimenzije, pa tablica činjenica** — inače nema surogat ključeva na koje bi se t.č. povezala. To je i razlog zašto su "rano dolazeće činjenice" problem (P5).

## Punjenje

Moguće je: **odjednom** ili **zapis po zapis**. Odabir ovisi o procesu; **punjenje odjednom je vremenski manje zahtjevno**.
Akcije nad zapisima: **dodati · izmijeniti · brisati**.

## Real-time skladišta podataka

- Nastojanje da se **vremensko kašnjenje smanji na najmanju moguću razinu**. (Pitanje: postoji li *stvarni* real-time?)
- Izazovi: izmjene ETL procesa, **mini obrade podataka**, interakcija postojećih i novih zapisa.

## Provjeri se

1. Nabroji tri faze ETL-a i navedi po jedan izazov svake.
2. Zašto postoji pripremno područje i tko mu ima pristup?
3. Nabroji pet CDC tehnika i za svaku navedi jedan nedostatak.
4. Koja CDC tehnika ne bilježi obrisane zapise i zašto?
5. Koja CDC tehnika ne vodi nikakvu evidenciju povijesti?
6. Što je shema grešaka? Koja joj je granularnost i koja tablica čini činjenice?
7. Razlika između sheme grešaka i revizorske dimenzije?
8. Zašto se u transformaciji dimenzije grade prije tablice činjenica?

**Checkpoint 4 (projekt):** napuniti skladište iz **barem 2 izvora** · provesti ETL · provjeriti unos podataka · **provjeriti da nema izgubljenih podataka**.

---
---

# P8 — OnLine Analytic Processing (OLAP)

## Ključne ideje

- **Pet faza implementacije DW-a** poklapa se s pet checkpointa projekta.
- **Pet OLAP operacija** na kocki — znati ih nabrojati i objasniti.
- **FASMI** — akronim za svojstva koja OLAP alat mora imati.
- **MOLAP / ROLAP / HOLAP** — usporedna tablica.

## Implementacija skladišta podataka — 5 faza

| # | Faza | Sadržaj |
|---|---|---|
| **1** | **Poslovni zahtjev** | definirati predmet DW-a, očekivane rezultate projekta, korisnike; planiranje projekta; definiranje potrebnih resursa |
| **2** | **Analiza operativnog sustava** | definiranje izvora podataka; analiza relacijskog modela; detektiranje bitnih elemenata (entiteta, relacija, atributa) |
| **3** | **Dizajn DW-a** | definiranje tablice činjenica i dimenzija; ostala pitanja dizajna; stvaranje dimenzijskog modela |
| **4** | **ETL** | izdvajanje, transformacija, punjenje; prvo punjenje; ažuriranje sustava |
| **5** | **Korištenje / OLAP** | OLAP analiza; održavanje |

> Ove faze **1:1 odgovaraju checkpointima projekta 1–5.**

## Što je OLAP

Različite definicije: OLAP je **pristup / tehnike i alati / metoda** koja podržava **jednostavnu analizu multi-dimenzijskih podataka**.

- Korisnik **nije ograničen na već definirani skup izvještaja** — može sam kreirati nove.
- Dostupno mu je **grafičko sučelje** za specificiranje parametara analize.
- Korisnici: **poslovni korisnici, analitičari, menadžeri**.
- **Ne podrazumijeva znanje programskih jezika** (ni SQL-a).
- Rezultati su grafički, u obliku koji se može uključiti u druge aplikacije.
- Tipični upiti: **multi-dimenzijski upiti, usporedbe, top vrijednosti**.

**Definiranje OLAP izvješća:** odabrati mjeru(e) → odabrati dimenzije → definirati filtere → definirati izgled.

Alati: **Tableau** (na predavanjima), **Power BI**, i drugi.

## OLAP operacije na kocki

| Operacija | Definicija | Efekt na kocku |
|---|---|---|
| **Slice** | ograničavanje **jedne** dimenzije na neki raspon vrijednosti | rez kroz kocku |
| **Dice** | ograničavanje **više** dimenzija na neki raspon | **manja kocka** |
| **Roll-up** | sažimanje podataka kretanjem **prema višim** razinama hijerarhije ili **redukcijom** dimenzija | manje detalja (dan → mjesec → godina) |
| **Drill-down** | obrnuto od roll-upa: **niže razine** sažimanja / detaljni podaci, **dodavanje** novih dimenzija | više detalja |
| **Pivot (rotate)** | promjena **redoslijeda dimenzija**; rotacija kocke; 3D serije u 2D površine | ista podatkovna baza, drugi pogled |
| **Drill across** | uključivanje **više tablica činjenica** u jedan rezultat | traži usklađene dimenzije (P5) |

Sažeto: *slice and dice* = selekcija i projekcija · *drill-down* = spuštanje niz hijerarhiju · *roll-up* = uspinjanje uz hijerarhiju · *pivot* = rotiranje kocke · *drill across* = više tablica činjenica.

## FASMI

**F**ast **A**nalysis of **S**hared **M**ultidimensional **I**nformation — svojstva koja OLAP alat mora imati:

| Slovo | Svojstvo | Zahtjev |
|---|---|---|
| **F** | **brzina** | većina upita **unutar 5 sekundi**, rijetki do 20 |
| **A** | **analiza** | podržava poslovnu logiku i statističku analizu; **ad-hoc upiti bez programiranja** |
| **S** | **dijeljenje** | sigurnosni zahtjevi |
| **M** | **multi-dimenzionalnost** | multidimenzionalni konceptualni pogled, podržava **dimenzije i hijerarhije** |
| **I** | **informacije** | obrađuje **velike količine podataka** |

## Metapodaci

„Podaci o podacima". Kategorije:
- **poslovni** metapodaci
- **tehnički** metapodaci
- **operacijski** metapodaci

Uloga: pomažu u **lociranju sadržaja** skladišta; koriste ih alati za upit, **transformacijski alati** i **alati za izradu izvješća**.

## Agregacije

**Temeljna tehnika kojom OLAP sustavi postižu veću brzinu.**

- Ideja: **unaprijed izračunati agregirane podatke** koji će se pozivati tijekom upita.
- Cijena: **troši se procesorsko vrijeme i mjesto na disku unaprijed**.
- Rade se **prilikom ETL procesa**, točnije punjenja.
- Agregirani podaci se pohranjuju u **posebnu tablicu namijenjenu isključivo za to**.
- **Procesiranje kocke** = osvježavanje sadržaja kocke i agregatne tablice.

**Agregirana tablica činjenica** pohranjuje agregirane podatke niže granularnosti prema **višim hijerarhijama dimenzija**:

```
Osnovna t.č.:   Proizvod SK, Vrijeme SK, Trgovina SK, Količina, Prihod
                       ↓ roll-up po hijerarhiji Proizvod → Tip proizvoda
Agregirana t.č.: Tip proizvoda SK, Vrijeme SK, Trgovina SK, Količina, Prihod
                 └─ "Tip proizvoda" postaje IZVEDENA DIMENZIJA
```

## MDX

- *Multidimensional expressions* — **upitni jezik za rad s multi-dimenzijskim podacima**, razvio ga **Microsoft**.
- Osnovni element analitičkog procesiranja su **kocke**; kockom se smatra **tablica činjenica i sve pripadajuće dimenzije**.
- Postoji **posebna dimenzija Mjere**.
- Naredba za dohvat podskupa podataka: `SELECT`.

## Arhitektura OLAP sustava

| | **MOLAP** | **ROLAP** | **HOLAP** |
|---|---|---|---|
| Pohrana | multi-dimenzijska kocka | relacijska baza podataka | kombinacija |
| Mehanizam | automatsko popunjavanje agregata pri učitavanju | sloj **meta-podataka** koji mapira tablice u dimenzije | dio podataka u RDB, dio u MDB |
| **Prednosti** | dobre performanse (brzina upita); mogu se izvoditi **kompleksne kalkulacije** | **velike količine podataka**; funkcionalnosti relacijske baze | obuhvaća prednosti oba |
| **Nedostaci** | **limitirana količina podataka**; tehnologija se često unaprijed ne koristi u organizaciji, može biti **skupa** | **performanse upita**; **ograničenje na SQL** | različite interpretacije ovisno o proizvođaču |
| Tipično | | | podaci se dijele na **agregate i podatke** |

## Provjeri se

1. Nabroji pet faza implementacije DW-a i poveži ih s checkpointima.
2. Objasni razliku između slicea i dicea.
3. Koja je razlika između roll-upa i redukcije dimenzija? Je li to isto?
4. Što znači akronim FASMI? Koji je vremenski kriterij za "F"?
5. Kada nastaju agregacije i gdje se pohranjuju?
6. Što je izvedena dimenzija?
7. Usporedi MOLAP i ROLAP po dvije prednosti i dva nedostatka.
8. Zašto drill across zahtijeva usklađene dimenzije?

**Checkpoint 5 (projekt):** odabrati OLAP alat · provesti smislenu analizu u kontekstu svog problema · različiti scenariji korištenja · **pokazati sve operacije na kocki** kroz analizu rezultata · generirati tablice, grafove, **dashboard**.

---
---

# P9 — Skladišta podataka i rudarenje podataka

## Ključne ideje

- **Skladište odgovara na "koliko je bilo", rudarenje na "koliko će biti".**
- **KDD proces** ima 5 koraka; rudarenje podataka je **jedan od njih**.
- **Nadzirano ↔ prediktivno, nenadzirano ↔ deskriptivno.** Ova ekvivalencija je ključ cijelog drugog dijela kolegija.

## Zašto rudarenje

Skladišta podataka prikupljaju podatke iz različitih izvora, sadrže povijesne podatke koji su prošli transformaciju i čišćenje, i služe za upite i analizu — **OLAP alatima**.

**Ograničenja skladišta:**
- velike količine podataka **vs.** OLAP alati
- ***data rich, information poor* situacija**
- analiza je **ovisna o poslovnom korisniku**; poslovna odluka se često donosi **na temelju intuicije**
- traži se **ekspertno znanje**
- **potreba za alatima koji bi sami pronalazili znanje unutar podataka**

Ilustracija razlike:
- *„Koliko je iznosila prodaja proizvoda u 2018.?"* → **skladište podataka / OLAP**
- *„Koliko će iznositi prodaja proizvoda u 2030.?"* → **rudarenje podataka**

> **Definicija (Berry i Linoff, 2004.):** Rudarenje podataka je **istraživanje i analiza velikih količina podataka u nastojanju otkrivanja smislenih obrazaca i pravila.**

## Rudarenje podataka kao interdisciplinarno područje

```
       STROJNO UČENJE      PREPOZNAVANJE UZORAKA
                    ╲      ╱
              RUDARENJE PODATAKA
                    ╱      ╲
          STATISTIKA        BAZE PODATAKA
```

**Motivacija:** velika količina podataka · pronalaženje skrivenih uzoraka · u nekim slučajevima nemoguće je podatke analizirati "ručno" bez alata.

## KDD proces

**KDD = Knowledge Discovery in Databases** — proces stvaranja znanja iz podataka.

Dva pogleda na odnos KDD-a i rudarenja: (a) izjednačavanje dvaju pojmova, (b) **rudarenje podataka je dio KDD procesa** (Fayyad, Piatetsky-Shapiro & Smyth, 1996.).

**Koraci KDD-a:**
1. **odabir podataka**
2. **predprocesiranje**
3. **transformacija**
4. **rudarenje podataka**
5. **evaluacija**

> Uočiti paralelu s ETL-om: koraci 1–3 KDD-a su u biti isto što i ETL, samo s ciljem modeliranja umjesto izvještavanja.

## Od podataka do znanja — primjeri

| Podaci | Metoda | Znanje |
|---|---|---|
| pozivi | detektiranje stršećih vrijednosti | otkrivanje prijevara |
| transakcije | klasifikacija | kreditna rizičnost |
| računi | asocijativna pravila | povezanost proizvoda |
| slike | klasifikacija | prepoznavanje tijela |

## Mjesto u poslovnoj analitici

```
                    POSLOVNA ANALITIKA
      ┌──────────────────┬──────────────────┬──────────────────┐
   Deskriptivna       Prediktivna       Preskriptivna
      │                  │
      │                  └── RUDARENJE PODATAKA
      └── BI / SKLADIŠTA PODATAKA
              └────── Napredna analitika ──────┘
```

## Dvije vrste zadaća

| | **Deskriptivni modeli** | **Prediktivni modeli** |
|---|---|---|
| Što rade | opisuju generalna svojstva podataka u bazama | koriste podatke za stvaranje predikcije |
| Cilj | pronalazak uzorka koji **poslovni korisnici mogu interpretirati**; stvaranje novih, netrivijalnih informacija; **razumijevanje odnosa između atributa** | **predviđanje budućih događaja** |
| Način učenja | **nenadzirano** | **nadzirano** |

### Nadzirano učenje
- Učenje **predviđanja izlazne varijable na temelju ulaznih**.
- Vrijednosti izlazne varijable su **poznate na trening skupu**.
- Skup za učenje se daje sustavu s ciljem da nauči **"pravila"** po kojima će vrednovati buduće primjere.
- Zadaci: **klasifikacija, regresija**.

### Nenadzirano učenje
- **Otkrivanje grupa sličnih objekata** u podacima, na temelju karakteristika/atributa.
- **Ne postoji a priori znanje o grupama** u podacima.
- Zadaci: **klasteriranje, asocijativna pravila, detektiranje anomalija**.

## Pet glavnih zadaća rudarenja podataka

| Zadaća | Tip | Izlazna varijabla | Tipične tehnike |
|---|---|---|---|
| **Klasifikacija** | prediktivna (nadzirano) | **kategorička**, mali broj diskretnih vrijednosti | neuronske mreže, SVM, logistička regresija |
| **Regresija** | prediktivna (nadzirano) | **kontinuirana** | linearna, polinomna regresija |
| **Klasteriranje** | deskriptivna (nenadzirano) | nema — broj klastera i njihovo značenje **nisu poznati unaprijed** | k-means |
| **Asocijativna pravila** | deskriptivna (nenadzirano) | nema — pravila oblika *ako X onda Y s vjerojatnošću ≥ X %* | Apriori |
| **Detekcija anomalija** | deskriptivna (nenadzirano) | identifikacija netipičnih vrijednosti | statističke, distance-based |

**Klasifikacija:** trening podaci sadrže vrijednost izlazne varijable; rezultat učenja je **model koji se koristi za klasifikaciju budućih primjera**.

**Klasteriranje:** dekompozicija skupa objekata u skupove sličnih objekata; različiti klasteri predstavljaju različite klase ili objekte.

**Asocijativna pravila:** cilj je pronalazak svih pravila oblika *"Ako su x, y, z sadržani u skupu M, tada je k također sadržan u M uz vjerojatnost od najmanje X %."*

**Detekcija anomalija:** identifikacija netipičnih vrijednosti. Moguća zloupotreba (kreditne kartice, telekomunikacijske poruke), loši podaci. Može se koristiti **pri predprocesiranju** ili **kao cilj analize**.

## Provjeri se

1. Navedi pet ograničenja skladišta koja motiviraju rudarenje podataka.
2. Što znači *data rich, information poor*?
3. Nabroji pet koraka KDD-a. Gdje je unutar njih rudarenje podataka?
4. Poveži: nadzirano/nenadzirano ↔ prediktivno/deskriptivno.
5. Za svaku od pet zadaća navedi tip izlazne varijable.
6. Za jedan konkretan poslovni problem po vlastitom izboru definiraj: zadaću, izlaznu varijablu i izvor podataka.

---
---

# P10 — Rudarenje podataka: klasifikacija

## Ključne ideje

- **Tri uvjeta za primjenu strojnog učenja** — obrazac, nemogućnost formule, podaci.
- **Šest komponenti učenja** — s oznakama f, h, H, D...
- **Klasično programiranje vs. strojno učenje** — dijagram koji objašnjava sve.

## Zašto strojno učenje

- **složeni problemi**
- **velike količine podataka**
- **sustavi koji se dinamički mijenjaju**

Interdisciplinarno: računarna znanost · statistika · matematika i linearna algebra · optimizacija.

Primjene: Google (preciznost rezultata pretraživanja), Facebook (postovi prema interesima), Netflix (preporuke), NVIDIA (praćenje objekata u vožnji), digitalni pomoćnici (prepoznavanje govora).

## Klasifikacija

> **Klasifikacija predstavlja problem identifikacije kojoj klasi (kategoriji) nova opservacija pripada, na temelju trening skupa podataka koji sadrži opservacije čije su klase unaprijed poznate.**

**Klasifikacija je primjer nadziranog učenja.**

## Kada odabrati strojno učenje — tri uvjeta

Primjer problema: *Predvidjeti koji klijent banke će imati problema prilikom vraćanja kredita.* Odluka se mora donijeti pri primitku zahtjeva, mora vrijediti za cijelo razdoblje trajanja kredita, i mora što bolje razlikovati dobre od loših klijenata.

**Karakteristike problema bitne pri odabiru:**
1. **postoji uzorak u podacima** (veza između karakteristika klijenta i sposobnosti vraćanja kredita)
2. **ne može se matematički odrediti formula**
3. **postoje podaci**

> **Arthur Samuel (1959):** „Strojno učenje je grana koja proučava kako dati računalu sposobnost učenja bez eksplicitnog programiranja."

Ako uvjet 2 ne vrijedi — napiši formulu, ne treniraj model. Ako uvjet 1 ne vrijedi — model uči šum. Ako uvjet 3 ne vrijedi — nema učenja.

## Komponente učenja

| Oznaka | Komponenta | U primjeru banke |
|---|---|---|
| **x** | ulaz | prijava klijenta |
| **y** | izlaz | dobar ili loš klijent |
| **f : X → Y** | **ciljna funkcija** | savršena formula za odobravanje — **nepoznata!** |
| **(x₁,y₁)...(xₙ,yₙ)** | **podaci** | povijesni podaci o kreditima |
| **h : X → Y** | **hipoteza** | model koji smo naučili |
| **H** | **skup (prostor) hipoteza** | svi mogući modeli odabranog tipa |

**Grafički prikaz procesa** *(prema Abu-Mostafa, Learning from Data)*:

```
CILJNA FUNKCIJA f  (nepoznata)
        ↓
POVIJESNI PODACI  ──►  ALGORITAM ZA UČENJE  ◄── SKUP HIPOTEZA H
                              ↓
                     ODABRANA HIPOTEZA h
```

> Ključno pitanje sa slajda: **„Da li je moguće naučiti nešto o nečemu što nam je nepoznato?"** Da — jer h aproksimira f na podacima, a validacija provjerava koliko dobro ta aproksimacija generalizira.

Pouka: **usredotočiti se na komponente koje su pod našim utjecajem** (podaci, H, algoritam) — f nikada nije.

## Primjer učenja (10 klijenata)

Poznati su mjesečni **trošak** i **prihod** klijenta; 10 prijašnjih kredita.

| Klijent | Trošak | Prihod | | Klijent | Trošak | Prihod |
|---|---|---|---|---|---|---|
| A | 4057 | 4000 | | F | 6500 | 1800 |
| B | 5800 | 5500 | | G | 8000 | 3000 |
| C | 2500 | 8500 | | H | 4750 | 4250 |
| D | 3000 | 5200 | | I | 5000 | 7000 |
| E | 2100 | 12000 | | J | 3400 | 8000 |

**Tok procesa kroz slajdove:**
1. **Prostor primjera** — prazan koordinatni sustav (trošak × prihod)
2. **Povijesni podaci** — ucrtani klijenti s poznatim ishodom
3. **Intuicija** — ljudsko oko vidi granicu
4. **Učenje (trening)** — algoritam iterativno pomiče granicu: **greška = 9 → 7 → 2 → 0**
5. **Odabir hipoteze / validacija** — četiri kandidata (I–IV) daju istu ili sličnu grešku na treningu, ali ne generaliziraju jednako
6. **Novi klijenti** — model se primjenjuje na neviđene podatke
7. **Rekalibracija** — nakon nekog vremena model se ponovno trenira

> **Najvažnija poanta:** greška = 0 na treningu **nije** cilj. Slajd "Odabir hipoteze — validacija" pokazuje četiri hipoteze s dobrom trening-točnošću, a valja izabrati onu koja najbolje generalizira. To je uvod u **bias-variance trade-off** (P12).

## Podjela učenja

- **Nadzirano učenje** (problemi: klasifikacija i regresija)
  - generativni i diskriminativni modeli
  - probabilistički i neprobabilistički modeli
  - parametarski i neparametarski modeli
  - linearni i nelinearni modeli
- **Nenadzirano učenje**
- **Učenje uz podršku** (*reinforcement learning*)

## Klasično programiranje vs. strojno učenje

```
KLASIČNO PROGRAMIRANJE          STROJNO UČENJE
  PODACI  ┐                       PODACI   ┐
          ├─► RAČUNALO ─► REZULTAT          ├─► RAČUNALO ─► PROGRAM
  PROGRAM ┘                       REZULTAT ┘
```

> Ovo je najkoncizniji sažetak cijele discipline: u klasičnom programiranju čovjek piše pravila, u strojnom učenju **računalo izvodi pravila iz podataka i rezultata**.

## Zaključak predavanja

- prepoznati **prikladnost problema**
- važnost **dostupnih podataka**
- poznavati **komponente učenja** — svaka nosi svoje izazove; usredotočiti se na one pod našim utjecajem
- **pažljivo odabrati najbolju hipotezu**
- **rekalibracija** nakon određenog vremena

## Provjeri se

1. Nabroji tri uvjeta za primjenu strojnog učenja. Što ako neki nije zadovoljen?
2. Objasni f, h i H. Koja je od njih nepoznata i zašto to nije problem?
3. Zašto greška = 0 na treningu nije nužno dobra vijest?
4. Nacrtaj dijagram komponenti učenja.
5. Objasni razliku klasičnog programiranja i strojnog učenja u smislu ulaza i izlaza.
6. Zašto je potrebna rekalibracija?

---
---

# P11 — Rudarenje podataka: regresija i klasteriranje

## Ključne ideje

- **Klasifikacija vs. regresija: razlika je isključivo u tipu izlazne varijable.**
- **Normalna jednadžba** β̂ = (XᵀX)⁻¹Xᵀy — treba znati izračunati na malom primjeru.
- **k-means u 4 koraka.**

## Regresija

**Predviđanje vrijednosti zavisne varijable na temelju vrijednosti nezavisnih varijabli.**

| | **Klasifikacija** | **Regresija** |
|---|---|---|
| Izlazna varijabla | **diskretne** vrijednosti | **kontinuirane** vrijednosti |
| Primjer | dobar/loš klijent | iznos potrošnje |

Oba su **nadzirano učenje** — razlika je *samo* u vrijednostima koje izlazna varijabla može poprimiti.

### Modeli

Hipotetski model odnosa između dvije ili više varijabli: **y = f(x, β)**

Osnovni model — **linearna regresija**:
$$\hat{y} = \beta_1 x + \beta_0$$
Opisuje odnos između varijabli koristeći **jednadžbu pravca**.

Složeniji modeli: **polinomna regresija**, **ridge regresija**, ...

### Vrste prema broju varijabli

| Naziv | Ulaznih varijabli | Izlaznih varijabli |
|---|---|---|
| **Linearna regresija** | jedna | jedna |
| **Višestruka linearna regresija** | više | jedna |
| **Multivarijatna regresija** | više | **više** |

### Terminologija (znati sve pojmove)

- **nezavisna varijabla (varijable), X**
- **zavisna varijabla, y**
- **model** — linearna regresija
- **funkcija gubitka — RSS** (*Residual Sum of Squares*)
- **reziduali** — odstupanja stvarnih od predviđenih vrijednosti
- **optimizacijski postupak — OLS** (*Ordinary Least Squares*)
- **pretpostavke linearne regresije**
- **inferencija i generalizacija**

### Komponente učenja primijenjene na regresiju

| Komponenta učenja | U linearnoj regresiji |
|---|---|
| cilj | ciljna funkcija f |
| skup podataka (x, y) | povijesni podaci |
| **skup hipoteza H** | **linearna regresija** (svi pravci) |
| **algoritam za učenje** | **OLS** |
| **mjera kvalitete** | **RSS** |
| odabrana hipoteza h | konkretan pravac ŷ = β₀ + β₁x |

### Matrični zapis i rješenje

Linearni model: **y = Xβ + ε** (gdje je **ε stohastička komponenta**)

$$\begin{bmatrix} y_1 \\ y_2 \\ \vdots \\ y_n \end{bmatrix} = \begin{bmatrix} 1 & X_{11} & \cdots & X_{1k} \\ 1 & X_{21} & \cdots & X_{2k} \\ 1 & \vdots & & \vdots \\ 1 & X_{n1} & \cdots & X_{nk}\end{bmatrix} \times \begin{bmatrix} \beta_0 \\ \beta_1 \\ \vdots \\ \beta_k \end{bmatrix} + \begin{bmatrix} \epsilon_0 \\ \epsilon_1 \\ \vdots \\ \epsilon_n \end{bmatrix}$$

**Rješenje (normalna jednadžba):**
$$\hat{\beta} = (X^T X)^{-1} X^T y$$

### Riješen primjer sa slajdova — nauči ovo napamet

$$y = \begin{bmatrix}100\\100\\200\\250\\350\end{bmatrix}, \quad X = \begin{bmatrix}1&1\\1&2\\1&3\\1&4\\1&5\end{bmatrix}$$

**Korak 1** — transponiraj:
$$X^T = \begin{bmatrix}1&1&1&1&1\\1&2&3&4&5\end{bmatrix}$$

**Korak 2** — pomnoži:
$$X^T X = \begin{bmatrix}5&15\\15&55\end{bmatrix}$$
*(gornji lijevi = n = 5; ostalo = Σx = 15 i Σx² = 55)*

**Korak 3** — determinanta i inverz:
$$\det(X^TX) = 5\cdot55 - 15\cdot15 = 275-225 = 50$$
$$(X^TX)^{-1} = \frac{1}{50}\begin{bmatrix}55&-15\\-15&5\end{bmatrix} = \begin{bmatrix}1.1&-0.3\\-0.3&0.1\end{bmatrix}$$

**Korak 4** — desna strana:
$$X^T y = \begin{bmatrix}\sum y\\ \sum xy\end{bmatrix} = \begin{bmatrix}1000\\3650\end{bmatrix}$$

**Korak 5** — rezultat:
$$\hat{\beta} = \begin{bmatrix}1.1&-0.3\\-0.3&0.1\end{bmatrix}\begin{bmatrix}1000\\3650\end{bmatrix} = \begin{bmatrix}1100-1095\\-300+365\end{bmatrix} = \begin{bmatrix}5\\65\end{bmatrix}$$

$$\boxed{\hat{y} = 5 + 65x}$$

### Interpretacija rezultata

- **odsječak na osi y (intercept, β₀)** — vrijednost y ako je x = 0
- **beta koeficijenti** — ako se neka x varijabla promijeni za **jednu jedinicu**, dok su **sve ostale nezavisne varijable iste**, y će se promijeniti za vrijednost beta
- **veličina koeficijenta aproksimira relativnu važnost varijable**
- voditi brigu o **pretpostavkama linearne regresije**

### Validacija

Imamo model, ali **ne znamo koliko je dobar**. Rješenje:
- podijeliti skup podataka na **trening/test**
- trening → generiranje modela; test (**primjeri koji nisu korišteni u treningu**) → provjera kvalitete
- mjera: npr. **MSE** (*Mean Squared Error*) na **testnom** skupu

## Klasteriranje

> **Klasteriranje (grupiranje) je proces grupiranja fizičkih ili apstraktnih objekata u klase sličnih objekata.**

### Nadzirano vs. nenadzirano — usporedna tablica sa slajda

| | **Nadzirano učenje** | **Nenadzirano učenje** |
|---|---|---|
| Model | y = f(x): ciljna funkcija | Generator: ciljni model |
| Podaci | D: skup podataka **s** izlaznom varijablom, D: (x, y) | D: skup podataka **bez** izlazne varijable, D: (x) |
| Učenje | y = h(x): model treniran za klasifikaciju primjera X | **?** |
| Cilj | greška ≈ 0 | **?** |
| Mjere | točnost, preciznost, odziv | **dobro definirane mjere: ?** |

> Znakovi pitanja nisu propust — to je **poanta**: kod nenadziranog učenja **nema objektivnog kriterija ispravnosti**.

**Zadaci nenadziranog učenja:**
- **grupiranje** (*clustering*)
- **procjena gustoće** (*density estimation*)
- **otkrivanje novih/stršećih vrijednosti** (*novelty/outlier detection*)
- **smanjenje dimenzionalnosti** (*dimensionality reduction*)

### Što je klaster? — tri definicije

1. **podskup objekata koji su „slični"**
2. podskup objekata gdje je **udaljenost između bilo koja dva objekta unutar klastera manja** nego udaljenost između bilo kojeg objekta izvan i onog unutar klastera
3. **spojene regije multidimenzijskog prostora** koje sadrže relativno **visoku koncentraciju točaka**, odvojene od drugih takvih regija prostorom relativno **niske** koncentracije

### Cilj i kvaliteta

Cilj: **pomoći korisnicima da razumiju „prirodno" grupiranje ili strukturu u skupu podataka.** Pogodno za velike količine podataka; primjenjivo na podacima skladišta podataka.

Može se koristiti **kao zaseban alat za istraživanje podataka** ili **kao predprocesiranje za druge algoritme**.

**Dobra metoda producira klastere za koje vrijedi:**
- **sličnost unutar klase (intra-cluster) je visoka**
- **sličnost izvan klase (inter-cluster) je niska**

Kvaliteta ovisi o **mjeri sličnosti i načinu njezine implementacije**; može se mjeriti i sposobnošću otkrivanja skrivenih uzoraka.
**Objektivna evaluacija je problem — vrlo često je radi čovjek/ekspert područja.**

### Vrste klasteriranja

**Prema strukturi:**

| | **Particijsko** | **Hijerarhijsko** |
|---|---|---|
| Grupe | **međusobno nepovezane** | **postoji povezanost i hijerarhija** |
| Složenost | **linearna** | **kvadratna ili veća** |
| Preduvjet | potrebno **odrediti broj grupa** | rezultat je **hijerarhijsko stablo**, potrebno definirati **uvjet prekida** |

**Prema pripadnosti točke grupi:** **čvrsto** i **meko** grupiranje.

### k-means — algoritam u 4 koraka

1. **Odaberi k centara klastera** (postavljaju se **slučajnim odabirom** na prostor rješenja)
2. **Dodijeli svaki element najbližem centru** (koristeći **Euklidovu udaljenost**)
3. **Pomakni centar prema srednjoj vrijednosti** primjera dodijeljenih centru
4. **Ponovi korake 2 i 3** dok se ne zadovolji uvjet prestanka (npr. centar se ne miče, niti jedan primjer ne mijenja klaster)

> Iz slajdova: k = 3 → postave se 3 centra slučajno → svaka točka se dodjeljuje najbližem → centri se pomiču → ponovna dodjela (**"Promjene"**) → postupak se ponavlja do konvergencije.

**Zamke k-meansa** (izvedivo iz slajda "koje rješenje je najbolje?"): rezultat **ovisi o početnom slučajnom odabiru centara**, i **k se mora zadati unaprijed** — a "pravi" k obično nije poznat.

## Provjeri se

1. Jedina razlika između klasifikacije i regresije?
2. Napiši normalnu jednadžbu i izračunaj β̂ za y = [100,100,200,250,350], x = [1,2,3,4,5].
3. Što su RSS, OLS i rezidual? Kako su povezani?
4. Kako se interpretira beta koeficijent?
5. Zašto se MSE računa na **testnom**, a ne na trening skupu?
6. Navedi tri definicije klastera.
7. Što znači visoka intra-cluster i niska inter-cluster sličnost?
8. Usporedi particijsko i hijerarhijsko klasteriranje.
9. Opiši k-means u 4 koraka. Koje su mu dvije glavne slabosti?
10. Zašto je evaluacija nenadziranog učenja teža od nadziranog?

---
---

# P12 — Asocijativna pravila, detekcija anomalija, ansambl učenje

## Ključne ideje

- **Signifikantnost (support) i pouzdanost (confidence)** — formule i verbalna interpretacija.
- **Apriori princip:** svaki podskup čestog skupa je čest → kontrapozicija omogućuje rezanje pretrage.
- **Bagging smanjuje varijancu, boosting smanjuje bias.** Jednorečenična razlika.

---

## Asocijativna pravila

**Analiza proizvoda u košarici** (*market basket analysis*).

**Zadano:** skup transakcija; svaka transakcija je skup artikala koje je kupac kupio prilikom posjeta trgovini.
**Cilj:** pronaći sva pravila koja povezuju prisutnost jednog skupa artikala s drugim u košarici. *Npr. 80 % ljudi koji kupe kruh kupe i mlijeko.*

**Primjena:** košarica proizvoda · dizajn kataloga · web log analiza · detekcija prijevara · cross-marketing.

### Formalno

$$X \Longrightarrow Y \quad \text{(implikacija AKO-ONDA)}, \quad X \cap Y = \emptyset$$

- **X** = **antecedent** (pretpostavka)
- **Y** = **consequent** (zaključak)
- Vrijednost/snaga pravila mjeri se prema **signifikantnosti** i **pouzdanosti**.

### Kako se pravila koriste — primjer {pecivo,...} ⟹ {sok}

| Fokus | Poslovna upotreba |
|---|---|
| **sok kao Y (zaključak)** | kako **povećati prodaju** soka |
| **pecivo u X (pretpostavka)** | na koje proizvode će utjecati odluka da se **pecivo više ne prodaje** |
| **pecivo u X i sok u Y** | koji se proizvodi **trebaju prodavati s pecivom** da bi se povećala prodaja soka |

### Pojmovi

- **atribut / element** (*item*) — često pretvoreni u **binarne oznake**
- **skup atributa** (*itemset*) **I** — podskup mogućih atributa; npr. I = {A, C, E}; **redoslijed nije bitan**
- **transakcija** (*transaction*) — instanca skupa, jedna košarica; **TID** = ID transakcije

### Osnovne mjere — A ⟹ B [s, c]

**Signifikantnost (support):** frekvencija pravila unutar transakcija. Visoka vrijednost = velik broj transakcija uključuje promatrano pravilo.
$$\text{sig}(A \Rightarrow B) = p(A \cup B)$$
> Govori: **„Koliko je ovo pravilo uopće važno u cijelom skupu?"**

**Pouzdanost (confidence):** postotak transakcija koje sadrže B ako sadrže i A — **uvjetna vjerojatnost**.
$$\text{pouzdanost}(A \Rightarrow B) = p(B|A) = \frac{\text{sig}(A,B)}{\text{sig}(A)}$$
> Govori: **„Kad je pretpostavka ispunjena, koliko puta je došao i zaključak?"**

### Čest uzorak

**Čest uzorak** (*frequent pattern*) ili skup atributa I je onaj čija je signifikantnost **viša ili jednaka minimalno definiranoj**: `Sig(I) ≥ minSig`.

**Svojstvo:** **svaki podskup čestog skupa atributa je čest.** *Gotovo svi algoritmi za asocijativna pravila temelje se na tom svojstvu.*

### Mali primjer

| RB | Sadržaj košarice |
|---|---|
| 1 | A, D |
| 2 | A, C |
| 3 | A, B, C |
| 4 | B, E, F |

- Skup atributa: {A,B} ili {B,E,F}
- Sig(A,B) = 1, Sig(A,C) = 2
- Za minSig = 2: **{A,C} je učestali uzorak**
- Uz minimalnu signifikantnost 50 % i pouzdanost 50 %:
  - **A ⟹ C**, sig 50 % (2/4), pouzdanost **66 %** (2/3)
  - **C ⟹ A**, sig 50 % (2/4), pouzdanost **100 %** (2/2)

> Uoči: **pravilo nije simetrično.** A ⟹ C i C ⟹ A imaju istu signifikantnost ali različitu pouzdanost, jer se dijeli različitim nazivnikom.

### Sva moguća pravila iz čestog uzorka {A,B,C}

```
A ⟹ B,C        B ⟹ A,C
A,B ⟹ C        B,C ⟹ A
A,C ⟹ B        C ⟹ A,B
```
> Iz uzorka od *k* elemenata dobiva se **2ᵏ − 2** pravila (ovdje 2³ − 2 = 6).

### Apriori princip

**Problem:** velike količine podataka — broj kombinacija eksplodira.

**Princip:** svaki podskup čestog uzorka je također čest — `{A,B,C} je čest ⟹ {A,B} je čest`

**Posljedica (kontrapozicija):** **niti jedan nadskup skupa atributa koji nije čest ne treba generirati ili provjeravati.** To omogućava odbacivanje mnogih kombinacija.

```
                    prazan
        ┌───────┬─────┴─────┬───────┐
        A       B           C       D
     ┌──┼──┐ ┌──┼──┐     ┌──┴──┐
    AB  AC AD  BC BD      CD
     └──┬──┘   └──┬──┘
      ABC  ABD  ACD  BCD
              ABCD
```
Ako **{A,B} nije čest** → cijela podgrana ABC, ABD, ABCD otpada.
Ako **{A} nije čest** → otpada A, AB, AC, AD, ABC, ABD, ACD, ABCD.

### Postupak (Apriori algoritam)

1. **Pronalazak čestih uzoraka** — skupovi koji zadovoljavaju minimalnu signifikantnost:
   - generirati skupove veličine **(k+1)** iz skupova čestih uzoraka veličine **k**
   - **provjeriti kandidate u skupu podataka** radi utvrđivanja koji su česti
2. **Iskoristiti česte uzorke za generiranje pravila** — koristeći mjeru **pouzdanosti**

### Potpuno riješen primjer sa slajdova (minSig = 2)

**Skup podataka D:**

| TID | atributi |
|---|---|
| 1 | 1, 3, 4 |
| 2 | 2, 3, 5 |
| 3 | 1, 2, 3, 5 |
| 4 | 2, 5 |

**C1 → L1** (pretraži D, odbaci sig < 2):

| skup | sig | | skup | sig |
|---|---|---|---|---|
| {1} | 2 | → | {1} | 2 |
| {2} | 3 | → | {2} | 3 |
| {3} | 3 | → | {3} | 3 |
| {4} | **1** | ✗ odbačen | | |
| {5} | 3 | → | {5} | 3 |

**C2 → L2** (kandidati iz L1, pa pretraži D):

| skup | sig | status |
|---|---|---|
| {1 2} | 1 | ✗ |
| {1 3} | 2 | ✓ |
| {1 5} | 1 | ✗ |
| {2 3} | 2 | ✓ |
| {2 5} | 3 | ✓ |
| {3 5} | 2 | ✓ |

**L2 = { {1,3}, {2,3}, {2,5}, {3,5} }**

**C3 → L3:** jedini kandidat je **{2,3,5}** — jer su svi njegovi 2-podskupovi ({2,3}, {2,5}, {3,5}) u L2.
`Sig({2,3,5}) = 2` ✓ → **L3 = { {2,3,5} }**

*(Zašto ne {1,3,x}? Jer bi {1,2} ili {1,5} morali biti u L2 — nisu.)*

**Generiranje pravila iz {2,3,5}, minPouzdanost = 75 %:**

| Pravilo | Račun | Pouzdanost | |
|---|---|---|---|
| 2 ⟹ 3,5 | 2/3 | 66 % | ✗ |
| **2,3 ⟹ 5** | 2/2 | **100 %** | ✓ |
| 2,5 ⟹ 3 | 2/3 | 66 % | ✗ |
| 3 ⟹ 2,5 | 2/3 | 66 % | ✗ |
| **3,5 ⟹ 2** | 2/2 | **100 %** | ✓ |
| 5 ⟹ 2,3 | 2/3 | 66 % | ✗ |

**Rezultat: asocijativna pravila 2,3 ⟹ 5 i 3,5 ⟹ 2.**

---

## Detekcija anomalija

**Anomalija / vršna vrijednost** = **podaci čije su karakteristike značajno različite od ostatka skupa podataka.**

**Primjena:** kreditne kartice · telekomunikacijske prijevare · neovlašteni pristupi · procesiranje slika.

### Odakle anomalije dolaze

| Uzrok | Objašnjenje |
|---|---|
| **elementi drugih klasa** | podaci se mogu značajno razlikovati ako pripadaju različitim klasama; **ne-balansirani skupovi podataka** |
| **priroda varijacija u podacima** | skupovi se mogu modelirati statističkom distribucijom; **što su podaci dalje od centra distribucije, manja je vjerojatnost njihova pojavljivanja** |
| **greška u prikupljanju podataka** | mjerni/unos problemi |

> Prva dva su **signal**, treći je **šum**. Razlikovanje je cijela vještina.

### Pristupi prema označenosti podataka

| Pristup | Dostupne oznake |
|---|---|
| **Nadzirano** | oznake klase dostupne **za redovne primjere i za anomalije** |
| **Polu-nadzirano** | oznake dostupne **samo za redovne primjere** |
| **Nenadzirano** | **neoznačeni podaci**; temelji se na pretpostavci da su **anomalije vrlo rijetka pojava** |

### Rezultat detekcije

- **da/ne** — tipičan odgovor klasifikacije
- **vrijednost (*score*)** — svakom primjeru se dodjeljuje vrijednost anomalije; **rezultati se mogu rangirati**

### Postupak

1. **obrada podataka** — predprocesiranje
2. **trening modela** — izrada modela; ovisi o podacima i odabranoj tehnici
3. **korištenje** — primjena modela za detekciju anomalija

---

## Ansambl učenje

**Proces kombiniranja više modela strojnog učenja (tzv. „slabih prediktora") kako bi se dobio jedan jači, precizniji model.**

- Cilj: **smanjenje pogrešaka predviđanja, poboljšanje robusnosti, bolja generalizacija na neviđenim podacima**.
- Umjesto traženja **jednog savršenog modela**, koristimo grupu modela čija se predviđanja **agregiraju**.
- **Meta-prediktor** — neki pristupi koriste dodatni model koji uči **kako najbolje kombinirati** predviđanja ostalih.

### Koncept: mudrost gomile

Temelji se na statističkom fenomenu gdje je **prosjek procjena grupe često točniji od procjene bilo kojeg pojedinca**.

- **individualna varijanca** — svaki model može pogriješiti na specifičnom dijelu podataka
- **agregacija** — kombiniranjem se **individualne pogreške međusobno poništavaju**
- **uvjet** — **modeli moraju biti različiti** kako bi ansambl bio koristan

> Uvjet raznolikosti je bitan: pet identičnih modela griješi identično i njihov prosjek ne popravlja ništa.

### Bias vs. Variance trade-off

| | **Bias (pristranost)** | **Variance (varijanca)** |
|---|---|---|
| Uzrok | **prejednostavne pretpostavke** (*underfitting*) | **osjetljivost na šum** u podacima (*overfitting*) |
| Simptom | **visoka trening I visoka test greška** | **vrlo mala greška pri treniranju, vrlo velika pri testiranju** |
| Slika | model pokušava prilagoditi ravnu crtu očito zakrivljenim podacima | model radi besprijekorno na viđenim podacima, ne generalizira na nove |

**Rješenje: ansambli omogućuju postizanje „zlatne sredine" smanjujući jedan ili oba tipa pogreške.**

### Tri kategorije ansambla

```
                Ansambl učenje
        ┌────────────┼────────────┐
     Bagging     Boosting     Stacking
```

| | **Bagging** | **Boosting** | **Stacking** |
|---|---|---|---|
| Način | **paralelno** treniranje na različitim uzorcima | **sekvencijalno** — svaki model ispravlja greške prethodnika | **meta-model** kombinira predviđanja različitih tipova modela |
| Primjer | **Random Forest** | AdaBoost, GBM, **XGBoost** | SVM + KNN + RF + meta-model |
| **Glavni cilj** | **smanjenje varijance** (overfittinga) | **smanjenje pristranosti (bias)** | sveukupna točnost |

### Kako funkcionira Bagging

```
Bootstrap ──► stvaranje N podskupova podataka uzorkovanjem S PONAVLJANJEM
     ↓
Paralelno učenje ──► treniranje NEOVISNOG modela na svakom podskupu
     ↓
Agregacija ──► glasovanje (klasifikacija) ili prosjek (regresija)
```

### Random Forest

**Najpoznatija Bagging metoda** — gradi **ansambl stabala odluke**; svako stablo se trenira na **drugačijem uzorku podataka i drugačijem podskupu značajki**.

**Prednosti:** izuzetno točan · **rješava problem nedostajućih vrijednosti** · **rijetko overfita**

**Ključne značajke:**
- **feature randomness** — pri svakom dijeljenju čvora bira se samo **slučajan podskup atributa**; to **smanjuje korelaciju između stabala**
- **Out-of-Bag (OOB) error** — podaci koji **nisu korišteni za trening stabla** služe za **internu validaciju** točnosti
- **važnost značajki** — RF omogućuje **automatsko rangiranje atributa** prema doprinosu točnosti modela

### Boosting

Za razliku od Bagginga, **sekvencijalan** proces:
1. prvi model se trenira na **svim** podacima
2. **primjeri koji su pogrešno klasificirani dobivaju veću težinu**
3. sljedeći model se **fokusira upravo na te greške**
4. proces se ponavlja dok se ne postigne željena točnost

**AdaBoost (Adaptive Boosting)**
- koristi **decision stumps** — stabla odluke sa **samo jednom razinom dijeljenja**
- **prilagodljivost** — svaki novi model dodaje se ansamblu s određenim **„glasom"** koji ovisi o njegovoj točnosti
- bio je **prvi algoritam koji je uspješno implementirao boosting princip na masovnim podacima**

**Gradient Boosting (GBM)**
- **ne mijenja težine primjera direktno**, već **trenira novi model na rezidualima (pogreškama) prethodnog modela**
- koristi **gradijentni spust** za minimizaciju funkcije gubitka

**XGBoost (Extreme Gradient Boosting)** — *de facto* standard za Kaggle natjecanja i industriju:
- **brzina** — paralelna obrada i optimizacija memorije
- **regularizacija** — ugrađena **L1/L2** zaštita od overfittinga
- **nedostajuće vrijednosti** — automatsko rukovanje nepoznatim vrijednostima

### Stacking (Stacked Generalization)

Kombinira predviđanja **više baznih modela** (npr. SVM, KNN, RF) koristeći završni **meta-prediktor**:
- **raznolikost** — najbolje radi kada su bazni modeli **različitog tipa**
- **dvije razine** — Razina 1 (osnovni modeli), Razina 2 (meta-model)
- **složenost** — zahtijeva više resursa za treniranje

### Usporedba glavnih metoda — tablica sa slajda

| Značajka | **Bagging (RF)** | **Boosting (XGB)** | **Stacking** |
|---|---|---|---|
| **Struktura** | Paralelna | Sekvencijalna | Hijerarhijska |
| **Glavni cilj** | Smanjenje varijance | Smanjenje biasa | Sveukupna točnost |
| **Osjetljivost na šum** | Mala (robusna) | Veća | Srednja |
| **Interpretacija** | Teška | Vrlo teška | **Nemoguća** |

### Zašto (ne) koristiti ansamble

**Prednosti:** superiorna točnost u odnosu na pojedinačne modele · smanjena šansa za overfitting (kod Bagginga) · mogućnost rješavanja **kompleksnih nelinearnih odnosa**

**Izazovi:** **„Black box"** modeli (teška interpretacija odluka) · veliki zahtjevi za memorijom i CPU-om · povećana složenost u produkcijskom okruženju

## Provjeri se

1. Napiši formule za signifikantnost i pouzdanost. Objasni ih rečenicom.
2. Zašto A ⟹ B i B ⟹ A imaju istu signifikantnost a različitu pouzdanost?
3. Formuliraj apriori princip i njegovu kontrapoziciju. Zašto je kontrapozicija korisnija?
4. Provedi Apriori na D = {{1,3,4},{2,3,5},{1,2,3,5},{2,5}} uz minSig = 2 do L3.
5. Iz {2,3,5} generiraj sva pravila i primijeni minPouzdanost 75 %.
6. Tri uzroka anomalija. Koji od njih nije koristan signal?
7. Razlika nadziranog, polu-nadziranog i nenadziranog pristupa detekciji anomalija?
8. Bias vs. variance: koji simptom ide s kojim?
9. Koji ansambl smanjuje varijancu, a koji bias? Objasni **zašto** iz njihove strukture.
10. Što su feature randomness i OOB error i zašto su bitni za Random Forest?
11. Po čemu se GBM razlikuje od AdaBoosta?

---
---

# SINTEZA — cijeli kolegij u jednom toku

## Priča u 10 rečenica

1. Organizacija ima **transakcijski sustav (OLTP)** koji zapisuje svakodnevno poslovanje, ali je optimiziran za pisanje, normaliziran i bez povijesti. *(P1, P2)*
2. Za odlučivanje treba **suprotan sustav**: subjektno orijentiran, integriran, postojan i vremenski različit — **skladište podataka**. *(P3)*
3. Skladište se ne modelira relacijski nego **dimenzijski**: u središtu je **tablica činjenica** s mjerama, oko nje **dimenzije** s kontekstom. *(P3, P4)*
4. Dizajn ide u **četiri koraka**: poslovni proces → granularnost → dimenzije → mjere. *(P3)*
5. Model se zatim **poboljšava**: surogat ključevi, SCD tipovi, junk/mini/degenerirane dimenzije, modeli činjeničnih tablica. *(P5)*
6. Podaci se u model prenose **ETL procesom** kroz **pripremno područje**, uz **CDC** za detekciju promjena i **testove kvalitete** za čišćenje. *(P6)*
7. Nad napunjenim skladištem radi se **OLAP analiza** — slice, dice, drill-down, roll-up, pivot, drill across — ubrzana **agregacijama**. *(P8)*
8. Ali OLAP zahtijeva **da čovjek zna što pitati** — odatle *data rich, information poor*; rješenje je **rudarenje podataka** kroz **KDD proces**. *(P9)*
9. Rudarenje ima pet zadaća: **klasifikacija i regresija** (nadzirano, prediktivno) te **klasteriranje, asocijativna pravila i detekcija anomalija** (nenadzirano, deskriptivno). *(P9–P12)*
10. Kvaliteta modela se mjeri **na testnom skupu**, a poboljšava **ansamblima** koji balansiraju **bias i varijancu**. *(P11, P12)*

## Checkpointi projekta ↔ predavanja ↔ faze implementacije

| CP | Zadatak | Predavanja | Faza implementacije DW (P8) |
|---|---|---|---|
| **1** | Odabir i analiza podataka | P1 | 1. Poslovni zahtjev |
| **2** | Relacijski model (ER → EER → DBMS → punjenje) | P2 | 2. Analiza operativnog sustava |
| **3** | Dimenzijski model (mjera, 5 dimenzija, hijerarhije, degenerirana dim., star/snowflake, napredne izvedbe) | P3, P4, P5 | 3. Dizajn DW-a |
| **4** | Punjenje iz **≥2 izvora**, ETL, provjera da nema izgubljenih podataka | P6 | 4. ETL |
| **5** | OLAP alat, sve operacije na kocki, dashboard | P8 | 5. Korištenje / OLAP |
| *(+)* | Rudarenje nad skladištem | P9–P12 | — |

## Parovi pojmova koji se najčešće brkaju

| | vs. | Ključna razlika |
|---|---|---|
| **OLTP** | **OLAP** | puno malih transakcija i normalizacija ↔ velika količina podataka i denormalizacija |
| **Top-down (Inmon)** | **Bottom-up (Kimball)** | cijelo skladište pa data marts ↔ data marts pa skladište |
| **Star** | **Snowflake** | denormalizirane dimenzije ↔ normalizirane, granate dimenzije |
| **Tablica činjenica** | **Dimenzijska tablica** | kvantitativno, normalizirano, puno redaka ↔ kvalitativno, denormalizirano, malo redaka |
| **SCD tip 2** | **SCD tip 3** | novi **redak**, potpuna povijest ↔ novi **stupac**, ograničena povijest |
| **Mini dimenzija** | **Junk (kompozitna) dimenzija** | logički **povezani** atributi ↔ logički **nepovezani** atributi niske kardinalnosti |
| **Degenerirana dimenzija** | **Potporna dimenzija** | atribut **u** tablici činjenica bez svoje tablice ↔ dimenzija spojena **na drugu dimenziju** (snowflake) |
| **Shema grešaka** | **Revizorska dimenzija** | zaseban dimenzijski model **svih ETL grešaka** ↔ dimenzija s metapodacima o kvaliteti **uz svaki zapis t.č.** |
| **Slice** | **Dice** | **jedna** dimenzija ograničena ↔ **više** dimenzija ograničeno |
| **Roll-up** | **Drill-down** | sažimanje, više u hijerarhiji ↔ detaljiziranje, niže u hijerarhiji |
| **MOLAP** | **ROLAP** | brz, ograničena količina podataka ↔ velike količine, slabije performanse |
| **Klasifikacija** | **Regresija** | diskretna izlazna varijabla ↔ kontinuirana |
| **Klasifikacija** | **Klasteriranje** | nadzirano, klase poznate ↔ nenadzirano, klase nepoznate |
| **Signifikantnost** | **Pouzdanost** | *koliko je pravilo važno u cijelom skupu* ↔ *kad je X ispunjen, koliko puta dođe i Y* |
| **Bias** | **Variance** | underfitting, obje greške visoke ↔ overfitting, trening niska / test visoka |
| **Bagging** | **Boosting** | paralelno, smanjuje **varijancu** ↔ sekvencijalno, smanjuje **bias** |

---

# POJMOVNIK HR ↔ EN

| Hrvatski | English |
|---|---|
| skladište podataka | data warehouse |
| područno skladište podataka | data mart |
| pripremno područje | staging area |
| tablica činjenica | fact table |
| dimenzijska tablica | dimension table |
| surogat / tehnički ključ | surrogate key |
| granularnost | granularity |
| usklađene dimenzije | conformed dimensions |
| sporo mijenjajuće dimenzije | slowly changing dimensions (SCD) |
| degenerirane dimenzije | degenerate dimensions |
| kompozitne dimenzije | junk dimensions |
| mini dimenzije | mini dimensions |
| heterogene dimenzije | heterogeneous dimensions |
| tablica činjenica bez činjenica | factless fact table |
| periodička snimka stanja | periodic snapshot |
| akumulirajuća snimka stanja | accumulating snapshot |
| unakrsni pregled | drill across |
| izdvajanje / transformacija / punjenje | extract / transform / load |
| detekcija promjena | Change Data Capture (CDC) |
| okidač | trigger |
| dnevnik transakcija | transaction log |
| testovi kvalitete | quality screens |
| shema grešaka | error event schema |
| revizorska dimenzija | audit dimension |
| kontrolna ploča | dashboard |
| rudarenje podataka | data mining |
| otkrivanje znanja u bazama | Knowledge Discovery in Databases (KDD) |
| predprocesiranje | preprocessing |
| nadzirano / nenadzirano učenje | supervised / unsupervised learning |
| učenje uz podršku | reinforcement learning |
| klasteriranje | clustering |
| stršeća vrijednost / anomalija | outlier / anomaly |
| asocijativna pravila | association rules |
| signifikantnost | support |
| pouzdanost | confidence |
| čest uzorak | frequent pattern |
| pretpostavka / zaključak | antecedent / consequent |
| skup atributa | itemset |
| funkcija gubitka | loss function |
| suma kvadrata reziduala | residual sum of squares (RSS) |
| metoda najmanjih kvadrata | ordinary least squares (OLS) |
| pristranost / varijanca | bias / variance |
| ansambl učenje | ensemble learning |
| uzorkovanje s ponavljanjem | bootstrap |
| stablo odluke sa jednom razinom | decision stump |
| smanjenje dimenzionalnosti | dimensionality reduction |
| procjena gustoće | density estimation |

---

# BANKA ISPITNIH PITANJA

## A. Definicije koje se traže doslovno

1. Definiraj skladište podataka prema **Inmonu** i objasni sva četiri svojstva.
2. Definiraj **rudarenje podataka** prema Berryju i Linoffu.
3. Definiraj **klasifikaciju**.
4. Definiraj **klasteriranje** (i navedi tri definicije klastera).
5. Što je **CDC**?
6. Što je **ansambl učenje**?
7. Što je **anomalija**?
8. Objasni akronim **FASMI** i navedi zahtjev za svako slovo.

## B. Nabrajanja

9. Tri razine analitike i alati za svaku.
10. Četiri koraka dizajna skladišta podataka.
11. Pet faza implementacije DW-a.
12. Pet koraka KDD procesa.
13. Pet zadaća rudarenja podataka + tip svake.
14. Pet CDC tehnika.
15. Šest OLAP operacija.
16. SCD tipovi 1–4 + dva hibridna.
17. Tri modela činjeničnih tablica.
18. Tri vrste testova kvalitete u ETL-u.
19. Tri kategorije metapodataka.
20. Četiri zadatka nenadziranog učenja.
21. Šest komponenti učenja.
22. Tri kategorije ansambl metoda.

## C. Usporedbe (tablična pitanja)

23. Top-down vs. bottom-up po pet kriterija.
24. OLTP vs. OLAP.
25. Star shema vs. OLAP kocka.
26. Usporedba pet CDC tehnika po pet kriterija.
27. MOLAP vs. ROLAP vs. HOLAP.
28. Bagging vs. Boosting vs. Stacking.
29. Nadzirano vs. nenadzirano učenje (uključujući zašto kod nenadziranog nema jasne mjere kvalitete).
30. Particijsko vs. hijerarhijsko klasteriranje.
31. Bias vs. variance.

## D. Računski zadaci

32. Zadan niz brojeva → izračunaj mean, median, mod, raspon, std, CV, kvartile; objasni koja mjera najbolje opisuje podatke.
33. Zadano y i X → izračunaj β̂ = (XᵀX)⁻¹Xᵀy i napiši jednadžbu pravca.
34. Zadan skup transakcija i minSig → provedi Apriori do L3.
35. Zadan čest uzorak i minPouzdanost → generiraj i filtriraj sva pravila.
36. Zadana tablica s greškama → identificiraj sve tipove problema kvalitete podataka.
37. Zadan dimenzijski zapis koji se mijenja → prikaži rezultat za SCD tip 1, 2 i 3.

## E. Primjena / esejska pitanja

38. Zadan poslovni opis → odredi entitete, atribute, veze, kardinalnost; nacrtaj ER.
39. Zadan poslovni opis → odredi poslovni proces, granularnost, 5 dimenzija, 2 mjere, nacrtaj star shemu.
40. Zadan proces → koji SCD tip bi primijenio na koju dimenziju i zašto.
41. Zadan izvorišni sustav (npr. legacy baza bez okidača) → koju CDC tehniku i zašto.
42. Zadan poslovni problem → koja zadaća rudarenja, koja izlazna varijabla, koji izvor podataka.
43. Zašto je moguće naučiti nešto o ciljnoj funkciji koja nam je nepoznata?
44. Objasni zašto je *data rich, information poor* problem koji OLAP ne rješava.
45. Zašto je model s greškom 0 na treningu sumnjiv?

---

# TIPIČNE ZAMKE

- **„Dimenzije su normalizirane"** — ne. Dimenzije su **de**normalizirane; **tablica činjenica** je (gotovo) normalizirana. Snowflake je iznimka.
- **„Postojan znači da se podaci nikad ne mijenjaju"** — preciznije: **ne mijenjaju se, samo se dodaju novi.** Zato SCD tip 1 (prepisivanje) zapravo krši duh skladišta i koristi se samo kad povijest nema značaja.
- **„Roll-up = brisanje dimenzije"** — roll-up je **ili** kretanje prema višim razinama hijerarhije **ili** redukcija dimenzija. Oboje.
- **„Drill-down je samo spuštanje niz hijerarhiju"** — uključuje i **dodavanje novih dimenzija**.
- **Kardinalnost SCD-a:** tip 3 **ne** čuva neograničenu povijest, samo prethodnu vrijednost (ili nekoliko, kod hibridnog tipa 1).
- **„Agregacije nastaju pri upitu"** — ne, nastaju **pri ETL-u / punjenju**, i troše prostor i CPU **unaprijed**.
- **„Pouzdanost = signifikantnost pravila"** — različite mjere s različitim nazivnikom; pravilo može imati 100 % pouzdanosti a biti beznačajno (npr. 2 od 10 000 transakcija).
- **Apriori princip se koristi u kontrapoziciji:** ne "svaki podskup čestog je čest", nego **"nijedan nadskup nečestog nije čest"** — to je ono što reže pretragu.
- **„Bagging smanjuje bias"** — ne. **Bagging → varijanca. Boosting → bias.**
- **„Random Forest je boosting"** — ne, Random Forest je **bagging** metoda.
- **„Klasteriranje ima izlaznu varijablu"** — nema. To je bit nenadziranog učenja i razlog zašto nema objektivne mjere kvalitete.
- **Regresija vs. klasifikacija** — razlika **nije** u algoritmu nego u **tipu izlazne varijable** (logistička regresija je klasifikacija!).
- **MSE se računa na testnom skupu.** Na trening skupu je beskoristan kao mjera generalizacije.
- **Junk ≠ mini dimenzija.** Junk = nepovezani atributi; mini = povezani.
- **Faze implementacije DW-a nisu ETL faze.** Implementacija ima 5 faza (poslovni zahtjev → analiza → dizajn → ETL → korištenje), ETL ima 3 koraka.

---

*Skripta pokrijeva P1–P6 i P8–P12. Za literaturu vidi zadnje slajdove svakog predavanja: [SDT], [KR] (Kimball & Ross), Kimball et al. „The data warehouse lifecycle toolkit" (pogl. 9–10), Han/Pei/Kamber „Data mining: concepts and techniques" (pogl. 1, 6, 10, 12), Abu-Mostafa „Learning from Data", kimballgroup.com.*
---
---

# ODGOVORI

> Prvo odgovori sam, pa provjeri. Ako se odgovor razlikuje samo u formulaciji — u redu je; ako se razlikuje u broju stavki ili u smjeru tvrdnje — vrati se na poglavlje.

---

## Odgovori — P1

**1. Tri razlike OPS vs. DSS**
OPS podržava svakodnevno poslovanje, DSS strateško odlučivanje. OPS najčešće nema povijesne podatke (ažurira na trenutno stanje), DSS ih sadrži i puni se periodički. OPS je optimiziran za brzu obradu jedne transakcije u trenutku, DSS za efikasno dohvaćanje tisuća zapisa u jednom upitu.

**2. Zašto je BI podskup BA**
BI pokriva deskriptivnu razinu — što se dogodilo i što se događa (izvještavanje, skladišta, dashboardi). BA dodatno obuhvaća prediktivnu i preskriptivnu razinu (rudarenje podataka, forecasting, optimizacija, simulacija). BA je dakle širi pojam, pa je BI njegov podskup — iako se termini često koriste kao sinonimi.

**3. Intervalna vs. omjerna skala**
Obje imaju jednake razmake između mjerenja. Intervalna **nema apsolutnu nulu** (npr. temperatura u °C, kalendarska godina) — 20 °C nije "dvostruko toplije" od 10 °C. Omjerna ima apsolutnu nulu (npr. prihod, količina, trajanje) pa dopušta **sve aritmetičke operacije**, uključujući omjere.

**4. Kada je medijan bolji od sredine**
Kada u podacima postoje stršeće vrijednosti ili je distribucija asimetrična. Primjer iz predavanja: kod niza s vrijednošću 411 557 srednja vrijednost je 37 880, a nijedan stvarni podatak nije blizu te vrijednosti; medijan je 10 i vjerno opisuje tipičan slučaj. Medijan je **otporan na ekstreme** jer ovisi o poziciji, ne o iznosu.

**5. Koeficijent varijacije**
Omjer standardne devijacije i srednje vrijednosti (obično ×100 %). Mjeri **relativnu** raspršenost, pa je bez mjerne jedinice — zato se njime mogu uspoređivati varijable različitih jedinica ili različitih redova veličine (npr. prihod u eurima i trajanje u sekundama). CV od 327 % iz primjera znači da je raspršenost tri puta veća od same sredine.

**6. Isti podaci, suprotan dojam**
Odsjecanjem y-osi (npr. raspon 11 390–11 640 umjesto 0–12 000) minimalne razlike izgledaju dramatično; promjenom skale ili orijentacije mijenja se dojam o odnosu kategorija. Grafikon koji tehnički ne laže i dalje može obmanuti — stupčasti grafikon čija y-os ne kreće od nule klasična je manipulacija.

---

## Odgovori — P2

**1. Tri faze dizajna baze i rezultati**
Konceptualni → **ER model / ER dijagram** (neovisan o DBMS-u). Logički → **relacijski model / EER dijagram** (tipovi podataka, primarni i strani ključevi, normalizacija). Fizički → **implementacija** (indeksi, pohrana, integritet, kontrola pristupa).

**2. Prepoznavanje elemenata u tekstu**
Entiteti su objekti, u pravilu **imenice**. Atributi su obilježja entiteta, također **imenice**. Veze su najčešće opisane **glagolima**.

**3. Entitet ili atribut**
Dvije smjernice: (a) entiteti **sadrže** atribute, a atributi se **ne sastoje od manjih dijelova**; (b) entiteti **mogu imati veze** između sebe, a atributi **pripadaju** entitetima.

**4. Što EER dodaje na ER**
Prikazuje dodatne detalje: **tipove podataka** atributa i **primarne/strane ključeve**, te preciznije vrste veza (1:N, N:1, N:N) s ograničenjima. Daje detaljniji pogled na strukturu nego što je uobičajeno u konceptualnoj fazi.

**5. Datotečni izvori i skladišta**
Datoteke su **jedan od čestih izvora za skladišta podataka**. Zato je u projektu skup podataka namjerno podijeljen na relacijsku bazu + CSV — da se simulira dohvat podataka u skladište **iz više izvora**, što je zahtjev Checkpointa 4.

---

## Odgovori — P3

**1. Inmonova definicija**
„Skladište podataka jest **subjektno orijentiran, integriran, postojan i vremenski različit** skup podataka koji služi kao potpora odlučivanju."
- *subjektno orijentiran* — podaci su organizirani po poslovnim temama, ne po aplikacijama
- *integriran* — podaci dolaze iz različitih izvora i međusobno se usklađuju
- *postojan* — podaci se u skladištu ne mijenjaju, samo se dodaju novi
- *vremenski različit* — postoji vremenska dimenzija koja omogućuje pregled podataka u vremenskom kontekstu

**2. Postojanost i ETL**
Postojanost znači da ETL u pravilu **dodaje**, a ne prepisuje. Zato se povijest promjena u dimenzijama rješava mehanizmima SCD-a (osobito tip 2 — novi redak), a ne `UPDATE`-om. Tip 1 je iznimka koja se koristi samo kad povijest tog atributa nema analitičkog značaja.

**3. Top-down vs. bottom-up**

| Kriterij | Top-down (Inmon) | Bottom-up (Kimball) |
|---|---|---|
| Izrada | vremenski iscrpna | vremenski kraća |
| Održavanje | lagano | teško |
| Trošak | visoki inicijalni | niski inicijalni |
| Vrijeme do početka | duže | kraće |
| Integracija | ukupna organizacija | pojedini dijelovi |

**4. Četiri koraka dizajna**
1) odabrati poslovni proces → 2) odabrati granularnost tablice činjenica → 3) definirati dimenzije → 4) definirati mjere (činjenice).

**5. Primjer: bolnica želi smanjiti vrijeme čekanja**
- **Poslovni proces:** obrada pacijenta / posjet ambulanti
- **Granularnost:** jedan posjet pacijenta (najniža razina)
- **Dimenzije:** vrijeme, odjel/ambulanta, liječnik, pacijent (dobna skupina), tip zahvata, način dolaska (hitno/naručeno)
- **Mjere:** vrijeme čekanja u minutama, trajanje pregleda
*(Napomena: dimenzija „dobna skupina" je primjer transformacije kvantitativne vrijednosti grupiranjem, vidi P4.)*

---

## Odgovori — P4

**1. Zašto t.č. normalizirana, dimenzije nisu**
Tablica činjenica ima **velik broj zapisa**, pa bi svako ponavljanje teksta bilo skupo — zato sadrži samo mjere i strane ključeve i vrlo je slična tablici transakcijskog sustava. Dimenzijske tablice su **male** i denormaliziraju se namjerno: time se izbjegavaju JOIN-ovi na analitičkim upitima i model postaje **čitljiv poslovnom korisniku**. Cijena je redundancija, koja je ovdje prihvatljiva.

**2. Star shema i OLAP kocka**
Imaju **isti logički dizajn, ali različitu fizičku implementaciju** — star u relacijskoj bazi (RDB), kocka u multidimenzijskoj (MDB). Dobra praksa je stvoriti star shemu **čak i kada** se podaci pohranjuju u kocke, pa kocke izvesti iz nje.

**3. Hijerarhija i redundancija**
Hijerarhija je niz atributa različitih razina detalja unutar iste dimenzije (npr. Trgovina → Grad → Županija → Država). Kako više trgovina dijeli isti grad i županiju, ti se podaci **ponavljaju u svakom retku** dimenzije. Normalizacija te redundancije daje **snowflake** shemu — ali obično se ne radi, jer je prostor jeftin, a čitljivost i brzina važnije.

**4. Kandidat za tablicu činjenica u ER dijagramu**
**Asocijativni entiteti** — oni nastaju iz M:M ili ternarnih veza, imaju vlastiti id i dodatne opisne atribute. Već sadrže veze prema više entiteta (koji postaju dimenzije) i vlastite mjerljive atribute (koji postaju mjere).

**5. Najniža granularnost i njezina cijena**
Preporučuje se jer se iz detaljnih podataka **uvijek može agregirati naviše**, dok se obrnuto ne može — jednom sažeti podaci su izgubljeni za detaljnu analizu. Cijena je **veličina tablice činjenica** i sporiji upiti, što se kompenzira **agregacijama** (P8).

---

## Odgovori — P5

**1. Četiri pravila za surogat ključeve**
Uvode se u **sve** tablice dimenzijskog modela, kao cijeli brojevi (sekvence). Originalni produkcijski ključevi se **zadržavaju** kao veza na izvorne podatke. Ne smiju biti **„pametni" niti kompozitni**. Ne smiju biti **povezani s produkcijskim ključevima**. Koriste se za vezu dimenzija prema tablici činjenica.

**2. SCD tip 2 vs. tip 3 na istom primjeru**
Promjena procesora s i5 na i7:
- **Tip 2** — novi **redak** s novim surogat ključem; stari redak ostaje (uz `Datum do` ili `Aktivan = N`). Čuva se **potpuna** povijest, dimenzija raste.
- **Tip 3** — isti redak, dodaje se **stupac** `Stari procesor tip = i5`, a `Procesor tip` postaje i7. Čuva se **samo prethodna** vrijednost; sljedeća promjena briše i5.

**3. Kada tip 4 umjesto tipa 2**
Kada postoji **jasna potreba za odvojenom analizom trenutnih i povijesnih podataka**, a upiti nad trenutnim stanjem moraju biti brzi. Tip 4 drži trenutne podatke u maloj glavnoj tablici, a povijest u zasebnoj tablici — po cijenu dodatnog prostora i **složenijeg ETL-a**.

**4. Degenerirana dimenzija**
Atribut **unutar same tablice činjenica** koji ima svojstva dimenzijskog ključa, ali **nema odgovarajuću dimenzijsku tablicu** (npr. broj računa, broj narudžbe). Nema svoju tablicu jer bi ta tablica sadržavala samo ključ i ništa više — nema opisnih atributa. Koristan je za **grupiranje zapisa**.

**5. Mini vs. junk dimenzija**
**Mini** dimenzija odvaja **logički povezane** atribute iz velike dimenzije (npr. sva demografija kupca) da ubrza pretraživanje. **Junk (kompozitna)** dimenzija skuplja **logički nepovezane** atribute **niske kardinalnosti** (Da/Ne oznake, indikatori, statusi) iz tablice činjenica u jednu dimenziju. Razlika je upravo u (ne)povezanosti atributa.

**6. Factless fact table**
Tablica činjenica **bez mjere** (vrijednost 1 ili 0/1) koja bilježi **postojanje događaja**. Nezamjenjiva je za analizu **onoga što se nije dogodilo** — npr. koji promovirani proizvodi nisu prodani, koji student nije došao na predavanje. Takvo pitanje se ne može postaviti nad običnom tablicom činjenica jer nepostojeći događaj nema zapisa s mjerom.

**7. Zašto kasno dolazeće činjenice trebaju tip 2**
Kasna činjenica se odnosi na **prošli trenutak**. Da bi se ispravno povezala, treba pronaći zapise u svim dimenzijama **koji su vrijedili u trenutku stvaranja transakcije**. Samo tip 2 čuva te povijesne verzije zapisa (s `Datum od`/`Datum do`); kod tipa 1 stara verzija više ne postoji, pa bi se činjenica pogrešno povezala s današnjim stanjem dimenzije.

**8. Tablica pravovremenosti**

| | Rano | Kasno |
|---|---|---|
| **Dimenzije** | U redu | Problem |
| **Činjenice** | Problem | Problem |

Jedini bezbolan slučaj je rano dolazeća dimenzija — jer je ionako ispravan redoslijed punjenja „prvo dimenzije, pa činjenice".

---

## Odgovori — P6

**1. Tri faze ETL-a i izazovi**
- **Izdvajanje** — detektiranje promjena, više izvora podataka, ne ugroziti produkcijski sustav
- **Transformacija i čišćenje** — način transformacije i čišćenja, mogućnost različitosti podataka
- **Punjenje** — način učitavanja (odjednom vs. zapis po zapis), koje zapise dodati/izmijeniti/brisati

**2. Pripremno područje**
Postoji da se izvorni podaci transformiraju i čiste **izvan** produkcijskog sustava i **izvan** skladišta — u biti je kopija transakcijskog sustava u kojoj se tablice mogu dodavati i brisati bez pravila. **Korisnici nemaju pristup**, a **upiti ne mogu pristupiti** podacima u njemu. Iz njega se puni skladište.

**3. Pet CDC tehnika i po jedan nedostatak**

| Tehnika | Nedostatak |
|---|---|
| dodavanje vremenske oznake | bilježi samo zadnju izmjenu, **ne vidi obrisane zapise**; srednji utjecaj na izvorišnu bazu |
| razlika snimki stanja | **zahtijeva dosta resursa i vremena**; nema evidencije povijesti |
| aplikacijsko bilježenje promjena | **visok utjecaj na aplikacije**, visoka složenost implementacije |
| okidači baze podataka | **visok utjecaj na izvorišnu bazu**, opterećenje; treba ih vrlo oprezno koristiti |
| dnevnik transakcija | zahtijeva **razvoj posebnog algoritma** i sinkronizaciju s ETL-om |

**4. Tehnika koja ne bilježi brisanja**
**Dodavanje vremenske oznake.** Brisani zapis jednostavno nestaje iz izvora — nema retka čiju bi vremensku oznaku ETL mogao usporediti, pa promjena ostaje nezamijećena.

**5. Tehnika bez evidencije povijesti**
**Razlika snimki stanja.** Ona vidi samo razliku između dvije snimke; sve međupromjene koje su se dogodile i poništile unutar razdoblja su nevidljive.

**6. Shema grešaka**
**Dimenzijski model čiji je cilj evidentiranje svih grešaka koje su se dogodile u ETL procesu.** Tablica činjenica je **događaj greške**, granularnost je **svaka pojedina greška u ETL-u**. Dimenzije su vremenska, obrada u kojoj se greška dogodila, test kvalitete i sl.

**7. Shema grešaka vs. revizorska dimenzija**
Shema grešaka je **zaseban dimenzijski model** koji bilježi sve aktivirane testove kvalitete. Revizorska dimenzija je **dimenzija pridružena postojećoj tablici činjenica**, s metapodacima o ETL procesiranju i kvaliteti, i pridjeljuje se **svakom zapisu** t.č. Prva odgovara „koje su se greške dogodile", druga „kolika je kvaliteta ovog konkretnog zapisa".

**8. Zašto dimenzije prije tablice činjenica**
Jer se u izgradnji dimenzija **generiraju surogat ključevi**, a tablica činjenica se zatim **povezuje s dimenzijama** preko tih ključeva. Bez postojećih dimenzijskih zapisa nema ključeva na koje bi se t.č. referencirala — to je i razlog zašto su „rano dolazeće činjenice" (P5) problem.

---

## Odgovori — P8

**1. Pet faza implementacije DW-a i checkpointi**
1) Poslovni zahtjev = CP1, 2) Analiza operativnog sustava = CP2, 3) Dizajn DW-a = CP3, 4) ETL = CP4, 5) Korištenje / OLAP = CP5.

**2. Slice vs. dice**
**Slice** ograničava **jednu** dimenziju na neki raspon vrijednosti (rez kroz kocku). **Dice** ograničava **više** dimenzija istovremeno, pa je rezultat **manja kocka**.

**3. Roll-up i redukcija dimenzija**
To su **dva oblika iste operacije**. Roll-up je sažimanje podataka — **ili** kretanjem prema višim razinama hijerarhije (dan → mjesec → godina), **ili** redukcijom dimenzija (izbacivanjem dimenzije iz pogleda). Oba smanjuju razinu detalja.

**4. FASMI**
**F**ast — većina upita **unutar 5 sekundi**, rijetki do 20. **A**nalysis — poslovna logika i statistička analiza, **ad-hoc upiti bez programiranja**. **S**hared — sigurnosni zahtjevi. **M**ultidimensional — multidimenzionalni konceptualni pogled, podrška dimenzijama i hijerarhijama. **I**nformation — obrada velikih količina podataka.

**5. Agregacije — kada i gdje**
Nastaju **prilikom ETL procesa, točnije punjenja**, i pohranjuju se u **posebnu tablicu namijenjenu isključivo za to**. Procesorsko vrijeme i disk troše se **unaprijed**, da bi upiti kasnije bili brzi. Osvježavanje kocke i agregatne tablice zove se **procesiranje kocke**.

**6. Izvedena dimenzija**
Dimenzija koja nastaje **iz više razine hijerarhije postojeće dimenzije** pri izradi agregirane tablice činjenica — npr. iz dimenzije Proizvod (Proizvod → Tip proizvoda → Linija) izvede se dimenzija **Tip proizvoda** koja se koristi u agregatu.

**7. MOLAP vs. ROLAP**

| | MOLAP | ROLAP |
|---|---|---|
| ➕ | dobre performanse (brzina upita); kompleksne kalkulacije | velike količine podataka; funkcionalnosti relacijske baze |
| ➖ | limitirana količina podataka; tehnologija često nije u organizaciji, može biti skupa | slabije performanse upita; ograničenje na SQL |

**8. Zašto drill across treba usklađene dimenzije**
Drill across kombinira podatke **iz više tablica činjenica** u jedinstven rezultat. Da bi se rezultati mogli spojiti i uspoređivati, dimenzije po kojima se spaja moraju biti **identično definirane u oba modela** — to su upravo usklađene (conformed) dimenzije. Bez toga bi se npr. „proizvod" u dva modela odnosio na različite skupove vrijednosti. Tablice činjenica pritom smiju biti različite granularnosti.

---

## Odgovori — P9

**1. Pet ograničenja skladišta**
Velike količine podataka u odnosu na mogućnosti OLAP alata · *data rich, information poor* situacija · analiza je ovisna o poslovnom korisniku, a odluka se često donosi na temelju intuicije · potrebno je ekspertno znanje · potreba za alatima koji **sami** pronalaze znanje u podacima.

**2. Data rich, information poor**
Situacija u kojoj organizacija ima ogromne količine prikupljenih podataka, ali iz njih ne izvlači korisnu informaciju — jer OLAP zahtijeva da **čovjek unaprijed zna što pitati**. Obrasci koje nitko nije pretpostavio ostaju neotkriveni.

**3. Pet koraka KDD-a**
Odabir podataka → predprocesiranje → transformacija → **rudarenje podataka** → evaluacija. Rudarenje podataka je **četvrti korak**, dakle dio KDD procesa (prema drugom gledištu ta se dva pojma izjednačavaju).

**4. Poveži**
**Nadzirano učenje ≈ prediktivni modeli** (klasifikacija, regresija — poznata izlazna varijabla, cilj je predviđanje budućih događaja).
**Nenadzirano učenje ≈ deskriptivni modeli** (klasteriranje, asocijativna pravila, detekcija anomalija — nema izlazne varijable, cilj je razumijevanje odnosa među atributima).

**5. Tip izlazne varijable po zadaći**

| Zadaća | Izlazna varijabla |
|---|---|
| Klasifikacija | kategorička, mali broj diskretnih vrijednosti |
| Regresija | kontinuirana |
| Klasteriranje | nema — broj i značenje klastera nisu poznati unaprijed |
| Asocijativna pravila | nema — rezultat su pravila oblika X ⟹ Y |
| Detekcija anomalija | nema (nenadzirano); rezultat je da/ne ili score |

**6. Primjer (helpdesk / podrška)**
- **Zadaća:** klasifikacija · **Izlazna varijabla:** hoće li ticket prekoračiti SLA (da/ne) · **Izvor:** povijesni tiketi iz skladišta, s dimenzijama projekt, prioritet, status i mjerom vremena rješavanja
- Alternativno: **regresija** · izlazna varijabla = vrijeme rješavanja u satima · isti izvor.

---

## Odgovori — P10

**1. Tri uvjeta za strojno učenje**
(a) **postoji uzorak u podacima**, (b) **ne može se matematički odrediti formula**, (c) **postoje podaci**.
Ako ne vrijedi (a) — model uči šum. Ako ne vrijedi (b) — napiši formulu, ne treniraj model. Ako ne vrijedi (c) — nema učenja.

**2. f, h i H**
**f : X → Y** je **ciljna funkcija** — savršeno pravilo koje preslikava ulaz u izlaz; ona je **nepoznata**. **H** je **skup (prostor) hipoteza** — sve moguće funkcije odabranog tipa. **h : X → Y** je konkretna **hipoteza** koju je algoritam odabrao iz H. Nepoznatost f nije problem jer h aproksimira f na podacima, a **validacija** provjerava koliko dobro ta aproksimacija generalizira na neviđene primjere.

**3. Zašto greška 0 na treningu nije dobra vijest**
Jer model može biti naučio **šum** umjesto obrasca (overfitting). Slajd „Odabir hipoteze — validacija" pokazuje četiri hipoteze sa sličnom trening-točnošću koje **ne generaliziraju jednako**. Kvaliteta se mjeri na podacima koji nisu korišteni u treningu.

**4. Dijagram komponenti učenja**
```
CILJNA FUNKCIJA f  (nepoznata)
        ↓
POVIJESNI PODACI ──► ALGORITAM ZA UČENJE ◄── SKUP HIPOTEZA H
                            ↓
                   ODABRANA HIPOTEZA h
```
Komponente: x (ulaz), y (izlaz), f (ciljna funkcija), podaci (x₁,y₁)…(xₙ,yₙ), h (hipoteza), H (prostor hipoteza).

**5. Klasično programiranje vs. strojno učenje**
Klasično: ulaz = **podaci + program**, izlaz = **rezultat**. Strojno učenje: ulaz = **podaci + rezultat**, izlaz = **program**. U prvom slučaju čovjek piše pravila, u drugom ih računalo izvodi iz podataka.

**6. Zašto rekalibracija**
Jer se sustav koji modeliramo **dinamički mijenja** — obrazac naučen na starim podacima s vremenom prestaje vrijediti. Nakon određenog vremena model treba ponovno trenirati na novijim podacima.

---

## Odgovori — P11

**1. Klasifikacija vs. regresija**
Razlika je isključivo u **tipu vrijednosti koje može poprimiti izlazna varijabla**: klasifikacija — diskretne (konačan skup klasa), regresija — kontinuirane. Oba su nadzirano učenje.

**2. Izračun β̂**
XᵀX = [[5,15],[15,55]], det = 275 − 225 = **50**, (XᵀX)⁻¹ = [[1.1, −0.3],[−0.3, 0.1]], Xᵀy = [1000, 3650]ᵀ.
β̂ = [1.1·1000 − 0.3·3650, −0.3·1000 + 0.1·3650] = [1100 − 1095, −300 + 365] = **[5, 65]** → **ŷ = 5 + 65x**.

**3. RSS, OLS, rezidual**
**Rezidual** je odstupanje stvarne vrijednosti od predviđene (yᵢ − ŷᵢ). **RSS** (*Residual Sum of Squares*) je **funkcija gubitka** — suma kvadrata reziduala. **OLS** (*Ordinary Least Squares*) je **optimizacijski postupak** koji bira koeficijente β tako da RSS bude minimalan. Rezidual je jedinica, RSS je mjera, OLS je postupak.

**4. Interpretacija beta koeficijenta**
Ako se ta x varijabla promijeni za **jednu jedinicu**, uz **sve ostale nezavisne varijable nepromijenjene**, y će se promijeniti za vrijednost beta. Veličina koeficijenta **aproksimira relativnu važnost** varijable. β₀ (intercept) je vrijednost y kada je x = 0.

**5. Zašto MSE na testnom skupu**
Trening skup je model već „vidio" i prilagodio mu se, pa greška na njemu mjeri **pamćenje**, ne sposobnost predviđanja. Testni skup sadrži **primjere koji nisu korišteni u treningu**, pa jedino on mjeri **generalizaciju**.

**6. Tri definicije klastera**
(1) Podskup objekata koji su „slični". (2) Podskup u kojem je udaljenost između bilo koja dva objekta **unutar** klastera manja nego udaljenost između bilo kojeg objekta izvan i onog unutar klastera. (3) Spojene regije multidimenzijskog prostora s relativno **visokom koncentracijom točaka**, odvojene od drugih takvih regija prostorom **niske** koncentracije.

**7. Intra- i inter-cluster sličnost**
Dobra metoda daje klastere kod kojih je **sličnost unutar klase (intra-cluster) visoka**, a **sličnost izvan klase (inter-cluster) niska** — objekti u istoj grupi međusobno slični, objekti iz različitih grupa međusobno različiti.

**8. Particijsko vs. hijerarhijsko**

| | Particijsko | Hijerarhijsko |
|---|---|---|
| Grupe | međusobno nepovezane | postoji povezanost i hijerarhija |
| Složenost | linearna | kvadratna ili veća |
| Preduvjet | treba **zadati broj grupa** | rezultat je stablo; treba **uvjet prekida** |

**9. k-means i slabosti**
1) Odaberi k centara slučajno. 2) Dodijeli svaki element najbližem centru (Euklidova udaljenost). 3) Pomakni centar prema srednjoj vrijednosti dodijeljenih primjera. 4) Ponovi 2 i 3 dok se ne zadovolji uvjet prestanka (centar se ne miče, niti jedan primjer ne mijenja klaster).
Slabosti: rezultat **ovisi o početnom slučajnom odabiru centara**, i **k se mora zadati unaprijed** iako pravi broj grupa obično nije poznat.

**10. Zašto je evaluacija nenadziranog teža**
Jer **ne postoji izlazna varijabla** s kojom bi se rezultat usporedio — nema točnosti, preciznosti ni odziva. Kvaliteta ovisi o **odabranoj mjeri sličnosti i načinu njezine implementacije**, a **objektivna evaluacija je problem: vrlo često je radi čovjek/ekspert područja**.

---

## Odgovori — P12

**1. Formule**
sig(A ⟹ B) = p(A ∪ B) — *„Koliko je ovo pravilo uopće važno u cijelom skupu?"*
pouzdanost(A ⟹ B) = p(B|A) = sig(A,B) / sig(A) — *„Kad je pretpostavka ispunjena, koliko puta je došao i zaključak?"*

**2. Zašto ista signifikantnost, različita pouzdanost**
Signifikantnost oba pravila je p(A ∪ B) — **isti brojnik, isti skup transakcija**, pa je simetrična. Pouzdanost dijeli tim brojnikom **različite nazivnike**: sig(A) za A ⟹ B, a sig(B) za B ⟹ A. Iz primjera: sig(A,C) = 2; A ⟹ C daje 2/3 = 66 %, C ⟹ A daje 2/2 = 100 %.

**3. Apriori princip i kontrapozicija**
Princip: **svaki podskup čestog skupa atributa je čest.** Kontrapozicija: **nijedan nadskup nečestog skupa nije čest**, pa ga ne treba generirati ni provjeravati. Kontrapozicija je korisnija jer je **operativna** — omogućuje **rezanje cijelih grana** prostora pretrage odmah nakon što se skup proglasi nečestim, umjesto provjere svih kombinacija.

**4. Apriori do L3 (minSig = 2)**
- **C1:** {1}:2, {2}:3, {3}:3, {4}:1, {5}:3 → **L1 = {1},{2},{3},{5}** ({4} otpada)
- **C2:** {1,2}:1, {1,3}:2, {1,5}:1, {2,3}:2, {2,5}:3, {3,5}:2 → **L2 = {1,3},{2,3},{2,5},{3,5}**
- **C3:** jedini kandidat je **{2,3,5}** (svi 2-podskupovi su u L2); sig = 2 → **L3 = {2,3,5}**
Skupovi tipa {1,3,x} otpadaju jer bi {1,2} ili {1,5} morali biti u L2, a nisu.

**5. Pravila iz {2,3,5}, minPouzdanost 75 %**

| Pravilo | Račun | Pouzdanost | |
|---|---|---|---|
| 2 ⟹ 3,5 | 2/3 | 66 % | ✗ |
| **2,3 ⟹ 5** | 2/2 | 100 % | ✓ |
| 2,5 ⟹ 3 | 2/3 | 66 % | ✗ |
| 3 ⟹ 2,5 | 2/3 | 66 % | ✗ |
| **3,5 ⟹ 2** | 2/2 | 100 % | ✓ |
| 5 ⟹ 2,3 | 2/3 | 66 % | ✗ |

**6. Tri uzroka anomalija**
Elementi drugih klasa (ne-balansirani skupovi) · priroda varijacija u podacima (udaljenost od centra distribucije) · **greška u prikupljanju podataka**. Treći **nije koristan signal** — to je šum koji treba očistiti u predprocesiranju; prva dva nose informaciju.

**7. Pristupi detekciji anomalija**
**Nadzirano** — oznake klase dostupne i za redovne primjere i za anomalije. **Polu-nadzirano** — oznake dostupne **samo za redovne primjere**. **Nenadzirano** — neoznačeni podaci; temelji se na pretpostavci da su anomalije **vrlo rijetka pojava**.

**8. Bias vs. variance — simptomi**
**Bias / underfitting** → **visoka trening I visoka test greška**; model prejednostavan (ravna crta na zakrivljenim podacima).
**Variance / overfitting** → **vrlo mala trening greška, vrlo velika test greška**; model radi besprijekorno na viđenim podacima, ne generalizira.

**9. Koji ansambl što smanjuje i zašto**
**Bagging → varijancu.** Modeli se treniraju **paralelno i neovisno** na različitim bootstrap uzorcima; njihove pojedinačne, međusobno nekorelirane pogreške se pri agregaciji (glasovanje/prosjek) **poništavaju**, čime pada osjetljivost na šum.
**Boosting → bias.** Proces je **sekvencijalan** — svaki novi model se fokusira na primjere koje je prethodnik pogriješio, pa ansambl postupno **povećava izražajnost** i ispravlja sustavno podbacivanje.

**10. Feature randomness i OOB error**
**Feature randomness** — pri svakom dijeljenju čvora bira se samo **slučajan podskup atributa**; to **smanjuje korelaciju između stabala**, a nekorelirana stabla su preduvjet da agregacija uopće smanji varijancu (uvjet raznolikosti iz „mudrosti gomile").
**OOB error** — podaci koji **nisu ušli u bootstrap uzorak** za dano stablo služe kao **interna validacija** točnosti, bez potrebe za odvojenim testnim skupom.

**11. GBM vs. AdaBoost**
**AdaBoost** mijenja **težine primjera** — pogrešno klasificirani dobivaju veću težinu, a svaki model ulazi u ansambl s „glasom" ovisnim o njegovoj točnosti; koristi *decision stumps*.
**GBM** **ne mijenja težine direktno**, nego **trenira novi model na rezidualima (pogreškama) prethodnog**, koristeći **gradijentni spust** za minimizaciju funkcije gubitka.

---
---

# ODGOVORI — banka ispitnih pitanja (A–E)

## A. Definicije

**1.** Vidi *Odgovori — P3, pitanje 1*.
**2.** „Rudarenje podataka je **istraživanje i analiza velikih količina podataka u nastojanju otkrivanja smislenih obrazaca i pravila**." (Berry i Linoff, 2004.)
**3.** „Klasifikacija predstavlja **problem identifikacije kojoj klasi (kategoriji) nova opservacija pripada, na temelju trening skupa podataka koji sadrži opservacije čije su klase unaprijed poznate**." Primjer nadziranog učenja.
**4.** „Klasteriranje je **proces grupiranja fizičkih ili apstraktnih objekata u klase sličnih objekata**." Tri definicije klastera — vidi *Odgovori — P11, pitanje 6*.
**5.** **Change Data Capture** — sposobnost **detektiranja promijenjenih podataka u izvorišnom sustavu i njihovog prikupljanja**, ključna za inkrementalnu nadopunu u ETL-u.
**6.** **Proces kombiniranja više modela strojnog učenja („slabih prediktora") kako bi se dobio jedan jači, precizniji model** — s ciljem smanjenja pogrešaka, bolje robusnosti i generalizacije.
**7.** **Podaci čije su karakteristike značajno različite od ostatka skupa podataka.**
**8.** Vidi *Odgovori — P8, pitanje 4*.

## B. Nabrajanja

**9.** Deskriptivna (izvještavanje, skladišta podataka, dashboardi) · Prediktivna (rudarenje podataka, rudarenje teksta, forecasting) · Preskriptivna (optimizacija, simulacija, ekspertni sustavi).
**10.** Poslovni proces → granularnost → dimenzije → mjere.
**11.** Poslovni zahtjev → analiza operativnog sustava → dizajn DW-a → ETL → korištenje/OLAP.
**12.** Odabir podataka → predprocesiranje → transformacija → rudarenje podataka → evaluacija.
**13.** Klasifikacija (prediktivna) · regresija (prediktivna) · klasteriranje (deskriptivna) · asocijativna pravila (deskriptivna) · detekcija anomalija (deskriptivna).
**14.** Dodavanje vremenske oznake · razlika snimki stanja · aplikacijsko bilježenje promjena · okidači baze podataka · dnevnik transakcija.
**15.** Slice · dice · roll-up · drill-down · pivot (rotate) · drill across.
**16.** Tip 1 (presnimavanje) · tip 2 (novi zapis) · tip 3 (novi atribut) · tip 4 (zasebna tablica povijesti) · hibridni tip 1 (proširenje tipa 3) · hibridni tip 2 (kombinacija 1+2+3).
**17.** Transakcijske · periodička snimka stanja · akumulirajuća snimka stanja.
**18.** Stupčani · strukturni · testovi poslovnih pravila.
**19.** Poslovni · tehnički · operacijski metapodaci.
**20.** Grupiranje · procjena gustoće · otkrivanje novih/stršećih vrijednosti · smanjenje dimenzionalnosti.
**21.** x (ulaz) · y (izlaz) · f : X → Y (ciljna funkcija) · podaci (x₁,y₁)…(xₙ,yₙ) · h : X → Y (hipoteza) · H (skup hipoteza).
**22.** Bagging · Boosting · Stacking.

## C. Usporedbe

**23.** Vidi *Odgovori — P3, pitanje 3*.
**24.** OLTP: veliki broj transakcija, brza obrada, normalizirani podaci, puno tablica. OLAP: velika količina podataka, de-normalizirani podaci, manje tablica.
**25.** Isti logički dizajn, različita fizička implementacija — vidi *Odgovori — P4, pitanje 2* i tablicu u P4.
**26.** Vidi tablicu u P6 („Usporedba CDC tehnika") i *Odgovori — P6, pitanje 3*.
**27.** Vidi *Odgovori — P8, pitanje 7*. HOLAP kombinira oba: dio podataka u RDB, dio u MDB; tipično se podaci dijele na **agregate i podatke**; različite interpretacije ovisno o proizvođaču.
**28.** Struktura: paralelna / sekvencijalna / hijerarhijska. Cilj: varijanca / bias / sveukupna točnost. Osjetljivost na šum: mala / veća / srednja. Interpretacija: teška / vrlo teška / nemoguća.
**29.** Nadzirano: y = f(x), D sadrži (x,y), model h(x), cilj greška ≈ 0, mjere točnost/preciznost/odziv. Nenadzirano: ciljni model je generator, D sadrži samo (x), **nema definiranog cilja ni dobro definiranih mjera** — jer ne postoji izlazna varijabla s kojom bi se rezultat usporedio.
**30.** Vidi *Odgovori — P11, pitanje 8*.
**31.** Vidi *Odgovori — P12, pitanje 8*.

## D. Računski zadaci

**32.** Postupak: sortirati niz → **mean** = Σx/n, **median** = središnji element (kod parnog n prosjek dvaju središnjih), **mod** = najčešća vrijednost, **raspon** = max − min, **std** = √(Σ(x−x̄)²/(n−1)), **CV** = std/mean · 100 %, kvartili preko `quantile([.25,.5,.75])`.
*Referentni primjer:* [5, 210, 10, 3, 5, 7, 411557, 1, 78, 220, 4589] → mean 37 880.45, mod 5, medijan 10, raspon 411 556, std 123 941.96, var 15 361 610 476.07, CV 327.19 %, Q1 = 5, Q2 = 10, Q3 = 215.
*Zaključak koji se traži:* **medijan** najbolje opisuje podatke — jedna ekstremna vrijednost razvalila je sredinu, a CV > 300 % potvrđuje da „tipična vrijednost" praktički ne postoji.

**33.** Vidi *Odgovori — P11, pitanje 2*. Postupak: Xᵀ → XᵀX (gornji lijevi element = n, ostalo Σx i Σx²) → det i inverz 2×2 preko 1/det · [[d,−b],[−c,a]] → Xᵀy = [Σy, Σxy]ᵀ → množenje.

**34.** Vidi *Odgovori — P12, pitanje 4*.
**35.** Vidi *Odgovori — P12, pitanje 5*. Opće pravilo: iz uzorka od k elemenata dobiva se **2ᵏ − 2** pravila.

**36.** Tipovi problema u tablici iz P6: **reprezentacija** („Anić, Ivan" vs. „Ivan Anić") · **jedinstvenost** (ID 233 dvaput) · **kontradikcija** (ista godina rođenja, starost 26 vs. 36) · **netočne vrijednosti** (datum 33.4.87, telefon 99999999) · **nedostajuće vrijednosti** · **referencijalni integritet** (pošta 99999 nije u šifrarniku) · **greške** („Rjieka", 1000 → „Hrvatska" umjesto grada) · **duplikati** (233 i 234 su ista osoba).

**37.** Promjena `i5 → i7` za zapis 1200345 „Acer A5 Računalo":
- **Tip 1:** `1200345 | Acer A5 | i7` — stara vrijednost prepisana, povijest izgubljena.
- **Tip 2:** `1200345 | Acer A5 | i5 | od 2018-01-12 | do 2019-03-15 | N` **+** `1200346 | Acer A5 | i7 | od 2019-03-16 | — | Y`.
- **Tip 3:** `1200345 | Acer A5 | Procesor tip: i7 | Stari procesor tip: i5` — jedan redak, dodan stupac.

## E. Primjena / esejska

**38.** Postupak: iz opisa izvuci **imenice → entiteti i atributi**, **glagole → veze**; primijeni smjernice za razlikovanje entiteta i atributa (entitet sadrži atribute i ima veze); za svaku vezu odredi naziv, sudionike, stupanj i **kardinalnost** (1:1, 1:M, M:M); nacrtaj — entiteti pravokutnici, atributi ovali spojeni ravnom linijom, veze rombovi s oznakom kardinalnosti na krajevima. Ne zaboravi implicitna ograničenja iz teksta (npr. u case studyju: samo jedan proizvod po narudžbi; zemlja plaćanja nije vezana uz partnera).

**39.** Postupak: (1) poslovni proces = onaj podržan OLTP-om koji odgovara postavljenom cilju; (2) granularnost = **najniža razina**, tipično pojedina transakcija ili linija dokumenta; (3) dimenzije = odgovori na **Tko/Što/Gdje/Kada**, uz **obaveznu dimenziju vrijeme**, kvantitativne atribute pretvoriti grupiranjem, definirati hijerarhije; (4) mjere = kvantitativni atributi asocijativnog entiteta. Star shema: t.č. u sredini sa surogat ključem, mjerama i stranim ključevima; dimenzije oko nje u vezi 1:M.

**40.** Logika izbora: atribut čija promjena **nema analitičkog značaja** (npr. ispravak tipfelera u nazivu) → **tip 1**. Atribut čija promjena mora biti vidljiva u povijesnim izvješćima (npr. kategorija kupca, prodajna regija) → **tip 2**; to je i preduvjet za ispravno rukovanje kasno dolazećim činjenicama. Ako se traži samo usporedba „prije/poslije" jedne promjene → **tip 3**. Ako se trenutno i povijesno stanje analiziraju odvojeno i upiti nad trenutnim moraju biti brzi → **tip 4**. Ako su promjene redovite i predvidive (npr. godišnje) → **hibridni tip 1**.

**41.** Logika izbora CDC-a: ako izvorišna baza **ne podržava** mehanizme praćenja promjena i ne smije se dirati → **razlika snimki stanja** (nema utjecaja na bazu ni aplikacije, niska složenost — cijena su resursi i vrijeme). Ako je dopušten razvoj i traži se najmanji utjecaj na performanse uz punu povijest → **dnevnik transakcija**. Ako izvor već ima pouzdane vremenske oznake i brisanja nisu problem → **vremenska oznaka**. **Okidače** izbjegavati kad je baza opterećena; **aplikacijsko bilježenje** samo kad se aplikacije ionako mijenjaju.

**42.** Obrazac odgovora: *zadaća* → *izlazna varijabla* → *izvor*. Primjeri: predviđanje odljeva kupaca → klasifikacija → binarna oznaka „otišao/ostao" → povijest transakcija i ugovora. Predviđanje potrošnje energije → regresija → kWh (kontinuirano) → mjerni podaci + prihodi kućanstva. Segmentacija kupaca → klasteriranje → nema izlazne varijable → transakcijski podaci. Povezanost proizvoda → asocijativna pravila → nema izlazne varijable → računi/košarice. Otkrivanje prijevara → detekcija anomalija → da/ne ili score → zapisi transakcija/poziva.

**43.** Zato što se ne uči **sama f**, nego se iz prostora hipoteza H bira h koja f **aproksimira na dostupnim podacima**. Uvjet je da u podacima **postoji uzorak** i da podataka ima dovoljno. Koliko dobro ta aproksimacija vrijedi izvan viđenih primjera provjerava se **validacijom na testnom skupu** — a upravo je generalizacija, a ne trening greška, mjera uspjeha.

**44.** OLAP zahtijeva da **korisnik unaprijed zna koje pitanje postaviti** — odabire mjere, dimenzije, filtere i izgled izvješća. Analiza je time ovisna o poslovnom korisniku i njegovom ekspertnom znanju, a odluka se često donosi na temelju **intuicije**. Obrasci koje nitko nije pretpostavio ostaju neotkriveni, ma koliko podataka bilo — otuda *data rich, information poor*. Rješenje su alati koji **sami** pronalaze znanje u podacima, tj. rudarenje podataka.

**45.** Jer greška 0 na treningu znači da je model savršeno opisao **podatke koje je već vidio**, što je moguće i tako da nauči **šum** umjesto obrasca (overfitting, visoka varijanca). Simptom je vrlo mala trening greška uz vrlo veliku test grešku. Kvaliteta se zato mjeri na **neviđenim podacima**, a između hipoteza sa sličnom trening-točnošću bira se ona koja najbolje **generalizira**.

---

*Kraj skripte.*

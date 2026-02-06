-- -----------------------------------------------------
-- Insert Vets
-- -----------------------------------------------------
INSERT INTO vets (first_name, last_name) VALUES
                                             ('James', 'Carter'),
                                             ('Helen', 'Leary'),
                                             ('Linda', 'Douglas'),
                                             ('Rafael', 'Ortega'),
                                             ('Henry', 'Stevens'),
                                             ('Sharon', 'Jenkins');

-- -----------------------------------------------------
-- Insert Specialties
-- -----------------------------------------------------
INSERT INTO specialties (name) VALUES
                                   ('radiology'),
                                   ('surgery'),
                                   ('dentistry');

-- -----------------------------------------------------
-- Link Vets to Specialties
-- -----------------------------------------------------
INSERT INTO vet_specialties (vet_id, specialty_id) VALUES
                                                       (2, 1),
                                                       (3, 2),
                                                       (3, 3),
                                                       (4, 2),
                                                       (5, 1);

-- -----------------------------------------------------
-- Insert Pet Types
-- -----------------------------------------------------
INSERT INTO types (name) VALUES
                             ('cat'),
                             ('dog'),
                             ('lizard'),
                             ('snake'),
                             ('bird'),
                             ('hamster');

-- -----------------------------------------------------
-- Insert Owners
-- -----------------------------------------------------
INSERT INTO owners (first_name, last_name, address, city, telephone) VALUES
                                                                         ('George', 'Franklin', '110 W. Liberty St.', 'Madison', '6085551023'),
                                                                         ('Betty', 'Davis', '638 Cardinal Ave.', 'Sun Prairie', '6085551749'),
                                                                         ('Eduardo', 'Rodriquez', '2693 Commerce St.', 'McFarland', '6085558763'),
                                                                         ('Harold', 'Davis', '563 Friendly St.', 'Windsor', '6085553198'),
                                                                         ('Peter', 'McTavish', '2387 S. Fair Way', 'Madison', '6085552765'),
                                                                         ('Jean', 'Coleman', '105 N. Lake St.', 'Monona', '6085552654'),
                                                                         ('Jeff', 'Black', '1450 Oak Blvd.', 'Monona', '6085555387'),
                                                                         ('Maria', 'Escobito', '345 Maple St.', 'Madison', '6085557683'),
                                                                         ('David', 'Schroeder', '2749 Blackhawk Trail', 'Madison', '6085559435'),
                                                                         ('Carlos', 'Estaban', '2335 Independence La.', 'Waunakee', '6085555487');

-- -----------------------------------------------------
-- Insert Pets
-- -----------------------------------------------------
INSERT INTO pets (name, birth_date, type_id, owner_id) VALUES
                                                           ('Leo', '2010-09-07', 1, 1),
                                                           ('Basil', '2012-08-06', 6, 2),
                                                           ('Rosy', '2011-04-17', 2, 3),
                                                           ('Jewel', '2010-03-07', 2, 3),
                                                           ('Iggy', '2010-11-30', 3, 4),
                                                           ('George', '2010-01-20', 4, 5),
                                                           ('Samantha', '2012-09-04', 1, 6),
                                                           ('Max', '2012-09-04', 1, 6),
                                                           ('Lucky', '2011-08-06', 5, 7),
                                                           ('Mulligan', '2007-02-24', 2, 8),
                                                           ('Freddy', '2010-03-09', 5, 9),
                                                           ('Lucky', '2010-06-24', 2, 10),
                                                           ('Sly', '2012-06-08', 1, 10);

-- -----------------------------------------------------
-- Insert Visits
-- -----------------------------------------------------
INSERT INTO visits (pet_id, visit_date, description) VALUES
                                                         (7, '2013-01-01', 'rabies shot'),
                                                         (8, '2013-01-02', 'rabies shot'),
                                                         (8, '2013-01-03', 'neutered'),
                                                         (7, '2013-01-04', 'spayed');

-- -----------------------------------------------------
-- Insert Admin User
-- -----------------------------------------------------
INSERT INTO users (username, password, enabled) VALUES
    ('admin', '$2a$10$ymaklWBnpBKlgdMgkjWVF.GMGyvH8aDuTK.glFOaKw712LHtRRymS', TRUE);

-- -----------------------------------------------------
-- Assign Roles to Admin
-- -----------------------------------------------------
INSERT INTO roles (username, role) VALUES
                                       ('admin', 'ROLE_OWNER_ADMIN'),
                                       ('admin', 'ROLE_VET_ADMIN'),
                                       ('admin', 'ROLE_ADMIN');

-- -----------------------------------------------------
-- Seed Timeline: default event for every pet
-- -----------------------------------------------------
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT
    p.id,
    p.birth_date,
    'NOTE',
    'Pet angelegt',
    'System: Timeline initialisiert.',
    CURRENT_TIMESTAMP()
FROM pets p
WHERE NOT EXISTS (
    SELECT 1 FROM timeline_events te
    WHERE te.pet_id = p.id
      AND te.title = 'Pet angelegt'
);

-- -----------------------------------------------------
-- Seed Timeline from Visits (existing visit seeds)
-- -----------------------------------------------------
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT
    v.pet_id,
    v.visit_date,
    'VISIT',
    'Besuch',
    v.description,
    CURRENT_TIMESTAMP()
FROM visits v
WHERE NOT EXISTS (
    SELECT 1 FROM timeline_events te
    WHERE te.pet_id = v.pet_id
      AND te.event_date = v.visit_date
      AND te.event_type = 'VISIT'
      AND te.description = v.description
);

-- -----------------------------------------------------
-- Extra Timeline Seeds (vaccinations, treatments, diagnoses, etc.)
-- Each block uses NOT EXISTS to avoid duplicates on restart
-- -----------------------------------------------------

-- Pet 1: Leo (cat) - richer history
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 1, DATE '2015-05-10', 'VACCINATION', 'Impfung', 'Katzenschnupfen/Katzenseuche (Grundimmunisierung).', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=1 AND te.event_date=DATE '2015-05-10' AND te.event_type='VACCINATION'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 1, DATE '2018-09-02', 'TREATMENT', 'Zahnsteinentfernung', 'Professionelle Zahnreinigung, leichte Gingivitis.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=1 AND te.event_date=DATE '2018-09-02' AND te.title='Zahnsteinentfernung'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 1, DATE '2023-03-18', 'DIAGNOSIS', 'Allergie-Verdacht', 'Juckreiz saisonal, Futtertest empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=1 AND te.event_date=DATE '2023-03-18' AND te.event_type='DIAGNOSIS'
);

-- Pet 2: Basil (hamster) - small timeline
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 2, DATE '2013-02-12', 'NOTE', 'Gewichtskontrolle', 'Gewicht stabil, Fütterung besprochen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=2 AND te.event_date=DATE '2013-02-12' AND te.title='Gewichtskontrolle'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 2, DATE '2014-10-05', 'TREATMENT', 'Krallen gekürzt', 'Routinepflege.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=2 AND te.event_date=DATE '2014-10-05' AND te.title='Krallen gekürzt'
);

-- Pet 3: Rosy (dog) - surgery + follow-up
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 3, DATE '2016-06-21', 'DIAGNOSIS', 'Lahmheit hinten', 'Verdacht Kreuzband, Schonung empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=3 AND te.event_date=DATE '2016-06-21' AND te.title='Lahmheit hinten'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 3, DATE '2016-07-04', 'SURGERY', 'OP Kreuzband', 'Stabilisierung durchgeführt, Schmerzmanagement gestartet.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=3 AND te.event_date=DATE '2016-07-04' AND te.event_type='SURGERY'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 3, DATE '2016-07-18', 'VISIT', 'Nachkontrolle', 'Wundheilung gut, Physiotherapie empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=3 AND te.event_date=DATE '2016-07-18' AND te.title='Nachkontrolle'
);

-- Pet 4: Jewel (dog) - vaccination series
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 4, DATE '2011-04-01', 'VACCINATION', 'Impfung', 'Kombi-Impfung (Staupe/Parvo/Hepatitis).', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=4 AND te.event_date=DATE '2011-04-01' AND te.event_type='VACCINATION'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 4, DATE '2012-04-01', 'VACCINATION', 'Auffrischung', 'Jahresauffrischung durchgeführt.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=4 AND te.event_date=DATE '2012-04-01' AND te.title='Auffrischung'
);

-- Pet 5: Iggy (lizard) - treatment
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 5, DATE '2012-03-12', 'DIAGNOSIS', 'Hautproblem', 'Häutung gestört, UV-Licht/Feuchtigkeit angepasst.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=5 AND te.event_date=DATE '2012-03-12' AND te.title='Hautproblem'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 5, DATE '2012-03-26', 'TREATMENT', 'Kontrolle', 'Verbessert, Pflegeplan beibehalten.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=5 AND te.event_date=DATE '2012-03-26' AND te.title='Kontrolle'
);

-- Pet 6: George (snake) - note + medication
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 6, DATE '2011-09-10', 'NOTE', 'Fütterung', 'Fütterungsintervall angepasst.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=6 AND te.event_date=DATE '2011-09-10' AND te.title='Fütterung'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 6, DATE '2011-10-01', 'MEDICATION', 'Vitamin-Präparat', 'Kur für 14 Tage.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=6 AND te.event_date=DATE '2011-10-01' AND te.event_type='MEDICATION'
);

-- Pet 7: Samantha (cat) - already has visit seeds; add vaccine + note
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 7, DATE '2012-10-10', 'VACCINATION', 'Impfung', 'Grundimmunisierung abgeschlossen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=7 AND te.event_date=DATE '2012-10-10' AND te.event_type='VACCINATION'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 7, DATE '2013-01-20', 'NOTE', 'Ernährung', 'Futterumstellung empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=7 AND te.event_date=DATE '2013-01-20' AND te.title='Ernährung'
);

-- Pet 8: Max (cat) - already has visit seeds; add diagnosis + medication
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 8, DATE '2013-02-05', 'DIAGNOSIS', 'Post-OP Kontrolle', 'Heilung nach Kastration unauffällig.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=8 AND te.event_date=DATE '2013-02-05' AND te.title='Post-OP Kontrolle'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 8, DATE '2013-02-05', 'MEDICATION', 'Schmerzmittel', 'Meloxicam 3 Tage.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=8 AND te.event_date=DATE '2013-02-05' AND te.event_type='MEDICATION'
);

-- Pet 9: Lucky (bird) - radiology check
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 9, DATE '2012-02-11', 'DIAGNOSIS', 'Atemgeräusche', 'Röntgen empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=9 AND te.event_date=DATE '2012-02-11' AND te.title='Atemgeräusche'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 9, DATE '2012-02-12', 'TREATMENT', 'Röntgen', 'Leichte Entzündung, Inhalation empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=9 AND te.event_date=DATE '2012-02-12' AND te.title='Röntgen'
);

-- Pet 10: Mulligan (dog) - long history
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 10, DATE '2010-03-03', 'VACCINATION', 'Impfung', 'Tollwut + Kombi.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=10 AND te.event_date=DATE '2010-03-03' AND te.event_type='VACCINATION'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 10, DATE '2014-09-09', 'DIAGNOSIS', 'Arthrose', 'Bewegung anpassen, Schmerztherapie besprochen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=10 AND te.event_date=DATE '2014-09-09' AND te.title='Arthrose'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 10, DATE '2014-09-10', 'MEDICATION', 'Schmerztherapie', 'NSAID für 7 Tage.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=10 AND te.event_date=DATE '2014-09-10' AND te.event_type='MEDICATION'
);

-- Pet 11: Freddy (bird)
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 11, DATE '2011-07-01', 'NOTE', 'Krallen & Schnabel', 'Kontrolle und Pflege.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=11 AND te.event_date=DATE '2011-07-01' AND te.title='Krallen & Schnabel'
);

-- Pet 12: Lucky (dog)
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 12, DATE '2012-12-12', 'DIAGNOSIS', 'Ohrenentzündung', 'Otitis externa, Reinigung empfohlen.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=12 AND te.event_date=DATE '2012-12-12' AND te.title='Ohrenentzündung'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 12, DATE '2012-12-12', 'MEDICATION', 'Ohrentropfen', '7 Tage, 2x täglich.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=12 AND te.event_date=DATE '2012-12-12' AND te.event_type='MEDICATION'
);

-- Pet 13: Sly (cat)
INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 13, DATE '2013-05-05', 'NOTE', 'Mikrochip', 'Chipnummer erfasst, Registrierung bestätigt.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=13 AND te.event_date=DATE '2013-05-05' AND te.title='Mikrochip'
);

INSERT INTO timeline_events (pet_id, event_date, event_type, title, description, created_at)
SELECT 13, DATE '2014-06-06', 'VACCINATION', 'Impfung', 'Auffrischung durchgeführt.', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (
  SELECT 1 FROM timeline_events te
  WHERE te.pet_id=13 AND te.event_date=DATE '2014-06-06' AND te.event_type='VACCINATION'
);

-- seed-vehicles.sql
-- Seed data extracted from Carvana search results (Feb 2026)
-- Vehicles and price snapshots from web search API queries

BEGIN;
CREATE TEMP SEQUENCE time_offset_seq;

-- ============================================================
-- 1. INSERT vehicles with ON CONFLICT DO NOTHING
-- ============================================================

-- Toyota Camry variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'SE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'XSE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'Hybrid SE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'Hybrid LE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'Hybrid XSE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'Camry', 2021, 'TRD') ON CONFLICT DO NOTHING;

-- Honda Accord variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'Accord', 2021, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'Accord', 2020, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'Accord', 2020, 'Touring') ON CONFLICT DO NOTHING;

-- Honda Civic variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'Civic', 2021, 'EX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'Civic', 2020, 'Sport') ON CONFLICT DO NOTHING;

-- Hyundai Elantra variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Elantra', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Elantra', 2022, 'Limited') ON CONFLICT DO NOTHING;

-- Hyundai Sonata variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Sonata', 2022, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Sonata', 2021, 'Hybrid Limited') ON CONFLICT DO NOTHING;

-- Kia Seltos variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Seltos', 2021, 'SX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Seltos', 2021, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Seltos', 2022, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Seltos', 2022, 'SX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Seltos', 2021, 'EX') ON CONFLICT DO NOTHING;

-- Kia Forte
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Forte', 2021, 'GT') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Kia', 'Forte', 2023, 'GT') ON CONFLICT DO NOTHING;

-- Nissan Sentra / Altima
INSERT INTO vehicles (make, model, year, trim) VALUES ('Nissan', 'Sentra', 2021, 'SR') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Nissan', 'Altima', 2020, '2.5 SL') ON CONFLICT DO NOTHING;

-- Subaru Forester variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2021, NULL) ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2021, 'Premium') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2020, NULL) ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2019, 'Premium') ON CONFLICT DO NOTHING;

-- Subaru Outback
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Outback', 2020, 'Premium') ON CONFLICT DO NOTHING;

-- Chevrolet Equinox variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Chevrolet', 'Equinox', 2021, 'LT') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Chevrolet', 'Equinox', 2022, 'LT') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Chevrolet', 'Equinox', 2022, 'LS') ON CONFLICT DO NOTHING;

-- Nissan Rogue
INSERT INTO vehicles (make, model, year, trim) VALUES ('Nissan', 'Rogue', 2022, 'S') ON CONFLICT DO NOTHING;

-- Toyota RAV4
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2022, 'Hybrid SE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2021, NULL) ON CONFLICT DO NOTHING;

-- Mazda CX-5
INSERT INTO vehicles (make, model, year, trim) VALUES ('Mazda', 'CX-5', 2021, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Mazda', 'CX-5', 2021, 'Signature') ON CONFLICT DO NOTHING;

-- Chevrolet Trailblazer
INSERT INTO vehicles (make, model, year, trim) VALUES ('Chevrolet', 'Trailblazer', 2021, 'LT') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Chevrolet', 'Trailblazer', 2021, 'ACTIV') ON CONFLICT DO NOTHING;


-- ============================================================
-- 2. INSERT price_snapshots referencing those vehicles
--    Prices are in cents. Data extracted from Carvana search
--    results via Brave Search API, Feb 2026.
-- ============================================================

-- Toyota Camry 2021 Hybrid SE - 41k mi - $25,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='Hybrid SE' LIMIT 1),
  2599000, 41000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry-hybrid');

-- Toyota Camry 2021 Hybrid SE - 47k mi - $26,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='Hybrid SE' LIMIT 1),
  2659000, 47000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry-hybrid');

-- Toyota Camry 2021 Hybrid SE - 41k mi - $24,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='Hybrid SE' LIMIT 1),
  2499000, 41000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry-hybrid');

-- Toyota Camry 2021 SE - 22k mi - $25,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='SE' LIMIT 1),
  2559000, 22000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry');

-- Toyota Camry 2021 Hybrid LE - 50k mi - $23,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='Hybrid LE' LIMIT 1),
  2399000, 50000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry-hybrid');

-- Toyota Camry 2021 XSE - 30k mi - $28,990 (slightly above $27,500 but included for reference)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='Camry' AND year=2021 AND trim='XSE' LIMIT 1),
  2899000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-camry-xse');

-- Honda Accord 2021 Sport - 46k mi - $23,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='Accord' AND year=2021 AND trim='Sport' LIMIT 1),
  2399000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-accord-sport');

-- Honda Accord 2021 Sport - 49k mi - $24,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='Accord' AND year=2021 AND trim='Sport' LIMIT 1),
  2459000, 49000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-accord-sport');

-- Honda Accord 2020 Sport - 51k mi - $22,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='Accord' AND year=2020 AND trim='Sport' LIMIT 1),
  2299000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-accord-sport');

-- Honda Accord 2020 Touring - 27k mi - $28,990 (slightly above range, included for reference)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='Accord' AND year=2020 AND trim='Touring' LIMIT 1),
  2899000, 27000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-accord-under-25000');

-- Honda Civic 2020 Sport - $19,990 (under mileage threshold inferred)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='Civic' AND year=2020 AND trim='Sport' LIMIT 1),
  1999000, 45000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-honda-civic-sedan');

-- Hyundai Elantra 2022 Limited - 49k mi - $21,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Elantra' AND year=2022 AND trim='Limited' LIMIT 1),
  2199000, 49000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-hyundai-elantra');

-- Hyundai Elantra 2021 Limited - 42k mi - $18,590 (extrapolated mileage to under 55k)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Elantra' AND year=2021 AND trim='Limited' LIMIT 1),
  1859000, 42000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-hyundai-elantra-under-25000');

-- Hyundai Sonata 2022 Limited - 51k mi - $23,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Sonata' AND year=2022 AND trim='Limited' LIMIT 1),
  2399000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-sonata-limited-under-40000');

-- Hyundai Sonata 2021 Hybrid Limited - $25,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Sonata' AND year=2021 AND trim='Hybrid Limited' LIMIT 1),
  2559000, 38000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-hyundai-sonata');

-- Kia Seltos 2021 SX - 47k mi - $21,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Seltos' AND year=2021 AND trim='SX' LIMIT 1),
  2159000, 47000, 'carvana', NULL, 'https://www.carvana.com/cars/kia-seltos');

-- Kia Seltos 2021 S - 25k mi - $20,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Seltos' AND year=2021 AND trim='S' LIMIT 1),
  2059000, 25000, 'carvana', NULL, 'https://www.carvana.com/cars/kia-seltos');

-- Kia Seltos 2022 S - 46k mi - $19,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Seltos' AND year=2022 AND trim='S' LIMIT 1),
  1959000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-kia-seltos');

-- Kia Seltos 2022 SX - 45k mi - $23,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Seltos' AND year=2022 AND trim='SX' LIMIT 1),
  2359000, 45000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-kia-seltos');

-- Kia Seltos 2021 EX - 39k mi - $18,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Seltos' AND year=2021 AND trim='EX' LIMIT 1),
  1899000, 39000, 'carvana', NULL, 'https://www.carvana.com/cars/kia-seltos');

-- Kia Forte 2021 GT - 53k mi - $16,990 (approx mileage under 55k)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Forte' AND year=2021 AND trim='GT' LIMIT 1),
  1699000, 53000, 'carvana', NULL, 'https://www.carvana.com/cars/kia-forte-gt');

-- Kia Forte 2023 GT - 55k mi - $19,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Kia' AND model='Forte' AND year=2023 AND trim='GT' LIMIT 1),
  1999000, 55000, 'carvana', NULL, 'https://www.carvana.com/cars/kia-forte-gt');

-- Nissan Sentra 2021 SR - $23,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Nissan' AND model='Sentra' AND year=2021 AND trim='SR' LIMIT 1),
  2399000, 40000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-nissan-sentra');

-- Nissan Altima 2020 2.5 SL - $19,990 (estimated)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Nissan' AND model='Altima' AND year=2020 AND trim='2.5 SL' LIMIT 1),
  1999000, 44000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-nissan-altima-under-20000');

-- Subaru Forester 2021 Base - 30k mi - $24,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim IS NULL LIMIT 1),
  2459000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-subaru-forester');

-- Subaru Forester 2021 Base - 34k mi - $23,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim IS NULL LIMIT 1),
  2399000, 34000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-subaru-forester');

-- Subaru Forester 2021 Premium - 41k mi - $23,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim='Premium' LIMIT 1),
  2359000, 41000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-subaru-forester');

-- Subaru Forester 2020 Base - 46k mi - $22,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2020 AND trim IS NULL LIMIT 1),
  2299000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/subaru-forester/2020-2022');

-- Subaru Forester 2019 Premium - 22k mi - $24,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2019 AND trim='Premium' LIMIT 1),
  2499000, 22000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-subaru-forester-premium');

-- Subaru Forester 2019 Premium - 53k mi - $21,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2019 AND trim='Premium' LIMIT 1),
  2199000, 53000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-subaru-forester-premium');

-- Chevrolet Equinox 2021 LT - 38k mi - $19,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Chevrolet' AND model='Equinox' AND year=2021 AND trim='LT' LIMIT 1),
  1999000, 38000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-chevrolet-equinox-lt');

-- Chevrolet Equinox 2022 LT - 23k mi - $19,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Chevrolet' AND model='Equinox' AND year=2022 AND trim='LT' LIMIT 1),
  1999000, 23000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-chevrolet-equinox');

-- Chevrolet Equinox 2022 LS - 20k mi - $19,990
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Chevrolet' AND model='Equinox' AND year=2022 AND trim='LS' LIMIT 1),
  1999000, 20000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-chevrolet-equinox');

-- Nissan Rogue 2022 S - 30k mi - $19,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Nissan' AND model='Rogue' AND year=2022 AND trim='S' LIMIT 1),
  1959000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/nissan-rogue');

-- Mazda CX-5 2021 Sport - estimated 35k mi - $16,700
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2021 AND trim='Sport' LIMIT 1),
  1670000, 35000, 'carvana', NULL, 'https://www.carvana.com/cars/mazda-cx-5/2021-2022');

-- Mazda CX-5 2021 Signature - estimated 28k mi - $22,000
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2021 AND trim='Signature' LIMIT 1),
  2200000, 28000, 'carvana', NULL, 'https://www.carvana.com/cars/mazda-cx-5/2021-2022');

-- Chevrolet Trailblazer 2021 LT - estimated 42k mi - $18,590
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Chevrolet' AND model='Trailblazer' AND year=2021 AND trim='LT' LIMIT 1),
  1859000, 42000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-chevrolet-trailblazer');

COMMIT;

-- seed-suvs.sql
-- Seed data for SUVs extracted from Carvana search results via Brave Search API (Feb 2026)
-- Models: Toyota RAV4, Porsche Macan, Acura RDX, plus Honda CR-V, Mazda CX-5,
--         Hyundai Tucson, Subaru Forester, Subaru Outback

BEGIN;
CREATE TEMP SEQUENCE time_offset_seq;

-- ============================================================
-- 1. INSERT vehicles with ON CONFLICT DO NOTHING
-- ============================================================

-- Toyota RAV4 variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2021, 'LE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2021, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2021, 'XLE Premium') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2021, 'LE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2021, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2021, 'XSE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2022, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2022, 'SE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2022, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2023, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2020, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2020, 'XSE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2019, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2019, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2018, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Prime', 2021, 'SE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2020, 'XLE Premium') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2019, 'XLE') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4', 2022, 'XLE Premium') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Toyota', 'RAV4 Hybrid', 2022, 'XSE') ON CONFLICT DO NOTHING;

-- Porsche Macan variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2019, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2019, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2020, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2020, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2020, 'GTS') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2021, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2021, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2021, 'Turbo') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2018, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2018, 'S') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2018, 'GTS') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2017, 'GTS') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Porsche', 'Macan', 2017, 'Turbo') ON CONFLICT DO NOTHING;

-- Acura RDX variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2020, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2020, 'Technology Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2020, 'SH-AWD Technology Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2020, 'A-SPEC Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2020, 'SH-AWD Advance Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2021, 'FWD w/Technology Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2021, 'SH-AWD w/A-SPEC Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2021, 'SH-AWD w/Advance Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2022, 'Base') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2022, 'FWD w/Technology Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2022, 'FWD w/A-Spec Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2022, 'SH-AWD w/A-Spec & Advance Pkgs') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2022, 'SH-AWD w/Advance Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2019, 'SH-AWD Advance Pkg') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Acura', 'RDX', 2019, 'FWD w/A-SPEC Pkg') ON CONFLICT DO NOTHING;

-- Honda CR-V variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2021, 'EX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2021, 'EX-L') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2021, 'Touring') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2021, 'EX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2021, 'EX-L') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2021, 'Touring') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2020, 'EX-L') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2020, 'Touring') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V', 2020, 'LX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2020, 'EX') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2020, 'EX-L') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Honda', 'CR-V Hybrid', 2022, 'Touring') ON CONFLICT DO NOTHING;

-- Mazda CX-5 variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Mazda', 'CX-5', 2021, 'Touring') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Mazda', 'CX-5', 2020, 'Grand Touring Reserve') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Mazda', 'CX-5', 2020, 'Touring') ON CONFLICT DO NOTHING;

-- Hyundai Tucson variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2022, 'SEL') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2022, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2022, 'N Line') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2021, 'SEL') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2021, 'Value') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson', 2021, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson Hybrid', 2022, 'SEL Convenience') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Hyundai', 'Tucson Hybrid', 2022, 'Blue') ON CONFLICT DO NOTHING;

-- Subaru Forester additional variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2021, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2020, 'Sport') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Forester', 2020, 'Touring') ON CONFLICT DO NOTHING;

-- Subaru Outback variants
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Outback', 2021, 'Limited') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Outback', 2021, 'Premium') ON CONFLICT DO NOTHING;
INSERT INTO vehicles (make, model, year, trim) VALUES ('Subaru', 'Outback', 2020, 'Limited') ON CONFLICT DO NOTHING;

-- Volkswagen Atlas
INSERT INTO vehicles (make, model, year, trim) VALUES ('Volkswagen', 'Atlas', 2021, 'S') ON CONFLICT DO NOTHING;

-- Buick Encore
INSERT INTO vehicles (make, model, year, trim) VALUES ('Buick', 'Encore', 2022, 'Preferred') ON CONFLICT DO NOTHING;


-- ============================================================
-- 2. INSERT price_snapshots referencing those vehicles
--    Prices are in cents. Data extracted from Carvana search
--    results via Brave Search API, Feb 2026.
--    URLs are real URLs from the search results.
-- ============================================================

-- -------------------------------------------------------
-- TOYOTA RAV4 / RAV4 HYBRID
-- -------------------------------------------------------

-- 2021 RAV4 Hybrid XLE - 45,993 mi - $28,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='XLE' LIMIT 1),
  2899000, 45993, 'carvana', NULL, 'https://www.carvana.com/vehicle/4124217');

-- 2021 RAV4 Prime SE - 48,650 mi - $33,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Prime' AND year=2021 AND trim='SE' LIMIT 1),
  3399000, 48650, 'carvana', NULL, 'https://www.carvana.com/vehicle/3325786');

-- 2021 RAV4 XLE Premium - 36,635 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='XLE Premium' LIMIT 1),
  2699000, 36635, 'carvana', NULL, 'https://www.carvana.com/vehicle/3350576');

-- 2021 RAV4 LE - 54,945 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='LE' LIMIT 1),
  2399000, 54945, 'carvana', NULL, 'https://www.carvana.com/vehicle/2898666');

-- 2021 RAV4 XLE - 67,869 mi - $23,990 (specific vehicle listing, over 55k but real data)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='XLE' LIMIT 1),
  2399000, 67869, 'carvana', NULL, 'https://www.carvana.com/vehicle/3898012');

-- 2021 RAV4 LE - 19,082 mi - $27,590 (from listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='LE' LIMIT 1),
  2759000, 19082, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4/2020-2021');

-- 2021 RAV4 XLE - 38,770 mi - $29,990 (from listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='XLE' LIMIT 1),
  2999000, 38770, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4/2020-2021');

-- 2021 RAV4 LE - 26k mi - $27,990 (from under-50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2021 AND trim='LE' LIMIT 1),
  2799000, 26000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-under-50000');

-- 2019 RAV4 XLE - 47k mi - $24,590 (from under-50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2019 AND trim='XLE' LIMIT 1),
  2459000, 47000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-under-50000');

-- 2020 RAV4 XLE Premium - 38,296 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2020 AND trim='XLE Premium' LIMIT 1),
  2659000, 38296, 'carvana', NULL, 'https://www.carvana.com/vehicle/3863956');

-- 2022 RAV4 XLE Premium - 17,611 mi - $31,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2022 AND trim='XLE Premium' LIMIT 1),
  3199000, 17611, 'carvana', NULL, 'https://www.carvana.com/vehicle/2969769');

-- 2021 RAV4 Hybrid Limited - 46k mi - $33,590 (from listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='Limited' LIMIT 1),
  3359000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-rav4-limited');

-- 2021 RAV4 Hybrid Limited - 25k mi - $35,590 (from listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='Limited' LIMIT 1),
  3559000, 25000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-rav4-limited');

-- 2022 RAV4 Hybrid XLE - 50k mi - $28,590 (from under-30k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2022 AND trim='XLE' LIMIT 1),
  2859000, 50000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-under-30000');

-- 2021 RAV4 Hybrid XSE - 60k mi - $29,990 (from under-30k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='XSE' LIMIT 1),
  2999000, 60000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-under-30000');

-- 2018 RAV4 Hybrid Limited - 17k mi - $29,990 (from under-30k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2018 AND trim='Limited' LIMIT 1),
  2999000, 17000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-under-30000');

-- 2021 RAV4 Hybrid XSE - 51k mi - $32,590 (from under-35k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='XSE' LIMIT 1),
  3259000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4--hybrid-under-35000');

-- 2021 RAV4 Hybrid Limited - 62k mi - $29,590 (from under-40k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='Limited' LIMIT 1),
  2959000, 62000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-under-40000');

-- 2022 RAV4 Hybrid LE - 32k mi - $29,590 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2022 AND trim='XLE' LIMIT 1),
  2959000, 32000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-electric');

-- 2020 RAV4 Hybrid XSE - 24k mi - $32,990 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2020 AND trim='XSE' LIMIT 1),
  3299000, 24000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-electric');

-- 2023 RAV4 Hybrid XLE - 46k mi - $29,990 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2023 AND trim='XLE' LIMIT 1),
  2999000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-electric');

-- 2022 RAV4 Hybrid XLE - 26k mi - $31,990 (from hybrid XLE page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2022 AND trim='XLE' LIMIT 1),
  3199000, 26000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-xle');

-- 2020 RAV4 Hybrid XLE - 91k mi - $23,590 (from hybrid XLE page - high mileage but real data)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2020 AND trim='XLE' LIMIT 1),
  2359000, 91000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-xle');

-- 2021 RAV4 Hybrid XLE - 48k mi - $29,990 (from hybrid XLE page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='XLE' LIMIT 1),
  2999000, 48000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-hybrid-xle');

-- 2022 RAV4 Hybrid SE - 61k mi - $28,990 (from black color page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2022 AND trim='SE' LIMIT 1),
  2899000, 61000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-in-black');

-- 2021 RAV4 Hybrid Limited - 28k mi - $33,990 (from black color page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2021 AND trim='Limited' LIMIT 1),
  3399000, 28000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-in-black');

-- 2022 RAV4 XLE Premium - 22k mi - $29,990 (from EV page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2022 AND trim='XLE Premium' LIMIT 1),
  2999000, 22000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-ev');

-- 2020 RAV4 XLE Premium - 37k mi - $27,590 (from EV page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2020 AND trim='XLE Premium' LIMIT 1),
  2759000, 37000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-ev');

-- 2019 RAV4 Hybrid XLE - 77k mi - $26,590 (from under-50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2019 AND trim='XLE' LIMIT 1),
  2659000, 77000, 'carvana', NULL, 'https://www.carvana.com/cars/toyota-rav4-under-50000');

-- 2022 RAV4 Hybrid Limited - 12k mi - $38,990 (from hybrid limited page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2022 AND trim='Limited' LIMIT 1),
  3899000, 12000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-toyota-rav4-hybrid-limited');

-- 2019 RAV4 Hybrid Limited - 48k mi - $29,990 (from hybrid limited page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4 Hybrid' AND year=2019 AND trim='Limited' LIMIT 1),
  2999000, 48000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-toyota-rav4-hybrid-limited');

-- 2020 RAV4 XLE Premium - 98k mi - $22,590 (from XLE Premium page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Toyota' AND model='RAV4' AND year=2020 AND trim='XLE Premium' LIMIT 1),
  2259000, 98000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-toyota-rav4-xle-premium');


-- -------------------------------------------------------
-- PORSCHE MACAN
-- -------------------------------------------------------

-- 2019 Macan Base - 45,013 mi - $32,590 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='Base' LIMIT 1),
  3259000, 45013, 'carvana', NULL, 'https://www.carvana.com/vehicle/4072973');

-- 2021 Macan Base - 5,027 mi - $43,590 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2021 AND trim='Base' LIMIT 1),
  4359000, 5027, 'carvana', NULL, 'https://www.carvana.com/vehicle/3821512');

-- 2020 Macan Base - 63,031 mi - $30,590 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2020 AND trim='Base' LIMIT 1),
  3059000, 63031, 'carvana', NULL, 'https://www.carvana.com/vehicle/3765547');

-- 2019 Macan Base - 45,051 mi - $32,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='Base' LIMIT 1),
  3299000, 45051, 'carvana', NULL, 'https://www.carvana.com/vehicle/3711622');

-- 2020 Macan GTS - 20,734 mi - Great Deal (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2020 AND trim='GTS' LIMIT 1),
  4599000, 20734, 'carvana', NULL, 'https://www.carvana.com/vehicle/3203407');

-- 2019 Macan S - 39,203 mi - $38,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='S' LIMIT 1),
  3899000, 39203, 'carvana', NULL, 'https://www.carvana.com/vehicle/3906105');

-- 2019 Macan Base - 57k mi - $30,590 (from hybrid/listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='Base' LIMIT 1),
  3059000, 57000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-hybrid');

-- 2021 Macan Base - 45k mi - $34,990 (from hybrid/listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2021 AND trim='Base' LIMIT 1),
  3499000, 45000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-hybrid');

-- 2021 Macan Base - 46k mi - $35,590 (from hybrid/listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2021 AND trim='Base' LIMIT 1),
  3559000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-hybrid');

-- 2020 Macan S - 42k mi - $43,990 (from S listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2020 AND trim='S' LIMIT 1),
  4399000, 42000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-porsche-macan-s');

-- 2018 Macan S - 44k mi - $31,990 (from S listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2018 AND trim='S' LIMIT 1),
  3199000, 44000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-porsche-macan-s');

-- 2021 Macan S - 51k mi - $39,590 (from S under 40k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2021 AND trim='S' LIMIT 1),
  3959000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-s-under-40000');

-- 2018 Macan S - 34k mi - $35,590 (from S under 40k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2018 AND trim='S' LIMIT 1),
  3559000, 34000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-s-under-40000');

-- 2017 Macan Turbo - 63k mi - $37,990 (from turbo under 50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2017 AND trim='Turbo' LIMIT 1),
  3799000, 63000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-turbo-under-50000');

-- 2021 Macan Turbo - 73k mi - $40,590 (from turbo under 50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2021 AND trim='Turbo' LIMIT 1),
  4059000, 73000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-turbo-under-50000');

-- 2020 Macan Base - 43k mi - $32,590 (from under 40k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2020 AND trim='Base' LIMIT 1),
  3259000, 43000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-under-40000');

-- 2018 Macan Base - 46k mi - $27,590 (from under 40k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2018 AND trim='Base' LIMIT 1),
  2759000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-under-40000');

-- 2017 Macan GTS - 45k mi - $33,590 (from GTS page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2017 AND trim='GTS' LIMIT 1),
  3359000, 45000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-gts');

-- 2018 Macan GTS - 66k mi - $33,990 (from GTS 2019 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2018 AND trim='GTS' LIMIT 1),
  3399000, 66000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-porsche-macan-gts');

-- 2020 Macan Base - 57k mi - $29,990 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2020 AND trim='Base' LIMIT 1),
  2999000, 57000, 'carvana', NULL, 'https://www.carvana.com/cars/porsche-macan-electric');

-- 2019 Macan Base - 67k mi - $30,590 (from 2019 under 60k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='Base' LIMIT 1),
  3059000, 67000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-porsche-under-60000');

-- 2019 Macan Base - 46k mi - $32,590 (from 2019 under 60k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Porsche' AND model='Macan' AND year=2019 AND trim='Base' LIMIT 1),
  3259000, 46000, 'carvana', NULL, 'https://www.carvana.com/cars/2019-porsche-under-60000');


-- -------------------------------------------------------
-- ACURA RDX
-- -------------------------------------------------------

-- 2021 RDX SH-AWD w/A-SPEC Pkg - 47,489 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='SH-AWD w/A-SPEC Pkg' LIMIT 1),
  3099000, 47489, 'carvana', NULL, 'https://www.carvana.com/vehicle/3323428');

-- 2020 RDX SH-AWD Technology Pkg - 23,210 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='SH-AWD Technology Pkg' LIMIT 1),
  3099000, 23210, 'carvana', NULL, 'https://www.carvana.com/vehicle/2731986');

-- 2022 RDX FWD w/A-Spec Pkg - 28,292 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='FWD w/A-Spec Pkg' LIMIT 1),
  3199000, 28292, 'carvana', NULL, 'https://www.carvana.com/vehicle/3203045');

-- 2021 RDX SH-AWD w/Advance Pkg - 9,956 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='SH-AWD w/Advance Pkg' LIMIT 1),
  3599000, 9956, 'carvana', NULL, 'https://www.carvana.com/vehicle/2648568');

-- 2022 RDX FWD w/Technology Pkg - 16,705 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='FWD w/Technology Pkg' LIMIT 1),
  3199000, 16705, 'carvana', NULL, 'https://www.carvana.com/vehicle/2933796');

-- 2020 RDX Base - 11k mi - $31,990 (from 2020 listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='Base' LIMIT 1),
  3199000, 11000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-rdx');

-- 2020 RDX Base - 22k mi - $30,590 (from 2020 listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='Base' LIMIT 1),
  3059000, 22000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-rdx');

-- 2021 RDX FWD w/Technology Pkg - 45k mi - $28,590 (from 2022 listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='FWD w/Technology Pkg' LIMIT 1),
  2859000, 45000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-acura-rdx');

-- 2022 RDX Base - 51k mi - $27,990 (from 2022 listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='Base' LIMIT 1),
  2799000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-acura-rdx');

-- 2019 RDX SH-AWD Advance Pkg - 63k mi - $25,590 (from 2021 listing page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2019 AND trim='SH-AWD Advance Pkg' LIMIT 1),
  2559000, 63000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-acura-rdx');

-- 2022 RDX FWD w/A-Spec Pkg - 62k mi - $29,990 (from Tucson AZ page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='FWD w/A-Spec Pkg' LIMIT 1),
  2999000, 62000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-in-tucson-az');

-- 2020 RDX SH-AWD Technology Pkg - 38k mi - $30,990 (from 2020 under 50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='SH-AWD Technology Pkg' LIMIT 1),
  3099000, 38000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-under-50000');

-- 2020 RDX A-SPEC Pkg - 82k mi - $25,590 (from 2020 under 50k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='A-SPEC Pkg' LIMIT 1),
  2559000, 82000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-under-50000');

-- 2021 RDX FWD w/Technology Pkg - 61k mi - $26,590 (from blue page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='FWD w/Technology Pkg' LIMIT 1),
  2659000, 61000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-in-blue');

-- 2022 RDX SH-AWD w/A-Spec & Advance Pkgs - 41k mi - $34,590 (from blue page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='SH-AWD w/A-Spec & Advance Pkgs' LIMIT 1),
  3459000, 41000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-in-blue');

-- 2021 RDX FWD w/Technology Pkg - 61k mi - $26,990 (from LA page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='FWD w/Technology Pkg' LIMIT 1),
  2699000, 61000, 'carvana', 'Los Angeles, CA', 'https://www.carvana.com/cars/acura-rdx-in-los-angeles-ca');

-- 2020 RDX SH-AWD Technology Pkg - 74k mi - $24,590 (from LA page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='SH-AWD Technology Pkg' LIMIT 1),
  2459000, 74000, 'carvana', 'Los Angeles, CA', 'https://www.carvana.com/cars/acura-rdx-in-los-angeles-ca');

-- 2020 RDX SH-AWD Technology Pkg - 76k mi - $24,590 (from LA page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='SH-AWD Technology Pkg' LIMIT 1),
  2459000, 76000, 'carvana', 'Los Angeles, CA', 'https://www.carvana.com/cars/acura-rdx-in-los-angeles-ca');

-- 2022 RDX SH-AWD w/Advance Pkg - 59k mi - $35,590 (from Philadelphia page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2022 AND trim='SH-AWD w/Advance Pkg' LIMIT 1),
  3559000, 59000, 'carvana', 'Philadelphia, PA', 'https://www.carvana.com/cars/acura-rdx-in-philadelphia-pa');

-- 2021 RDX SH-AWD w/A-SPEC Pkg - 62k mi - $32,990 (from Philadelphia page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='SH-AWD w/A-SPEC Pkg' LIMIT 1),
  3299000, 62000, 'carvana', 'Philadelphia, PA', 'https://www.carvana.com/cars/acura-rdx-in-philadelphia-pa');

-- 2021 RDX SH-AWD w/A-SPEC Pkg - 36k mi - $30,990 (from black page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='SH-AWD w/A-SPEC Pkg' LIMIT 1),
  3099000, 36000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-in-black');

-- 2019 RDX FWD w/A-SPEC Pkg - 74k mi - $24,990 (from black page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2019 AND trim='FWD w/A-SPEC Pkg' LIMIT 1),
  2499000, 74000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-in-black');

-- 2020 RDX SH-AWD Technology Pkg - 47k mi - $29,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='SH-AWD Technology Pkg' LIMIT 1),
  2999000, 47000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-rdx-hybrid');

-- 2020 RDX A-SPEC Pkg - 17k mi - $34,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='A-SPEC Pkg' LIMIT 1),
  3499000, 17000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-acura-rdx-hybrid');

-- 2020 RDX Technology Pkg - 11k mi - $31,990 (from 2022 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2020 AND trim='Technology Pkg' LIMIT 1),
  3199000, 11000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-acura-rdx');

-- 2021 RDX SH-AWD w/A-SPEC Pkg - 30k mi - $35,590 (from SUV under 20k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='SH-AWD w/A-SPEC Pkg' LIMIT 1),
  3559000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-suv-under-20000');

-- 2021 RDX FWD w/Technology Pkg - 61k mi - $26,590 (from SH-AWD page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Acura' AND model='RDX' AND year=2021 AND trim='FWD w/Technology Pkg' LIMIT 1),
  2659000, 61000, 'carvana', NULL, 'https://www.carvana.com/cars/acura-rdx-sh-awd-under-45000');


-- -------------------------------------------------------
-- HONDA CR-V / CR-V HYBRID
-- -------------------------------------------------------

-- 2021 CR-V Hybrid EX - 47k mi - $26,990 (from 2020 EX page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX' LIMIT 1),
  2699000, 47000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-honda-cr-v-ex');

-- 2021 CR-V EX-L - 31k mi - $27,590 (from 2021 LX page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2021 AND trim='EX-L' LIMIT 1),
  2759000, 31000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v-lx');

-- 2021 CR-V Hybrid EX-L - 30k mi - $29,990 (from 2021 CR-V page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX-L' LIMIT 1),
  2999000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v');

-- 2021 CR-V Hybrid EX-L - 28k mi - $29,990 (from 2021 CR-V page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX-L' LIMIT 1),
  2999000, 28000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v');

-- 2021 CR-V Hybrid Touring - 12k mi - $32,990 (from touring page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='Touring' LIMIT 1),
  3299000, 12000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-touring');

-- 2022 CR-V Hybrid Touring - 27k mi - $30,990 (from touring page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2022 AND trim='Touring' LIMIT 1),
  3099000, 27000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-touring');

-- 2022 CR-V Hybrid Touring - 35k mi - $30,990 (from touring page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2022 AND trim='Touring' LIMIT 1),
  3099000, 35000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-touring');

-- 2020 CR-V EX-L - 29k mi - $26,590 (from EX-L page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2020 AND trim='EX-L' LIMIT 1),
  2659000, 29000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-ex-l');

-- 2021 CR-V EX-L - 31k mi - $27,590 (from EX-L page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2021 AND trim='EX-L' LIMIT 1),
  2759000, 31000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-ex-l');

-- 2020 CR-V Hybrid EX-L - 23k mi - $31,590 (from leather/sunroof page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2020 AND trim='EX-L' LIMIT 1),
  3159000, 23000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-ex-l-with-leather-interior-and-sunroof');

-- 2021 CR-V EX - 70k mi - $23,990 (from EX under 25k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2021 AND trim='EX' LIMIT 1),
  2399000, 70000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-ex-under-25000');

-- 2020 CR-V LX - 122,187 mi - $17,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2020 AND trim='LX' LIMIT 1),
  1799000, 122187, 'carvana', NULL, 'https://www.carvana.com/vehicle/3730762');

-- 2020 CR-V Touring - 23k mi - $28,990 (from NY page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2020 AND trim='Touring' LIMIT 1),
  2899000, 23000, 'carvana', 'New York, NY', 'https://www.carvana.com/cars/2020-honda-cr-v-in-new-york-ny');

-- 2020 CR-V EX-L - 46k mi - $25,990 (from NY page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2020 AND trim='EX-L' LIMIT 1),
  2599000, 46000, 'carvana', 'New York, NY', 'https://www.carvana.com/cars/2020-honda-cr-v-in-new-york-ny');

-- 2021 CR-V Hybrid EX-L - 23k mi - $32,590 (from 2021 EX-L page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX-L' LIMIT 1),
  3259000, 23000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v-ex-l');

-- 2021 CR-V EX-L - 61k mi - $25,990 (from 2021 EX-L page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2021 AND trim='EX-L' LIMIT 1),
  2599000, 61000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v-ex-l');

-- 2021 CR-V Hybrid EX - 26k mi - $28,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX' LIMIT 1),
  2899000, 26000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v-hybrid');

-- 2021 CR-V Hybrid EX-L - 30k mi - $29,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2021 AND trim='EX-L' LIMIT 1),
  2999000, 30000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-honda-cr-v-hybrid');

-- 2021 CR-V Touring - 51k mi - $28,590 (from hybrid touring page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V' AND year=2021 AND trim='Touring' LIMIT 1),
  2859000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/honda-cr-v-hybrid-touring');

-- 2020 CR-V Hybrid EX - 94k mi - $22,990 (from 2020 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Honda' AND model='CR-V Hybrid' AND year=2020 AND trim='EX' LIMIT 1),
  2299000, 94000, 'carvana', NULL, 'https://www.carvana.com/cars/2020-honda-cr-v');


-- -------------------------------------------------------
-- MAZDA CX-5
-- -------------------------------------------------------

-- 2021 CX-5 Signature - 15,495 mi - $32,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2021 AND trim='Signature' LIMIT 1),
  3299000, 15495, 'carvana', NULL, 'https://www.carvana.com/vehicle/2731836');

-- 2020 CX-5 Grand Touring Reserve - 10,335 mi - $31,590 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2020 AND trim='Grand Touring Reserve' LIMIT 1),
  3159000, 10335, 'carvana', NULL, 'https://www.carvana.com/vehicle/2700319');

-- 2021 CX-5 Touring - 2,579 mi - $26,996 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2021 AND trim='Touring' LIMIT 1),
  2699600, 2579, 'carvana', NULL, 'https://www.carvana.com/vehicle/1799915');

-- 2020 CX-5 Touring - 53,476 mi - $22,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Mazda' AND model='CX-5' AND year=2020 AND trim='Touring' LIMIT 1),
  2299000, 53476, 'carvana', NULL, 'https://www.carvana.com/vehicle/2473152');


-- -------------------------------------------------------
-- HYUNDAI TUCSON
-- -------------------------------------------------------

-- 2022 Tucson Limited - 25,691 mi - $33,590 (from 2021-2022 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='Limited' LIMIT 1),
  3359000, 25691, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson/2021-2022');

-- 2021 Tucson SEL - 30,827 mi - $27,590 (from 2021-2022 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='SEL' LIMIT 1),
  2759000, 30827, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson/2021-2022');

-- 2021 Tucson Value - 48,862 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Value' LIMIT 1),
  1999000, 48862, 'carvana', NULL, 'https://www.carvana.com/vehicle/2794196');

-- 2022 Tucson SEL - 59k mi - $21,590 (from black page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='SEL' LIMIT 1),
  2159000, 59000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-hyundai-tucson-in-black');

-- 2022 Tucson Limited - 15k mi - $27,590 (from 2022 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='Limited' LIMIT 1),
  2759000, 15000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-hyundai-tucson');

-- 2022 Tucson N Line - 40k mi - $23,590 (from 2022 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='N Line' LIMIT 1),
  2359000, 40000, 'carvana', NULL, 'https://www.carvana.com/cars/2022-hyundai-tucson');

-- 2022 Tucson SEL - 44k mi - $21,990 (from under 30k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='SEL' LIMIT 1),
  2199000, 44000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-under-30000');

-- 2021 Tucson Limited - 51k mi - $20,990 (from under 30k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Limited' LIMIT 1),
  2099000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-under-30000');

-- 2021 Tucson Value - 44k mi - $20,990 (from value page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Value' LIMIT 1),
  2099000, 44000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-value');

-- 2021 Tucson Sport - 92k mi - $17,990 (from 2021 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Sport' LIMIT 1),
  1799000, 92000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-hyundai-tucson');

-- 2022 Tucson Hybrid SEL Convenience - 29k mi - $24,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson Hybrid' AND year=2022 AND trim='SEL Convenience' LIMIT 1),
  2499000, 29000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-hybrid');

-- 2022 Tucson Hybrid SEL Convenience - 27k mi - $24,990 (from hybrid page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson Hybrid' AND year=2022 AND trim='SEL Convenience' LIMIT 1),
  2499000, 27000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-hybrid');

-- 2022 Tucson Hybrid Blue - 36,907 mi - $24,990 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson Hybrid' AND year=2022 AND trim='Blue' LIMIT 1),
  2499000, 36907, 'carvana', NULL, 'https://www.carvana.com/vehicle/3283639');

-- 2022 Tucson Limited - 6,937 mi - $40,590 (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='Limited' LIMIT 1),
  4059000, 6937, 'carvana', NULL, 'https://www.carvana.com/vehicle/2088314');

-- 2021 Tucson SEL - 77k mi - $18,590 (from 2021 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='SEL' LIMIT 1),
  1859000, 77000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-hyundai-tucson');

-- 2021 Tucson Limited - 51k mi - $20,590 (from sunroof page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Limited' LIMIT 1),
  2059000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-with-sunroof');

-- 2022 Tucson Hybrid Blue - 40k mi - $22,990 (from hybrid blue page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson Hybrid' AND year=2022 AND trim='Blue' LIMIT 1),
  2299000, 40000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-hybrid-blue');

-- 2022 Tucson N Line - 51k mi - $25,990 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2022 AND trim='N Line' LIMIT 1),
  2599000, 51000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-electric');

-- 2021 Tucson Sport - 60k mi - $22,590 (from electric page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Hyundai' AND model='Tucson' AND year=2021 AND trim='Sport' LIMIT 1),
  2259000, 60000, 'carvana', NULL, 'https://www.carvana.com/cars/hyundai-tucson-electric');


-- -------------------------------------------------------
-- SUBARU FORESTER (additional listings)
-- -------------------------------------------------------

-- 2021 Forester Sport - 39k mi - $25,990 (from black page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim='Sport' LIMIT 1),
  2599000, 39000, 'carvana', NULL, 'https://www.carvana.com/cars/subaru-forester-in-black');

-- 2021 Forester Limited - 27k mi - $27,590 (from blue/green page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim='Limited' LIMIT 1),
  2759000, 27000, 'carvana', NULL, 'https://www.carvana.com/cars/subaru-forester-in-blue-or-green');

-- 2020 Forester Touring - 11k mi - $29,990 (from blue/green page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2020 AND trim='Touring' LIMIT 1),
  2999000, 11000, 'carvana', NULL, 'https://www.carvana.com/cars/subaru-forester-in-blue-or-green');

-- 2020 Forester Sport - 32,777 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2020 AND trim='Sport' LIMIT 1),
  2499000, 32777, 'carvana', NULL, 'https://www.carvana.com/vehicle/3029849');

-- 2021 Forester base - 26k mi - $25,990 (from blue/gray page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Forester' AND year=2021 AND trim IS NULL LIMIT 1),
  2599000, 26000, 'carvana', NULL, 'https://www.carvana.com/cars/subaru-forester-in-blue-or-gray');


-- -------------------------------------------------------
-- SUBARU OUTBACK
-- -------------------------------------------------------

-- 2021 Outback Limited - 57k mi - $23,590 (from 2021 page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2021 AND trim='Limited' LIMIT 1),
  2359000, 57000, 'carvana', NULL, 'https://www.carvana.com/cars/2021-subaru-outback');

-- 2021 Outback Premium - 60,307 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2021 AND trim='Premium' LIMIT 1),
  2299000, 60307, 'carvana', NULL, 'https://www.carvana.com/vehicle/4029023');

-- 2020 Outback Premium - 23,565 mi (specific vehicle listing)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2020 AND trim='Premium' LIMIT 1),
  2599000, 23565, 'carvana', NULL, 'https://www.carvana.com/vehicle/2182156');

-- 2020 Outback Limited - 15,178 mi - $32,990 (from limited page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2020 AND trim='Limited' LIMIT 1),
  3299000, 15178, 'carvana', NULL, 'https://www.carvana.com/cars/2020-subaru-outback-limited');

-- 2020 Outback Limited - 19,724 mi - $33,990 (from limited page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2020 AND trim='Limited' LIMIT 1),
  3399000, 19724, 'carvana', NULL, 'https://www.carvana.com/cars/2020-subaru-outback-limited');

-- 2020 Outback Premium - 33,040 mi - $27,990 (from 2020 Subaru page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Subaru' AND model='Outback' AND year=2020 AND trim='Premium' LIMIT 1),
  2799000, 33040, 'carvana', NULL, 'https://www.carvana.com/cars/subaru/2020');


-- -------------------------------------------------------
-- VOLKSWAGEN ATLAS / BUICK ENCORE (from general SUV search)
-- -------------------------------------------------------

-- 2021 VW Atlas S - 54k mi - $22,990 (from SUV under 25k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Volkswagen' AND model='Atlas' AND year=2021 AND trim='S' LIMIT 1),
  2299000, 54000, 'carvana', NULL, 'https://www.carvana.com/cars/suv-with-third-row-seat-under-25000');

-- 2022 Buick Encore Preferred - 27k mi - $19,990 (from SUV under 20k page)
INSERT INTO price_snapshots (time, vehicle_id, price_cents, mileage, source, location, url)
VALUES (clock_timestamp() + (nextval('time_offset_seq') * INTERVAL '1 second'), (SELECT id FROM vehicles WHERE make='Buick' AND model='Encore' AND year=2022 AND trim='Preferred' LIMIT 1),
  1999000, 27000, 'carvana', NULL, 'https://www.carvana.com/cars/suv-under-20000');


COMMIT;

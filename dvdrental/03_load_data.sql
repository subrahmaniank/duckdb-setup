-- 03_load_data.sql
-- Purpose: Load DVD Rental CSV data into DuckDB tables
-- Note: Paths are relative to database directory (or parameterized by build script)

COPY actor FROM 'data/actor.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY category FROM 'data/category.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY language FROM 'data/language.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY country FROM 'data/country.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY city FROM 'data/city.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY address FROM 'data/address.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY film FROM 'data/film.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY film_actor FROM 'data/film_actor.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY film_category FROM 'data/film_category.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY staff FROM 'data/staff.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY store FROM 'data/store.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY customer FROM 'data/customer.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY inventory FROM 'data/inventory.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY rental FROM 'data/rental.csv' (DELIMITER '\t', HEADER false, NULL '\N');
COPY payment FROM 'data/payment.csv' (DELIMITER '\t', HEADER false, NULL '\N');

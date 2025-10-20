#!/bin/bash
set -e;


if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
		CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
		GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
    CREATE TABLE IF NOT EXISTS orders (
        order_id SERIAL PRIMARY KEY,
        customer_name VARCHAR(100) NOT NULL,
        order_date DATE NOT NULL,
        total_amount NUMERIC(10, 2) NOT NULL,
        status VARCHAR(20) NOT NULL
    );
		GRANT ALL PRIVILEGES ON DATABASE orders TO ${POSTGRES_NON_ROOT_USER};
    INSERT INTO orders (customer_name, order_date, total_amount, status) VALUES
    ('Alice Johnson', '2025-10-01', 120.50, 'Pending'),
    ('Bob Smith', '2025-10-02', 75.00, 'Shipped'),
    ('Charlie Brown', '2025-10-03', 200.00, 'Delivered'),
    ('Diana Prince', '2025-10-04', 50.25, 'Cancelled'),
    ('Ethan Hunt', '2025-10-05', 180.75, 'Pending'),
    ('Fiona Gallagher', '2025-10-06', 99.99, 'Shipped');
	EOSQL
else
	echo "SETUP INFO: No Environment variables given!"
fi
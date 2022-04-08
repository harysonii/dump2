-- Schema design for app

-- Tables
-- 1. Users
-- 2. Groups
-- 3. Members
-- 4. Channels
-- 5. Messages
-- 6. Budgets
-- 7. Countries
-- 8. States
-- 9. Currencies
-- 10. Banks
-- 11. Payment Gateways
-- 12. Timezones
-- 13. Files
-- 14. Permissions
-- 15. languages
-- 16. Tags
-- 17. Addresses
-- 18. Preferences
-- 19. Settings
-- 20. Plans (Pricing)
-- 21. Payments
-- 22. invoices
-- 23. invoice_members
-- 24. Reactions (Messages)

-- Custom types
create type public.app_permission as enum ('channels.delete', 'messages.delete');
create type public.app_role as enum ('admin', 'moderator');
-- create type public.user_status as enum ('ONLINE', 'OFFLINE'); use boolean instead
create type public.user_gender as enum ('Male', 'Female', 'Other');
create type public.payment_for as enum ('dues', 'levy', 'subcription','commission');
create type public.transaction_t as enum ('debit', 'credit', 'reversal', 'charge');
create type public.payment_status_type as enum ('UNPAID', 'PAID');
create type public.invoice_t as enum ('DUES', 'LEVY', 'DONATION');
create type public.continents as enum ('Africa', 'Antarctica', 'Asia', 'Europe', 'Oceania', 'North America', 'South America');

-- Database tables
CREATE TABLE IF NOT EXISTS languages (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    one varchar(225),
    two_t varchar(225),
    two_b varchar(225),
    native_name varchar(225),
    name varchar(225) NOT NULL UNIQUE,
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS timezones (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    short_code varchar(100) NOT NULL,
    name varchar(225) NOT NULL,
    diff varchar(100) NOT NULL,
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS countries (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    name text,
    slug varchar(225) UNIQUE NOT NULL,
    iso2 text NOT NULL,
    iso3 text,
    local_name text,
    continent continents,
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);

-- states of the countries we provide service to
CREATE TABLE IF NOT EXISTS states (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    name varchar(225) NOT NULL,
    country_id uuid REFERENCES countries (id),
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS currencies (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    name varchar(225) NOT NULL,
    code varchar(225) NOT NULL,
    symbol varchar(225) NOT NULL,
    delete_on timestamp without time zone,
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS banks (
    id uuid NOT NULL DEFAULT uuid_generate_v4 () PRIMARY KEY,
    slug varchar(225) NOT NULL UNIQUE,
    name varchar(225),
    code int UNIQUE,
    logo text NOT NULL,
    colors jsonb,
    active boolean NOT NULL DEFAULT TRUE,
    recurring_debit boolean NOT NULL DEFAULT FALSE,
    delete_on timestamp without time zone,
    created_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_on timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now())
);
create table if not exists profiles (
    id uuid not null primary key, -- UUID from auth.users
    first_name varchar(225) not null,
    last_name varchar(225) not null,
    username varchar(60) not null unique,
    email varchar(225) not null unique,
    avatar text,
    phone bigint not null,
    dob date,
    gender user_gender,
    bio text,
    is_banned boolean default false,
    is_private boolean default false,
    is_online boolean default false,
    is_bot boolean default false,
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);
comment on table public.profiles is 'Personal data for each user that has sign up or been invited.';
comment on column public.profiles.id is 'References the internal Supabase auth.users id';

create table if not exists groups (
    id uuid not null default uuid_generate_v4() primary key,
    name varchar(225) not null unique,
    owner uuid not null references users(id),
    description text,
    slug varchar(225) not null unique,
    is_verified boolean not null default false,
    is_suspended boolean not null default false,
    logo text,
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists members (
    id uuid not null default uuid_generate_v4() primary key,
    group_id uuid not null references groups(id),
    user_id uuid not null references users(id),
    tags uuid[],
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists channels (
    id uuid not null default uuid_generate_v4() primary key,
    name varchar(225) not null unique,
    group_id uuid not null references groups(id),
    is_public boolean not null default false,
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists messages (
    id uuid not null default uuid_generate_v4() primary key,
    words text,
    attachments jsonb, -- max 10 {  type: 'image', asset_url: 'https://bit.ly/2K74TaG', thumb_url: 'https://bit.ly/2Uumxti'}
    channel_id uuid not null references channels(id),
    parent_id uuid references messages(id),
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists message_reactions (
    id uuid not null default uuid_generate_v4() primary key,
    message_id uuid not null references messages (id),
    user_id uuid not null references profiles (id),
    thumbs_up boolean not null default false,
    thumbs_down boolean not null default false,
    applaud boolean not null default false,
    heart boolean not null default false,
    heartbreak boolean not null default false,
    lightbulb boolean not null default false,
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists invoices (
    id uuid not null default uuid_generate_v4() primary key,
    title varchar(255) not null,
    group_id uuid references groups(id),
    amount bigint default 0,
    due_date timestamp,
    invoice_type invoice_t not null,
    interest boolean not null default false,
    interest_percentage int not null default 0,
    cycle varchar(50),
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

create table if not exists invoice_members (
    id uuid not null default uuid_generate_v4() primary key,
    group_id uuid references groups(id),
    user_id uuid references users(id),
    invoice_id uuid references invoices (id),
    payment_status payment_status_type default 'UNPAID',
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);


create table if not exists ledger (
    id uuid not null default uuid_generate_v4() primary key,
    amount bigint not null,
    paid_by uuid references profiles (id),
    paid_to uuid references groups(id),
    paid_for uuid references invoices (id),
    transaction_type transaction_t   balance bigint default 0,
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
);

-- create table if not exists budgets (
--     id uuid not null default uuid_generate_v4() primary key,
--     name varchar(225) not null unique,
--     description text not null,
--     currency uuid not null references currencies(id)
--     items jsonb, -- item, description, value
--     review_count bigint default 0,
--     created_on timestamp with time zone not null default timezone('utc'::text, now()),
--     updated_on timestamp with time zone not null default timezone('utc'::text, now())
-- );

create table if not exists tags (
    id uuid not null default uuid_generate_v4() primary key,
    name varchar (50),
    created_on timestamp with time zone not null default timezone('utc'::text, now()),
    updated_on timestamp with time zone not null default timezone('utc'::text, now())
)
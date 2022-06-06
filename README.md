# Marketing Analytics Case Study
## Introduction

## Requirements

 1. Identify top 2 categories for each customer based off their past
    rental history
 2.  For each customer recommend up to 3 popular unwatched films for each category
 3.  Generate 1st category insights that includes:
	    - How many total films have they watched in their top category?
	    - How many more films has the customer watched compared to the average DVD Rental Co customer?
	    - How does the customer rank in terms of the top X% compared to all other customers in this film category?
4.  Generate 2nd insights that includes:
	-   How many total films has the customer watched in this category?
    -   What proportion of each customer’s total films watched does this count make?
5.  Identify each customer’s favorite actor and film count, then recommend up to three more unwatched films starring the same actor

## ERD

    Table "rental" {
      "rental_id" integer [not null]
      "rental_date" timestamp [not null]
      "inventory_id" integer [not null]
      "customer_id" smallint [not null]
      "return_date" timestamp
      "staff_id" smallint [not null]
      "last_update" timestamp [not null, default: `now()`]
    
    Indexes {
      inventory_id [type: btree, name: "idx_fk_inventory_id"]
      (rental_date, inventory_id, customer_id) [type: btree, unique, name: "idx_unq_rental_rental_date_inventory_id_customer_id"]
    }
    }
    
    Table "inventory" {
      "inventory_id" integer [not null, default: `nextval('inventory_inventory_id_seq'::regclass)`]
      "film_id" smallint [not null]
      "store_id" smallint [not null]
      "last_update" timestamp [not null, default: `now()`]
    
    Indexes {
      (store_id, film_id) [type: btree, name: "idx_store_id_film_id"]
    }
    }
    
    
    Table "film" {
      "film_id" integer [not null, default: `nextval('film_film_id_seq'::regclass)`]
      "title" "character varying(255)" [not null]
      "description" text
      "release_year" year
      "language_id" smallint [not null]
      "original_language_id" smallint
      "rental_duration" smallint [not null, default: 3]
      "rental_rate" "numeric(4, 2)" [not null, default: 4.99]
      "length" smallint
      "replacement_cost" "numeric(5, 2)" [not null, default: 19.99]
      "rating" "character varying(5)" [default: "G"]
      "last_update" timestamp [not null, default: `now()`]
      "special_features" text
      "fulltext" tsvector [not null]
    
    Indexes {
      fulltext [type: btree, name: "film_fulltext_idx"]
      language_id [type: btree, name: "idx_fk_language_id"]
      original_language_id [type: btree, name: "idx_fk_original_language_id"]
      title [type: btree, name: "idx_title"]
    }
    }
    
    Table "film_category" {
      "film_id" smallint [not null]
      "category_id" smallint [not null]
      "last_update" timestamp [not null, default: `now()`]
    }
    
    Table "category" {
      "category_id" integer [not null, default: `nextval('category_category_id_seq'::regclass)`]
      "name" "character varying(25)" [not null]
      "last_update" timestamp [not null, default: `now()`]
    }
    
    Table "film_actor" {
      "actor_id" smallint [not null]
      "film_id" smallint [not null]
      "last_update" timestamp [not null, default: `now()`]
    
    Indexes {
      film_id [type: btree, name: "idx_fk_film_id"]
    }
    }
    
    Table "actor" {
      "actor_id" integer [not null, default: `nextval('actor_actor_id_seq'::regclass)`]
      "first_name" varchar(45) [not null]
      "last_name" varchar(45) [not null]
      "last_update" timestamp [not null, default: `now()`]
    
    Indexes {
      last_name [type: btree, name: "idx_actor_last_name"]
    }
    }
    
    -- many to one relationship between rental & inventory
    Ref: "rental"."inventory_id" > "inventory"."inventory_id"
    
    -- many to one inventory to film
    Ref: "inventory"."film_id" > "film"."film_id"
    
    -- one to one relationship between film_category and film 
    Ref: "film_category"."film_id" - "film"."film_id"
    
    -- many to one relationship between film_category and category
    Ref: "film_category"."category_id" > "category"."category_id"
    
    -- one to many relationship between film ands film_actor
    Ref: "film"."film_id" < "film_actor"."film_id"
    
    -- many to one relationship between film_actor and actor
    Ref: "film_actor"."actor_id" > "actor"."actor_id"
  
<iframe 
	height="400" width="100%"
	src='https://dbdiagram.io/d/629e608a54ce2635276e3416'> 
</iframe>

-- CREATE A NEW COLUMN WITH COMBINED DESCRIPTION & EMBEDDINGS FOR COMBINED DATA ---
CREATE EXTENSION IF NOT EXISTS vector;


ALTER TABLE alloydb_demo.fashion_products_tmp 
ADD COLUMN combined_description TEXT, 
ADD COLUMN combined_description_embedding VECTOR(768); 

-- USED https://www.kaggle.com/datasets/paramaggarwal/fashion-product-images-dataset AS REFERENCE TO ADD DESCRIPTION OF EACH FIELD ---
UPDATE alloydb_demo.fashion_products_tmp
SET combined_description = CONCAT(
    'Product ID is ', id,
    ', Product targeted to ', gender,
    ', Primary or master category is ', masterCategory,
    ', Secondary or sub-category is ', subCategory,
    ', Type of product is ', articleType,
    ', Descriptive color name or Base colour is ', baseColour,
    ', Fashion season this product is targeted to is ', season,
    ', Fashion year this product is from is ', year,
    ', This product meant to be used as  OR usage type is ', usage,
    ', Product name including the brand as the first word is ', productDisplayName,
    ', Unit price is ', unitPrice,
    ', Discount applied is ', discount,
    ', Final price or the actual price of the product is ', finalPrice,
    ', Customer rating is ', rating,
    ', Stock code or stock id is ', stockCode,
    ', and Stock status is ', stockStatus, '.'
);

-- EMBEDDINGS CREATED USING text-embedding-005 ---
UPDATE alloydb_demo.fashion_products_tmp
SET combined_description_embedding = google_ml.embedding('text-embedding-005', combined_description) 
WHERE combined_description IS NOT NULL;

-- CREATE INDICES ---
-- GIN INDEX FOR TEXT SEARCH
CREATE INDEX ON alloydb_demo.fashion_products_tmp USING gin(to_tsvector('english', combined_description));
-- SCANN INDEX FOR VECTOR SEARCH
CREATE INDEX my_scann_index ON alloydb_demo.fashion_products_tmp
USING scann (combined_description_embedding cosine)
WITH (num_leaves = 20);  -- Adjust based on dataset size (normally num_leaves=no.of records/100)

-- CREATE AND CONFIGURE NLtoSQL SETUP ---
SELECT alloydb_ai_nl.g_create_configuration('fashion_pdt_cfg'); 
SELECT alloydb_ai_nl.g_manage_configuration( 
  operation => 'register_table_view', 
  configuration_id_in => 'fashion_pdt_cfg', 
  table_views_in => '{alloydb_demo.fashion_products}' 
); 
SELECT alloydb_ai_nl.generate_schema_context('fashion_pdt_cfg', TRUE); 
SELECT alloydb_ai_nl.apply_generated_schema_context('fashion_pdt_cfg');
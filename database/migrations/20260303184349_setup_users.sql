-- Create "users" table
CREATE TABLE "public"."users" (
  "id" serial NOT NULL,
  "email" character varying(255) NOT NULL,
  "hashed_password" character varying(255) NOT NULL,
  "is_active" boolean NULL DEFAULT true,
  "created_at" timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "users_email_key" UNIQUE ("email")
);

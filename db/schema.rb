# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_27_222757) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "facturas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "fecha_emision", null: false
    t.date "fecha_vencimiento", null: false
    t.string "numero", null: false
    t.integer "proveedor_id", null: false
    t.decimal "total", precision: 12, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["proveedor_id", "numero"], name: "index_facturas_on_proveedor_id_and_numero", unique: true
    t.index ["proveedor_id"], name: "index_facturas_on_proveedor_id"
  end

  create_table "medios_de_pago", force: :cascade do |t|
    t.boolean "activo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_medios_de_pago_on_nombre", unique: true
  end

  create_table "pagos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "factura_id", null: false
    t.date "fecha", null: false
    t.integer "medio_de_pago_id", null: false
    t.decimal "monto", precision: 12, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["factura_id"], name: "index_pagos_on_factura_id"
    t.index ["medio_de_pago_id"], name: "index_pagos_on_medio_de_pago_id"
    t.index ["usuario_id"], name: "index_pagos_on_usuario_id"
  end

  create_table "proveedores", force: :cascade do |t|
    t.boolean "activo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "cuit", null: false
    t.string "direccion"
    t.string "email"
    t.string "nombre", null: false
    t.string "telefono"
    t.datetime "updated_at", null: false
    t.index ["cuit"], name: "index_proveedores_on_cuit", unique: true
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "nombre", null: false
    t.string "password_digest", null: false
    t.integer "rol", default: 0, null: false
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["token"], name: "index_usuarios_on_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "facturas", "proveedores"
  add_foreign_key "pagos", "facturas"
  add_foreign_key "pagos", "medios_de_pago"
  add_foreign_key "pagos", "usuarios"
end

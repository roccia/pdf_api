# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170417093523) do

  create_table "announce_company_property", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "code",           limit: 30,       comment: "公司代码"
    t.integer "pos_score",                       comment: "正分"
    t.integer "neg_score",                       comment: "负分"
    t.text    "pos_keywords",   limit: 16777215, comment: "正关键词"
    t.text    "neg_keywords",   limit: 16777215, comment: "负关键词"
    t.string  "announce_title"
    t.index ["code", "announce_title"], name: "unique", unique: true, using: :btree
  end

  create_table "cn_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "industry",     limit: 16777215
    t.text     "plate",        limit: 16777215
    t.text     "category",     limit: 16777215
    t.text     "company_name", limit: 16777215
    t.text     "company_code", limit: 16777215
    t.text     "url",          limit: 16777215
    t.text     "title",        limit: 16777215
    t.text     "context",      limit: 16777215
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "report_date"
  end

  create_table "company_property", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "code",                                comment: "公司代码"
    t.string  "property",    limit: 2,               comment: "公告属性  1-正面  0-中性  -1 反面"
    t.integer "totalscore",              default: 0, comment: "总分"
    t.string  "report_time", limit: 100,             comment: "发布时间"
    t.integer "month",                               comment: "月份"
  end

  create_table "data_company_gid", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", comment: "公司名"
    t.string "gid",  comment: "公司代码"
  end

  create_table "data_emotion", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                null: false, comment: "感情色彩词汇"
    t.string  "property", limit: 2,  null: false, comment: "词性"
    t.integer "score",               null: false, comment: "分值"
    t.float   "version",  limit: 24, null: false, comment: "版本"
  end

  create_table "data_stock", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",     limit: 10, comment: "股票名称"
    t.string   "todaypri", limit: 20, comment: "收盘价"
    t.datetime "date",                comment: "当天时间"
    t.string   "gid",      limit: 10, comment: "公司代码"
  end

  create_table "data_yq_list", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "kvUuid",        limit: 32,                    comment: "主键"
    t.text   "kvTitle",       limit: 16777215,              comment: "标题"
    t.text   "kvAbstract",    limit: 16777215,              comment: "摘要"
    t.string "kvCtime",                        default: "", comment: "发布时间"
    t.string "kvSite",                         default: "", comment: "来源"
    t.string "KR_KEYWORDID",  limit: 32,                    comment: "专题 id"
    t.string "kvAuthor"
    t.string "KV_KEYWORD",                                  comment: "专题名称"
    t.string "kvUrl",                                       comment: "地址"
    t.string "shareid",                                     comment: "查询人id"
    t.string "kvOrientation"
    t.index ["kvUuid", "kvUrl"], name: "unique", unique: true, using: :btree
  end

  create_table "interface_wlaq", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "kvUuid",        limit: 32,                    comment: "主键"
    t.text   "kvTitle",       limit: 16777215,              comment: "标题"
    t.text   "kvAbstract",    limit: 16777215,              comment: "摘要"
    t.string "kvCtime",                        default: "", comment: "发布时间"
    t.string "kvSite",                         default: "", comment: "来源"
    t.string "KR_KEYWORDID",  limit: 32,                    comment: "专题 id"
    t.string "kvAuthor"
    t.string "KV_KEYWORD",                                  comment: "专题名称"
    t.string "kvUrl",                                       comment: "地址"
    t.string "shareid",                                     comment: "查询人id"
    t.string "kvOrientation"
    t.index ["kvUuid", "kvUrl"], name: "unique", unique: true, using: :btree
  end

  create_table "summary_announce", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "code",           limit: 30,       null: false, comment: "公司代码"
    t.string  "name",                                         comment: "公司名称"
    t.string  "announce",                                     comment: "公告标题"
    t.text    "summary",        limit: 16777215,              comment: "公告摘要"
    t.string  "newstime",       limit: 100,                   comment: "发布时间"
    t.string  "keywords",                                     comment: "公告 所属属性的关键词"
    t.integer "announce_score",                  null: false, comment: "公司某一篇公告得分"
    t.string  "url",            limit: 100
    t.index ["name", "announce"], name: "unique", unique: true, using: :btree
  end

  create_table "yq_company_property", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "code",                  comment: "公司代码"
    t.integer "totalscore",            comment: "分数"
    t.string  "date",       limit: 32, comment: "时间"
    t.string  "property",   limit: 2
    t.index ["code", "date"], name: "unique", unique: true, using: :btree
  end

end

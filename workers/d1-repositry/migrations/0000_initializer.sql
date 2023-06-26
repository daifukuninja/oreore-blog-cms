-- Migration number: 0000 	 2023-06-24T15:46:43.357Z
PRAGMA foreign_keys=OFF;

-- clean exist tables
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS paragraphs;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS content_tags;

CREATE TABLE IF NOT EXISTS users (
    -- ユーザ情報
    id INTEGER PRIMARY KEY, 
    name TEXT NOT NULL,                                     -- ユーザ名
    email TEXT NOT NULL,                                    -- e-mail
    created_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 作成日(ISO-8601)
    created_user_id INTEGER,                                -- 作成ユーザID
    updated_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 更新日(ISO-8601)
    updated_user_id INTEGER                                 -- 更新ユーザID
);

CREATE TABLE IF NOT EXISTS articles (
    -- 記事のヘッダ情報
    id INTEGER PRIMARY KEY, 
    uuid TEXT NOT NULL UNIQUE,                              -- 記事の変化しないuuid
    title TEXT NOT NULL,                                    -- 記事タイトル
    paragraphs_json TEXT NOT NULL,                          -- 段落のuuidと並び順
    published NUMERIC NOT NULL,                             -- 公開中か
    created_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 作成日(ISO-8601)
    created_user_id INTEGER,                                -- 作成ユーザID
    updated_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 更新日(ISO-8601)
    updated_user_id INTEGER,                                -- 更新ユーザID
    FOREIGN KEY (created_user_id) REFERENCES users(id),
    FOREIGN KEY (updated_user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS paragraphs (
    -- 記事の段落データ
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    article_uuid TEXT NOT NULL,                             -- 変化しない段落のunique id
    caption TEXT NOT NULL,                                  -- 段落のタイトル
    body TEXT,                                              -- 段落本文
    uuid TEXT NOT NULL UNIQUE,                                  -- 段落のuuid
    created_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 作成日(ISO-8601)
    created_user_id INTEGER,                                -- 作成ユーザID
    updated_at TEXT DEFAULT (DATETIME('now', 'localtime')), -- 更新日(ISO-8601)
    updated_user_id INTEGER,                                -- 更新ユーザID
    FOREIGN KEY (article_uuid) REFERENCES articles(uuid),
    FOREIGN KEY (created_user_id) REFERENCES users(id),
    FOREIGN KEY (updated_user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS tags (
    -- タグマスタ
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,                                     -- タグの名称
    uuid TEXT NOT NULL UNIQUE,                              -- タグのuuid(urlに使う)
    created_at TEXT DEFAULT (DATETIME('now', 'localtime'))  -- 作成日(ISO-8601)
);

CREATE TABLE IF NOT EXISTS content_tags (
    -- 段落に付与されたタグの関連を格納する
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paragraph_uuid TEXT NOT NULL,                               -- 段落uuid
    tag_uuid TEXT NOT NULL,                                     -- タグuuid
    created_at TEXT DEFAULT (DATETIME('now', 'localtime')),     -- 作成日(ISO-8601)
    FOREIGN KEY (paragraph_uuid) REFERENCES paragraphs(uuid),
    FOREIGN KEY (tag_uuid) REFERENCES tags(uuid)
);

PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

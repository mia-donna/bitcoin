module Database
(
    initialiseDB,
    saveRecords
) where

import Database.HDBC
import Database.HDBC.Sqlite3
import Parse

initialiseDB :: IO Connection
initialiseDB = 
    do
        conn <- connectSqlite3 "covid.sqlite"
        run conn "CREATE TABLE IF NOT EXISTS records (\
            \dateRep VARCHAR(40) NOT NULL, \
            \day VARCHAR(40) NOT NULL, \
            \month VARCHAR(40) NOT NULL, \
            \year VARCHAR(40) NOT NULL, \
            \cases INT DEFAULT NULL, \
            \deaths INT DEFAULT NULL, \
            \countriesAndTerritories VARCHAR(80) NOT NULL, \
            \continentExp VARCHAR(80) NOT NULL \
            \)" []
        commit conn
        return conn

recordToSqlValues :: Record -> [SqlValue]
recordToSqlValues record = [
        toSql $ dateRep record,
        toSql $ day record,
        toSql $ month record,
        toSql $ year record,
        toSql $ cases record,
        toSql $ deaths record,
        toSql $ countriesAndTerritories record,
        toSql $ continentExp record
    ]

prepareInsertRecordStmt :: Connection -> IO Statement
prepareInsertRecordStmt conn = prepare conn "INSERT INTO records VALUES (?,?,?,?,?,?,?,?)"


saveRecords :: [Record] -> Connection -> IO ()
saveRecords records conn = do
    stmt <- prepareInsertRecordStmt conn
    executeMany stmt (map recordToSqlValues records)
    commit conn

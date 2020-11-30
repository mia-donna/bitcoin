{-# LANGUAGE BlockArguments #-}

module Database 
    (initialiseDB,
    currencyToSqlValues,
    timeToSqlValues,
    prepareInsertTimeStmt,
    saveTimeRecords,
    prepareInsertGbpStmt,
    saveGbpRecords,
    prepareInsertUsdStmt,
    saveUsdRecords,
    prepareInsertEurStmt,
    saveEurRecords,
    -- saveRecords
    ) where

import Database.HDBC
import Database.HDBC.Sqlite3
import Parse 

initialiseDB :: IO Connection
initialiseDB =
 do
    conn <- connectSqlite3 "bitcoin.sqlite" 
    run conn "CREATE TABLE IF NOT EXISTS usd (\
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL, \
          \rate_float DOUBLE \
          \) " []       
        --   \usd_id INTEGER PRIMARY KEY, \
    commit conn
    run conn "CREATE TABLE IF NOT EXISTS gbp (\
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL, \
          \rate_float DOUBLE \
          \) " [] 
        --   \gbp_id INTEGER PRIMARY KEY, \
    commit conn
    run conn "CREATE TABLE IF NOT EXISTS eur (\
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL, \
          \rate_float DOUBLE \
          \) " [] 
        --   \eur_id INTEGER PRIMARY KEY, \
    commit conn
    -- run conn "CREATE TABLE IF NOT EXISTS bpi (\
    --       \id INTEGER PRIMARY KEY AUTOINCREMENT, \
    --       \usd_id INTEGER NOT NULL, \
    --       \gbp_id INTEGER NOT NULL, \
    --       \eur_id INTEGER NOT NULL, \
    --       \FOREIGN KEY (usd_id) REFERENCES usd (usd_id), \
    --       \FOREIGN KEY (gbp_id) REFERENCES gbp (gbp_id), \
    --       \FOREIGN KEY (eur_id) REFERENCES eur (eur_id))" []
    -- commit conn
    run conn "CREATE TABLE IF NOT EXISTS time (\
          \updated VARCHAR(40) NOT NULL, \
          \updated_ISO VARCHAR(40) NOT NULL, \
          \updateduk VARCHAR(40) NOT NULL) " []                           
    commit conn
    return conn


-- to sql values

-- This will work as all values are Strings and Double
currencyToSqlValues :: Currency -> [SqlValue] 
currencyToSqlValues currency = [
       toSql $ code currency,
       toSql $ symbol currency,
       toSql $ rate currency,
       toSql $ description currency,
       toSql $ rate_float currency
    ]

-- This will work because all values are Strings
timeToSqlValues :: Time -> [SqlValue] 
timeToSqlValues time = [
       toSql $ updated time,
       toSql $ updatedISO time,
       toSql $ updateduk time
    ]

-- Prepare to insert 3 records into time table -- still need to add PK id and autoincrement records into this field
prepareInsertTimeStmt :: Connection -> IO Statement
prepareInsertTimeStmt conn = prepare conn "INSERT INTO time VALUES (?,?,?)"

-- Saves time records to db 
saveTimeRecords :: Time -> Connection -> IO ()
saveTimeRecords time conn = do
     stmt <- prepareInsertTimeStmt conn 
     execute stmt (timeToSqlValues time) 
     commit conn    


-- Next create a functions to prepare currencies 
-- GBP
prepareInsertGbpStmt :: Connection -> IO Statement
prepareInsertGbpStmt conn = prepare conn "INSERT INTO gbp VALUES (?,?,?,?,?)"

-- Saves currency records to db 
saveGbpRecords :: Currency -> Connection -> IO ()
saveGbpRecords currency conn = do
     stmt <- prepareInsertGbpStmt conn 
     execute stmt (currencyToSqlValues currency) 
     commit conn

-- USD
-- Next create a function to prepare Currency 
prepareInsertUsdStmt :: Connection -> IO Statement
prepareInsertUsdStmt conn = prepare conn "INSERT INTO usd VALUES (?,?,?,?,?)"

-- Saves currency records to db 
saveUsdRecords :: Currency -> Connection -> IO ()
saveUsdRecords currency conn = do
     stmt <- prepareInsertUsdStmt conn 
     execute stmt (currencyToSqlValues currency) 
     commit conn

-- EUR
-- Next create a function to prepare Currency 
prepareInsertEurStmt :: Connection -> IO Statement
prepareInsertEurStmt conn = prepare conn "INSERT INTO eur VALUES (?,?,?,?,?)"

-- Saves currency records to db 
saveEurRecords :: Currency -> Connection -> IO ()
saveEurRecords currency conn = do
     stmt <- prepareInsertEurStmt conn 
     execute stmt (currencyToSqlValues currency) 
     commit conn


-- prepareInsertRecordStmt :: Connection -> IO Statement
-- prepareInsertRecordStmt conn = prepare conn "INSERT INTO records VALUES (?,?,?,?,?,?,?,?)"

-- saveRecords :: [Record] -> Connection -> IO ()
-- saveRecords records conn = do
--      stmt <- prepareInsertRecordStmt conn 
--      executeMany stmt (map recordToSqlValues records) 
--      commit conn

-- CREATE USD TABLE
{-        run conn "CREATE TABLE IF NOT EXISTS usd (\
             \code VARCHAR(40) NOT NULL, \
             \symbol VARCHAR(40) NOT NULL, \
             \rate VARCHAR(40) NOT NULL,  \
             \description VARCHAR(40) NOT NULL )" -}   

-- CREATE GBP TABLE
{-        run conn "CREATE TABLE IF NOT EXISTS gbp (\
             \code VARCHAR(40) NOT NULL, \
             \symbol VARCHAR(40) NOT NULL, \
             \rate VARCHAR(40) NOT NULL,  \
             \description VARCHAR(40) NOT NULL )" -}      

 -- CREATE EUR TABLE
{-        run conn "CREATE TABLE IF NOT EXISTS eur (\
             \code VARCHAR(40) NOT NULL, \
             \symbol VARCHAR(40) NOT NULL, \
             \rate VARCHAR(40) NOT NULL,  \
             \description VARCHAR(40) NOT NULL )" -} 

-- CREATE TIME TABLE
{-        run conn "CREATE TABLE IF NOT EXISTS time (\
             \updated VARCHAR(40) NOT NULL, \
             \updated_ISO VARCHAR(40) NOT NULL, \
             \updateduk VARCHAR(40) NOT NULL )" -}

-- insert cabal deps from finance

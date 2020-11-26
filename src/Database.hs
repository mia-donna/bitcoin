{-# LANGUAGE BlockArguments #-}

module Database 
    (initialiseDB,
    -- saveRecords
    ) where

import Database.HDBC
import Database.HDBC.Sqlite3
import Parse 

initialiseDB :: IO Connection
initialiseDB =
 do
    conn <- connectSqlite3 "bitcoin.sqlite"
    run conn "CREATE TABLE IF NOT EXISTS bpi (\
          \id INTEGER PRIMARY KEY AUTOINCREMENT, \
          \usd_id INTEGER NOT NULL, \
          \gbp_id INTEGER NOT NULL, \
          \eur_id INTEGER NOT NULL ); \
          \CREATE TABLE IF NOT EXISTS usd (\
          \usd_id INTEGER PRIMARY KEY, \
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL \
          \FOREIGN KEY (usd_id) REFERENCES bpi (usd_id)); \
          \CREATE TABLE IF NOT EXISTS gbp (\
          \gbp_id INTEGER PRIMARY KEY, \
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL \
          \FOREIGN KEY (gbp_id) REFERENCES bpi (gbp_id)); \
          \CREATE TABLE IF NOT EXISTS eur (\
          \eur_id INTEGER PRIMARY KEY, \
          \code VARCHAR(40) NOT NULL, \
          \symbol VARCHAR(40) NOT NULL, \
          \rate VARCHAR(40) NOT NULL,  \
          \description VARCHAR(40) NOT NULL \
          \FOREIGN KEY (eur_id) REFERENCES bpi (eur_id));\
          \CREATE TABLE IF NOT EXISTS time (\
          \id INTEGER PRIMARY KEY AUTOINCREMENT, \
          \updated VARCHAR(40) NOT NULL, \
          \updated_ISO VARCHAR(40) NOT NULL, \
          \updateduk VARCHAR(40) NOT NULL \ 
          \) " []                           
    commit conn
    return conn


-- to sql values

-- This will not work because Currency type is not an instance of toSql
bpiToSqlValues :: Bpi -> [SqlValue] 
bpiToSqlValues bpi = [
       toSql $ usd bpi,
       toSql $ gbp bpi,
       toSql $ eur bpi
    ]  

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

-- bitcoinToSqlValues :: Bitcoin -> [SqlValue] 
-- bitcoinToSqlValues time = [
--        toSql $ time bitcoin,
--        toSql $ disclaimer bitcoin,
--        toSql $ chartName bitcoin,
--        toSql $ bpi bitcoin
--     ]


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

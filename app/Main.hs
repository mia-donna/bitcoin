module Main where

import HTTP
import Parse
-- import ParseNew
import Data.Tuple
import Database

-- Created a function that will go through the list, extract the first element from each tuple and return a list of the extracted elements

getRow :: [(a,b)] -> [a]
getRow lst = [fst x | x <- lst]

-- This returns the decoded mixed-type object (the a HashMap from Text keys to Value values, the Value type being a sum type representation of JS values)
main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    json <- download url
    print "Parsing... "
    case (parse json) of
        Left err -> print err
        Right bits -> do
            -- print ("bpi: ")
            -- print (bpi bits)
            let bpiData = bpi bits
            let usdCurrency = usd bpiData
            let gbpCurrency = gbp bpiData
            let eurCurrency = eur bpiData
            print ("usd: ")
            print(usdCurrency)
            print ("gbp: ")
            print(gbpCurrency)
            print ("eur: ")
            print(eurCurrency)
            print ("time: ")
            print (time bits)
            print "Saving on DB.."
            conn <- initialiseDB
            print("Initialized")
            -- Saves time records to db
            saveTimeRecords (time bits) conn
            print "Time records saved to db!"
    print "Done!"

        -- Right bits -> print (time bits)




-- print (bpi bits) returns the bpi Object (all currencys)
-- print (parseUSD json) returns the whole json "time" object
-- print (parse json) returns the bpi object with label









 -- commented out for now - this works with the key function in Parse   
 --   json <- download url
 --   print (getRateGBP json)
 --   print (getRateUS json)


-- print gbp (putStrLn . lines . map show )
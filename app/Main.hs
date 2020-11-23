module Main where

import HTTP
import Parse


main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    json <- download url
    case (parse json) of
        Left err -> print err
        Right bits -> print (parse json)
    



 -- commented out for now - this works with the key function in Parse   
 --   json <- download url
 --   print (getRateGBP json)
 --   print (getRateUS json)


-- print gbp (putStrLn . lines . map show )
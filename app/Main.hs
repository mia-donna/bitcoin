module Main where

import HTTP
import Parse

main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    json <- download url
    print (getRateGBP json)
    print (getRateUS json)

     
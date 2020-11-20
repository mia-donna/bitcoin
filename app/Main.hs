module Main where

import HTTP
import Parse

main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    json <- download url
    print (getRateGBP json)
    print (getRateUS json)

 -- next we would add / capture more data from the json
 -- then we could add cases for our queries e.g. case get GBP > then say this etc

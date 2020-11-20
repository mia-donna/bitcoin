module Main where

import HTTP

main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    json <- download url
    print json

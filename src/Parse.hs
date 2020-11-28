{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Parse (
    parse,
    Currency (code, symbol, rate, description, rate_float),
    Bpi (usd, gbp, eur),
    Time (updated, updatedISO, updateduk),
    Bitcoin (time, disclaimer, chartName, bpi)
) where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8
import GHC.Generics ( Generic )
import Data.Aeson.TH(deriveJSON, defaultOptions, Options(fieldLabelModifier))
import Data.Text (Text)

data Currency = Currency {
    code :: String,
    symbol :: String,
    rate :: String,
    description :: String,
    rate_float :: Double
} deriving (Show, Generic)

data Bpi = Bpi {
    usd :: Currency,
    gbp :: Currency,
    eur :: Currency
} deriving (Show, Generic)

-- This currency from lower to uppercase (eg. usd to USD)
$(deriveJSON defaultOptions {
    fieldLabelModifier = \x -> 
        if x == "usd" 
            then "USD" 
        else if x == "gbp" 
            then "GBP" 
        else if x == "eur" 
            then "EUR" 
        else x} ''Bpi)

data Time = Time {
    updated :: String,
    updatedISO ::String,
    updateduk :: String
} deriving (Show, Generic)

data Bitcoin = Bitcoin {
    time :: Time,
    disclaimer :: String,
    chartName :: String,
    bpi :: Bpi
} deriving (Show, Generic)


instance FromJSON Bitcoin
instance ToJSON Bitcoin

instance FromJSON Time
instance ToJSON Time

instance FromJSON Currency
instance ToJSON Currency

parse :: L8.ByteString -> Either String Bitcoin
parse json = eitherDecode json :: Either String Bitcoin



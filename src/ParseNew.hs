{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Parse where

import Data.Aeson (eitherDecode)
import qualified Data.ByteString.Lazy.Char8 as L8
import GHC.Generics ( Generic )
import Data.Aeson.Types
import Data.Aeson.TH(deriveJSON, defaultOptions, Options(fieldLabelModifier))
import Data.Text (Text)

-- data Weakness = Weakness [String] deriving (Show, Generic)
data Currency = Currency {
    code :: String,
    symbol :: String,
    rate :: String,
    description :: String,
    rate_float :: Float
} deriving (Show, Generic)

-- data USD = USD {
--     code :: String,
--     symbol :: String,
--     rate :: String,
--     description :: String,
--     rate_float :: Float
-- } deriving (Show, Generic)

-- data GBP = GBP {
--     code :: String,
--     symbol :: String,
--     rate :: String,
--     description :: String,
--     rate_float :: Float
-- } deriving (Show, Generic)

-- data EUR = EUR {
--     code :: String,
--     symbol :: String,
--     rate :: String,
--     description :: String,
--     rate_float :: Float
-- } deriving (Show, Generic)

data Bpi = Bpi {
    usd :: Currency,
    gbp :: Currency,
    eur :: Currency
} deriving (Show, Generic)

-- This gets the USD key from JSON and changes it to usd 
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

-- instance FromJSON Bpi
-- instance ToJSON Bpi

instance FromJSON Currency
instance ToJSON Currency

-- instance FromJSON GBP
-- instance ToJSON GBP

-- instance FromJSON EUR
-- instance ToJSON EUR


parse :: L8.ByteString -> Either String Bitcoin
parse json = eitherDecode json :: Either String Bitcoin



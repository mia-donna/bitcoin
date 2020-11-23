{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Parse where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8
import GHC.Generics ( Generic )
import Data.Aeson.Types ()
-- added ,lens-aeson to cabal file build deps
import Data.Aeson.Lens ( key, _String )
-- added ,text to cabal file build deps
import Data.Text ( Text )
-- added ,lens to cabal file build deps
import Control.Lens ( preview )

-- create a datatype for the USD data structure 
data USD = USD {
    code :: String,
    rate :: String
} deriving (Show, Generic)

instance FromJSON USD
instance ToJSON USD

-- create a datatype for the BPIs data structure with all the currency's

data BPIS = BPIS {
   usd :: Object,
   gbp :: Object,
   eur :: Object
} deriving (Show, Generic)

instance FromJSON BPIS
instance ToJSON BPIS

-- create a datatype for the BPI key 


data BPI = BPI {
   bpi :: Object
} deriving (Show, Generic)

instance FromJSON BPI
instance ToJSON BPI

parse :: L8.ByteString -> Either String BPI
parse json = eitherDecode json :: Either String BPI


-- commented out for now, this works with the print function commented out on main
--getRateGBP :: L8.ByteString -> Maybe Text
--getRateGBP = preview (key "bpi" . key "GBP" . key "rate" . _String)

--getRateUSD :: L8.ByteString -> Maybe Text
--getRateUSD = preview (key "bpi" . key "USD" . key "rate" . _String)

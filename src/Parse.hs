{-# LANGUAGE TemplateHaskell #-}
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


-- 1. create a datatype for the all the currency's
-- added a field label modifier to try to recognise USD key instead of usd, didn't work

data Currencys = Currencys {
   gbp :: Object,
   usd :: Object,
   eur :: Object
} deriving (Show, Generic)

{-
$(deriveFromJSON defaultOptions {
    fieldLabelModifier = let f "usd" = "USD"
                             f other = other
                         in f
} ''Currencys) -}

instance FromJSON Currencys
instance ToJSON Currencys

-- 2. create a datatype for the specific USD data structure 
data USD = USD {
     codes :: String,
     rates :: String
 } deriving (Show, Generic)

instance FromJSON USD
instance ToJSON USD

-- 3. create a datatype for the whole BPI object 

data BPI = BPI {
   bpi :: Object
} deriving (Show, Generic)

instance ToJSON BPI where 
instance FromJSON BPI

parse :: L8.ByteString -> Either String BPI
parse json = eitherDecode json :: Either String BPI

-- (TESTING) new function to try to return just USD object, used with print (parseUSD json) in main, returns the whole json

parseUSD :: L8.ByteString -> Either String Currencys
parseUSD json = eitherDecode json :: Either String Currencys

{- (TESTING) Maybe we need to build a data type like this 
data Coord = Coord { code :: String, rate :: String }

instance ToJSON Coord where
  toJSON (Coord x y) = object ["x" .= x, "y" .= y]

  toEncoding (Coord x y) = pairs ("x" .= x <> "y" .= y)
-}

-- commented out for now, this works with the print function commented out on main
--getRateGBP :: L8.ByteString -> Maybe Text
--getRateGBP = preview (key "bpi" . key "GBP" . key "rate" . _String)

-- getRateUSD :: L8.ByteString -> Maybe Text
-- getRateUSD = preview (key "bpi" . key "USD" . key "rate" . _String)

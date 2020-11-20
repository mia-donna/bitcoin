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



getRateGBP :: L8.ByteString -> Maybe Text
getRateGBP = preview (key "bpi" . key "GBP" . key "rate" . _String)

getRateUSD :: L8.ByteString -> Maybe Text
getRateUSD = preview (key "bpi" . key "USD" . key "rate" . _String)

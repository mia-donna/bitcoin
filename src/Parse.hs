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



parse :: L8.ByteString -> Maybe Text
parse = preview (key "bpi" . key "USD" . key "rate" . _String)


